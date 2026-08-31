module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "feedmyfurbabies"

  create_archives = true

  rules = {
    feeds = {
      description   = "Capture all Feed My Fur Babies data"
      event_pattern = jsonencode({ "source" : ["com.feedmyfurbabies"] })
      enabled       = true
    }
  }

  targets = {
    feeds = [
      {
        name = "feed"
        arn  = module.eventbridge_target_function.lambda_function_arn
      }
    ]
  }

  tags = {
    Name = "feedmyfurbabies"
  }
}

