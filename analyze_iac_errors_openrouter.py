import os
import glob
import json
from time import time
import pandas as pd
from typing import Dict
from tqdm import tqdm
from openai import OpenAI

# Initialize the OpenAI client pointing to the OpenRouter endpoint
client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=os.getenv("OPENROUTER_API_KEY")
)

# OpenRouter Specific settings
# Find available models at: https://openrouter.ai/docs/models
EVALUATOR_MODEL = "arcee-ai/trinity-large-preview:free" # or "anthropic/claude-3.5-sonnet", "google/gemini-1.5-pro"

# Define the folders containing your Claude conversations
FOLDERS_TO_ANALYZE = [
    "iterative/history/claude/claude-3-5-sonnet-20241022",
    # "iterative/history/claude/claude-3-7-sonnet-20250219"
]

# Define the taxonomy based on standard IaC LLM generation issues and your PDF
ERROR_TAXONOMY = """
1. Hallucination: Inventing AWS/Azure/GCP resources, parameters, or properties that do not exist in the official provider documentation.
2. Incompleteness: Missing required parameters, missing resource blocks, or failing to complete the infrastructure setup requested (Note: Do NOT apply this to the final truncated output, only apply this if the AI logically missed components in its design).
3. Reasoning Failure/Logic Error: Incorrect dependencies (e.g., missing `depends_on`), circular dependencies, or logically misconfigured networking.
4. Syntax/Formatting Error: HCL/JSON syntax violations, missing brackets, incorrect string interpolation.
5. Deprecated Features: Using legacy arguments or attributes that have been removed in recent provider versions.
6. Context Ignored: Failing to follow specific constraints requested by the user in the prompt.
7. No Error / Correct: The generated code satisfies the intent without requiring user corrections.
"""

SYSTEM_PROMPT = f"""
You are an expert Cloud Architect and AI evaluator. Your task is to analyze a conversation history between a user and an AI assistant generating Infrastructure as Code (IaC).

CRITICAL INSTRUCTIONS: 
1. The full IaC code templates in these text files are intentionally truncated to save space. DO NOT flag the code as "Incomplete" or erroneous simply because the text cuts off at the end.
2. Your primary focus must be on the ERROR PATTERNS and the ITERATION process. Pay close attention to the back-and-forth: what error messages does the user report back to the AI, and why did the AI fail initially?

Analyze the underlying errors that necessitated these iterations based on the following taxonomy:
{ERROR_TAXONOMY}

Return your analysis strictly in JSON format (without markdown tag) with the following keys:
- "has_error": boolean (true if the user reported errors and required iterations, false if the first generation was accepted without issue)
- "primary_category": The most severe error category from the taxonomy that triggered the iterations (string)
- "secondary_categories": List of other applicable error categories seen during the back-and-forth (list of strings)
- "iteration_count": The number of follow-up corrections/prompts the user had to provide to fix the AI's code (integer)
- "iteration_summary": A brief summary of the specific errors the user reported and how the AI addressed them (string)
- "root_cause_explanation": A concise explanation of why the AI made the error in the first place (string)
"""

def analyze_conversation(file_path: str, text_content: str) -> Dict:
    """Sends the conversation to OpenRouter to categorize the IaC iteration errors."""
    try:
        response = client.chat.completions.create(
            model=EVALUATOR_MODEL,
            extra_headers={
                "HTTP-Referer": "https://localhost", 
                "X-Title": "IaC Iteration Analyzer",
            },
            response_format={ "type": "json_object" }, 
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": f"Analyze this conversation log:\n\n{text_content[:15000]}"}
            ],
            temperature=0.1
        )
        
        result_content = response.choices[0].message.content
        print(f"Raw response for {file_path}:\n{result_content}\n")
        result_json = json.loads(result_content)
        
        # Attach metadata
        result_json['file_path'] = file_path
        result_json['model_version'] = "claude-3.5" if "3-5" in file_path else "claude-3.7"
        
        return result_json
    
    except json.JSONDecodeError:
        print(f"Failed to parse JSON for {file_path}.")
        return {
            "file_path": file_path,
            "has_error": True,
            "primary_category": "JSON Parsing Error",
            "secondary_categories": [],
            "iteration_count": 0,
            "iteration_summary": "Model failed to return valid JSON.",
            "root_cause_explanation": "Parsing failure",
            "model_version": "unknown"
        }
    except Exception as e:
        print(f"API Error analyzing {file_path}: {e}")
        return {
            "file_path": file_path,
            "has_error": True,
            "primary_category": "API Request Failed",
            "secondary_categories": [],
            "iteration_count": 0,
            "iteration_summary": "API failure.",
            "root_cause_explanation": str(e),
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
        return
        
    results = []
    
    for file_path in tqdm(all_files, desc=f"Analyzing with {EVALUATOR_MODEL}"):
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        analysis = analyze_conversation(file_path, content)
        results.append(analysis)
        
    # Save raw JSON results
    timestamp = int(time())
    with open(f"iac_iteration_analysis_raw_{EVALUATOR_MODEL}_{timestamp}.json", 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2)
        
    # Convert to Pandas DataFrame for CSV export
    df = pd.DataFrame(results)
    
    if 'secondary_categories' in df.columns:
        df['secondary_categories'] = df['secondary_categories'].apply(
            lambda x: ", ".join(x) if isinstance(x, list) else x
        )
    
    csv_filename = f"iac_iteration_analysis_summary_{EVALUATOR_MODEL}_{timestamp}.csv"
    df.to_csv(csv_filename, index=False)
    print(f"\nAnalysis complete! Results saved to {csv_filename}")
    
    print("\n--- ERROR DISTRIBUTION SUMMARY ---")
    if 'has_error' in df.columns and 'primary_category' in df.columns:
        summary = df[df['has_error'] == True]['primary_category'].value_counts()
        for category, count in summary.items():
            print(f"{category}: {count}")
            
    if 'iteration_count' in df.columns:
        avg_iterations = df[df['has_error'] == True]['iteration_count'].mean()
        print(f"\nAverage iterations required to fix errors: {avg_iterations:.2f}")

if __name__ == "__main__":
    main()