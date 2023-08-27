provider "aws" {
  region = "us-west-2"  # Set your desired AWS region
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# Create Subnets
resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "SubnetA"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "SubnetB"
  }
}

# Create EKS Cluster
module "eks_cluster" {
  source         = "terraform-aws-modules/eks/aws"
  cluster_name   = "my-eks-cluster"
  # subnets        = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  vpc_id         = aws_vpc.my_vpc.id
  cluster_version = "1.23"
  control_plane_subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  # Additional settings can be configured here
}

# Create ECR Repository
resource "aws_ecr_repository" "my_app_repo" {
  name = "my-app-repo"
}

# Create RDS MySQL Database
resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.micro"
  # name                = "mydb"
  username            = "admin"
  password            = "Bukola12238"
  
  parameter_group_name = "default.mysql5.7"
  
  skip_final_snapshot = true
  
  tags = {
    Name = "MyDB"
  }
}
