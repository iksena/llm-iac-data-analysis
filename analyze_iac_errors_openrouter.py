import os
import glob
import json
import pandas as pd
from typing import Dict
from tqdm import tqdm
from openai import OpenAI

# Initialize the OpenAI client pointing to the OpenRouter endpoint
# It will automatically look for the OPENROUTER_API_KEY environment variable if passed explicitly
client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=os.getenv("OPENROUTER_API_KEY")
)

# OpenRouter Specific settings
# Find available models at: https://openrouter.ai/docs/models
EVALUATOR_MODEL = "openai/gpt-oss-20b:free" # or "anthropic/claude-3.5-sonnet", "google/gemini-1.5-pro"

# Define the folders containing your Claude conversations
FOLDERS_TO_ANALYZE = [
    "iterative/history/claude/claude-3-5-sonnet-20241022",
    "iterative/history/claude/claude-3-7-sonnet-20250219"
]

# Define the taxonomy based on standard IaC LLM generation issues and your PDF
ERROR_TAXONOMY = """
1. Hallucination: Inventing AWS/Azure/GCP resources, parameters, or properties that do not exist in the official provider documentation.
2. Incompleteness: Missing required parameters, missing resource blocks, or failing to complete the infrastructure setup requested.
3. Reasoning Failure/Logic Error: Incorrect dependencies (e.g., missing `depends_on`), circular dependencies, or logically misconfigured networking (e.g., putting a public IP in a private subnet).
4. Syntax/Formatting Error: HCL/JSON syntax violations, missing brackets, incorrect string interpolation.
5. Deprecated Features: Using legacy arguments or attributes that have been removed in recent provider versions.
6. Context Ignored: Failing to follow specific constraints requested by the user in the prompt.
7. No Error / Correct: The generated code perfectly satisfies the intent and is syntactically/semantically correct.
"""

SYSTEM_PROMPT = f"""
You are an expert Cloud Architect and AI evaluator. Your task is to analyze a conversation between a user and an AI assistant generating Infrastructure as Code (IaC).
Analyze the AI's response for any errors based on the following taxonomy:

{ERROR_TAXONOMY}

Return your analysis strictly in JSON format with the following keys:
- "has_error": boolean (true if there are errors, false if correct)
- "primary_category": The most severe error category from the taxonomy (string)
- "secondary_categories": List of other applicable error categories (list of strings)
- "explanation": A brief, specific explanation of why the code failed or what was wrong (string)
- "problematic_code_snippet": The specific lines of code that contain the error (string, or null)
"""

def analyze_conversation(file_path: str, text_content: str) -> Dict:
    """Sends the conversation to OpenRouter to categorize the IaC errors."""
    try:
        response = client.chat.completions.create(
            model=EVALUATOR_MODEL,
            # OpenRouter optional headers for ranking/analytics
            extra_headers={
                "HTTP-Referer": "https://localhost", # Replace with your site URL if you have one
                "X-Title": "IaC Error Analyzer",     # Replace with your app name
            },
            # Using JSON object response format. 
            # Note: Make sure the model you pick on OpenRouter supports this!
            response_format={ "type": "json_object" }, 
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": f"Analyze this conversation:\n\n{text_content[:15000]}"}
            ],
            temperature=0.1
        )
        
        # Parse the JSON string returned by the model
        result_content = response.choices[0].message.content
        result_json = json.loads(result_content)
        
        # Attach metadata to the result
        result_json['file_path'] = file_path
        result_json['model_version'] = "claude-3.5" if "3-5" in file_path else "claude-3.7"
        
        return result_json
    
    except json.JSONDecodeError as e:
        print(f"Failed to parse JSON for {file_path}. Raw output: {result_content}")
        return {
            "file_path": file_path,
            "has_error": True,
            "primary_category": "JSON Parsing Error",
            "secondary_categories": [],
            "explanation": "Model failed to return valid JSON.",
            "problematic_code_snippet": None,
            "model_version": "unknown"
        }
    except Exception as e:
        print(f"API Error analyzing {file_path}: {e}")
        return {
            "file_path": file_path,
            "has_error": True,
            "primary_category": "API Request Failed",
            "secondary_categories": [],
            "explanation": str(e),
            "problematic_code_snippet": None,
            "model_version": "unknown"
        }

def main():
    if not os.getenv("OPENROUTER_API_KEY"):
        print("ERROR: Please set the OPENROUTER_API_KEY environment variable.")
        return

    all_files = []
    for folder in FOLDERS_TO_ANALYZE:
        if os.path.exists(folder):
            all_files.extend(glob.glob(os.path.join(folder, "*.txt")))
    
    print(f"Found {len(all_files)} conversation files to analyze.")
    if len(all_files) == 0:
        print("No files found. Please check your folder paths.")
        return
        
    results = []
    
    # Process files with a progress bar
    for file_path in tqdm(all_files, desc=f"Analyzing with {EVALUATOR_MODEL}"):
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        analysis = analyze_conversation(file_path, content)
        results.append(analysis)
        
    # Save raw JSON results in case something goes wrong with CSV conversion
    with open('iac_error_analysis_raw.json', 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2)
        
    # Convert to Pandas DataFrame for CSV export
    df = pd.DataFrame(results)
    
    # Format list into comma-separated string for CSV readability
    if 'secondary_categories' in df.columns:
        df['secondary_categories'] = df['secondary_categories'].apply(
            lambda x: ", ".join(x) if isinstance(x, list) else x
        )
    
    # Save to CSV
    csv_filename = "iac_error_analysis_summary.csv"
    df.to_csv(csv_filename, index=False)
    print(f"\nAnalysis complete! Results saved to {csv_filename}")
    
    # Print a quick summary report to the console
    print("\n--- ERROR DISTRIBUTION SUMMARY ---")
    if 'has_error' in df.columns and 'primary_category' in df.columns:
        summary = df[df['has_error'] == True]['primary_category'].value_counts()
        for category, count in summary.items():
            print(f"{category}: {count}")

if __name__ == "__main__":
    main()