terraform {
    backend "s3" {
        bucket = "statefile-host-bucket"
        key = "houseofcards/terraform.tfstate"
        region = "ap-south-1"
        dynamodb_table = "statefile-host-dynamo"
        encrypt = true
        use_lockfile = true
    }
}
