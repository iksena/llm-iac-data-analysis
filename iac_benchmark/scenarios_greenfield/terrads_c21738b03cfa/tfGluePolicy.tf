#-------------------------------------------------------------------------------------
#-- Role Glue para Ingestão de Dados
#-------------------------------------------------------------------------------------
resource "aws_iam_role" "glue_role_ingestion_resource" {
  name               = "${var.glueingestionrole}-${local.account_id}"
  assume_role_policy = data.aws_iam_policy_document.glue_role_ingestion.json
}


resource "aws_iam_role_policy" "policylambdabronze" {
  name   = "${var.glueingestionpolicy}-${local.account_id}"
  role   = aws_iam_role.glue_role_ingestion_resource.id
  policy = data.aws_iam_policy_document.glue_policy_ingestion.json
}
