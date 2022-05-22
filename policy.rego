default region_is_allowed = false



region_is_allowed {
	region:= input.configuration.provider_config.aws.expressions.region.constant_value
	is_allowed(region)
}



region_is_allowed {
	region_var_name:= trim_prefix(input.configuration.provider_config.aws.expressions.region.references[0], "var.")
	region:= input.variables[region_var_name].value
	is_allowed(region)
}



is_allowed(region){
	{"eu-west-1"}[region]
}

