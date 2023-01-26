include "root" {
  path = find_in_parent_folders()
}

terraform {
  before_hook "pre-check" {
      commands = ["apply","plan"]
      execute  = ["./pre-check.sh"]
  }

  extra_arguments "checktype" {
      commands = ["apply","plan"]
      arguments = []
      env_vars = {
          XCSITETYPES = "aws_vpc_sites"
      }
  }  
}


dependencies {
  paths = ["../azure-site-1","../aws-vpc-site-1"]
}

dependency "infrastructure" {
  config_path = "../aws-base-1"
}

inputs = {
  instanceSuffix        = "1"
  awsRegion             = "us-east-1"
  spokeExternalSubnets  = dependency.infrastructure.outputs.spokeExternalSubnets
  spokeWorkloadSubnets  = dependency.infrastructure.outputs.spokeWorkloadSubnets
  spokeSecurityGroup    = dependency.infrastructure.outputs.spokeSecurityGroup
  spoke2ExternalSubnets = dependency.infrastructure.outputs.spoke2ExternalSubnets
  spoke2WorkloadSubnets = dependency.infrastructure.outputs.spoke2WorkloadSubnets
  spoke2SecurityGroup   = dependency.infrastructure.outputs.spoke2SecurityGroup
}
