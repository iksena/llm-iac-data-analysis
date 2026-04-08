resource "aws_s3_bucket" "lifecycle" {
  bucket = "efcunha-lifecycle"
  #bucket = "efcunha-lifecycle-2" //descomente para testar com create_before_destroy = true

  lifecycle {
    #create_before_destroy = true
    #prevent_destroy = true
    ignore_changes = [tags, ]
  }

  tags = {
    aula = "lifecycle"
  }
}