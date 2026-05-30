terraform {
    backend "s3" {
        bucket = "statefile-host-bucket"
        key = "houseofcards/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
        use_lockfile = true
    }
}
