package policy

import input as tfplan
import future.keywords.every



# --- Validate allowed regions ---

default region_is_allowed = false

region_is_allowed {
	region:= tfplan.configuration.provider_config.aws.expressions.region.constant_value
	is_allowed_region(region)
}
region_is_allowed {
	region_vars_name:= trim_prefix(input.configuration.provider_config.aws.expressions.region.references[0], "var.")
	region:= tfplan.variables[region_var_name].value	
	is_allowed_region(region)
}

is_allowed_region(region) {
	{"eu-west-1", "us-west-1"}[region]
}


# --- Validate S3 bucket is not public ---

default s3_acl_is_allowed = false

s3_acl_is_allowed {
	tfplan.resource_changes[_].type!="aws_s3_bucket"
}
s3_acl_is_allowed {
	resources := tfplan.resource_changes[_]
	resources.type == "aws_s3_bucket_acl"
	
        resources.change.after.acl == "private"
}

# --- Validate allowed resources ---

default resources_are_allowed = false

resources_are_allowed {
    resource := tfplan.resource_changes[_]
    is_allowed_resource_type(resource.type)

    actions := resource.change.actions
    is_resource_action_allowed(actions)
}

is_allowed_resource_type(resource) {
  resource_types:={"aws_security_group", "aws_instance", "aws_s3_bucket", "aws_db_instance"}
  resource_types[resource]
}

is_resource_action_allowed(actions) {
    allowed_actions = ["create", "update"] # 'destroy' is irrelevant

    every action in actions {
    	contains(allowed_actions, action) 
    }
}

contains(arr, elem) {
  arr[_] = elem
}


# --- Validate instance types ---


default allowed_instance_type = false


allowed_instance_type {
    resource := tfplan.resource_changes[_]

    # registry.terraform.io/hashicorp/aws -> aws
    provider_name := get_basename(resource.provider_name)

    instance_type_keys:= {
	"aws": ["instance_class", "instance_type"],
	"azurerm": ["vm_size"]
    }

    is_allowed_instance_type(resource, provider_name, instance_type_keys)
}

get_basename(path) = basename{
    arr := split(path, "/")
    basename:= arr[count(arr)-1]
}

is_allowed_instance_type(resource, provider_name, instance_type_keys) {
    every it in instance_type_keys[provider_name] {
      not resource.change.after[it]
   }
}
is_allowed_instance_type(resource, provider_name, instance_type_keys) {
    allowed_types := {
	"aws": ["t2.nano", "t2.micro", "db.t2.small"],
        "azurerm": ["Standard_A0", "Standard_A1"]
    }

    some provider_its in instance_type_keys[provider_name]
    instance_types:=[resource.change.after[provider_its]]

    every it in instance_types {
        contains(allowed_types[provider_name], it)
    }
}


# --- Validate providers ---



default provider_is_allowed = false



provider_is_allowed {
    provider_name:=get_basename(tfplan.resource_changes[_].provider_name)
    is_allowed_provider(provider_name)
}



is_allowed_provider(provider_name) {
    {"aws"}[provider_name]
}
