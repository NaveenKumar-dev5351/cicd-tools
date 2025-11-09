locals {
    ami_id = "973714476881"
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = "true"
    }
}