provider "aws" {
    region  = var.region
    profile = var.profile
}  

module "vpc" {
    source = "../../modules/vpc" 

    vpc_cidr_block             = var.vpc_cidr_block
    enable_dns_hostnames       = var.enable_dns_hostnames
    enable_dns_support         = var.enable_dns_support
   
    pub_one_subnet_cidr_block  = var.pub_one_subnet_cidr_block
    pub_one_subnet_az          = var.pub_one_subnet_az
   
    private_subnet_cidr_block = var.private_subnet_cidr_block
    private_subnet_az         = var.private_subnet_az
}

module "sg" {
     source        = "../../modules/sg"
     vpc_id        = module.vpc.vpc_id
     sg_cidr_block = var.sg_cidr_block
     sg_id = var.sg_id

}
 
module "ec2_pub" {
    source                 = "../../modules/ec2"
    key_name               = var.pub_key_name
    instance_type          = var.pub_instance_type
    ami                    = var.pub_ami
    vpc_security_group_ids = [module.sg.sg_id]
    subnet_id              = module.vpc.pub_one_subnet_id 
}

module "ec2_priv" {
    source                 = "../../modules/ec2"
    key_name               = var.priv_key_name
    instance_type          = var.priv_instance_type
    ami                    = var.pub_ami
    vpc_security_group_ids = [module.sg.sg_id]
    subnet_id              = module.vpc.private_subnet_id
}