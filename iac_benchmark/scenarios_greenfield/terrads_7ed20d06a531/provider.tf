#---------------------
# Virgina 
#---------------------
provider "aws" {
    alias = "source1"
    region = "us-east-1"
}

#---------------------
# Oregon
#---------------------
provider "aws" {
    alias = "source2"
    region = "us-west-2"
}

#----------------------
# Ohio Replca 1
#----------------------
provider "aws" {
    alias = "replica1"
    region = "us-east-2"
}

#----------------------
# N.California Relica 2 
#----------------------

provider "aws" {
    alias = "replica2"
    region = "us-west-1"
}