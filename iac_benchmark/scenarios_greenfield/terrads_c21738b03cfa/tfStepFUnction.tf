# AWS Step Functions IAM roles and Policies
resource "aws_iam_role" "aws_stf_role" {
  name               = "aws-stf-role"
  assume_role_policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Action":"sts:AssumeRole",
         "Principal":{
            "Service":[
                "states.amazonaws.com"
            ]
         },
         "Effect":"Allow",
         "Sid":"StepFunctionAssumeRole"
      }
   ]
}
EOF
}

resource "aws_iam_role_policy" "step_function_policy" {
  name = "aws-stf-policy"
  role = aws_iam_role.aws_stf_role.id

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Action":[
                "glue:StartJobRun",
                "glue:GetJobRun",
                "glue:GetJobRuns",
                "glue:BatchStopJobRun"
         ],
         "Effect":"Allow",
         "Resource":[
         "${aws_glue_job.etl_jobs.arn}",
         "${aws_glue_job.transforma_job.arn}"
         ]
      }
  ]
}

EOF
}

# AWS Step function definition
resource "aws_sfn_state_machine" "aws_step_function_workflow" {
  name       = "aws-step-function-workflow"
  role_arn   = aws_iam_role.aws_stf_role.arn
  definition = <<EOF
{
    "Comment":"A description of the sample glue job state machine using Terraform",
    "StartAt":"Glue StartJobRun",
    "States": {

        "Glue StartJobRun": {
            "Type":"Task",
            "Resource":"arn:aws:states:::glue:startJobRun.sync",
            "Parameters": {
                "JobName":"${aws_glue_job.etl_jobs.name}",
                "Arguments": {
                    "--cidade":"${var.Cidade_API_Clima}",
                    "--bucketDataLakeStaging":"${var.bucket_staging_lake}-${local.account_id}",
                    "--pastaArqs":"clima",
                    "--api_key":"${var.key_api}"
                }
            },
            "Next": "Processa Dados"
         },

        "Processa Dados": {
            "Type":"Task",
            "Resource":"arn:aws:states:::glue:startJobRun.sync",
            "Parameters": {
                "JobName":"${aws_glue_job.transforma_job.name}",
                "Arguments": {
                    "--bucketDataLakeStaging":"${var.bucket_staging_lake}-${local.account_id}",
                    "--bucketDataLakeBronze":"${var.bucket_bronze_lake}-${local.account_id}",
                    "--bucketDataLakeSilver":"${var.bucket_silver_lake}-${local.account_id}",
                    "--pastaArqs":"clima",
                    "--key":"${var.keyTraduz}"
               }
            },
            "End":true
        }
    }
}
EOF

}

# {
#     "Comment": "Example to trigger Glue Job from Step Function",
#     "StartAt": "Trigger Glue",
#     "States": {
#           "Trigger Glue": {
#               "Type": "Task",
#               "Resource": "arn:aws:states:::glue:startJobRun.sync",
#               "Parameters": {
#                   "JobName": "mypythonjob"
#               },
#               "Next": "Send Completion Email"
#           },
#           "Send Completion Email": {
#               "Type": "Task",
#               "Resource": "arn:aws:states:::sns:publish",
#               "Parameters": {
#                   "Message": {
#                       "Input": "Glue Job Completed !"
#                   },
#                   "TopicArn": "<Topic ARN>"
#               },
#               "End": true
#           }
#       }
#   }