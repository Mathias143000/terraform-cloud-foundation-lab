bucket         = "terraform-cloud-foundation-state"
key            = "demo/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-cloud-foundation-locks"
encrypt        = false
use_path_style = true

access_key                  = "test"
secret_key                  = "test"
skip_credentials_validation = true
skip_metadata_api_check     = true
skip_requesting_account_id  = true

endpoints = {
  s3       = "http://localstack:4566"
  dynamodb = "http://localstack:4566"
}
