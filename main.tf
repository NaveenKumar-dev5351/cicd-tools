resource "aws_instance" "jenkins" {
    ami = local.ami_id
    instance_type = "t3.small"
    vpc_security_group_ids = [aws_security_group.main.id]

    root_block_device {
        volume_size = 50
        volume_type = gp3
    }

    user_data = file("jenkins.sh")
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-jenkins"
        }
    )
}

resource "aws_instance" "jenkins-agent" {
    ami = local.ami_id
    instance_type = "t3.small"
    vpc_security_group_ids = [aws_security_group.main.id]

    root_block_device {
        volume_size = 50
        volume_type = gp3
    }

    user_date = file("jenkins-agent.sh")
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-jenkins-agent"
        }
        
    )

}

resource "aws_security_group" "main" {
    name ="${var.project}-${var.environment}-jenkins"
    description = "created for jenkins"

    ingress {
        from_port = 0
        to_port   = 0 
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-jenkins"
        }
    )
}

resource "aws_route53_record" "jenkins" {
    zone_id = "${var.zone_id}"
    zone_name = "jenkins.${var.zone_name}"
    type = "A"
    ttl = "1"
    records = [aws_instance.jenkins.public_ip]
    allow_overwrite = true
}

resource "aws_route53_record" "jenkins-agent" {
    zone_id = "${var.zone_id}"
    zone_name = "${var.zone_name}"
    type = "A"
    ttl = "1"
    records = [aws_instance.jenkins-agent.private_ip]
    allow_overwrite = true
}