package torque

import input as tfplan

# --- Validate location ---

get_location(provider_name) = location{
    location_var_name:= trim_prefix(input.configuration.provider_config[provider_name].expressions.location.references[0], "var.")
    location:= tfplan.variables[location_var_name].value
}
get_location(provider_name) = location{
    location:= tfplan.configuration.provider_config[provider_name].expressions.location.constant_value
}

get_basename(path) = basename{
    arr:= split(path, "/")
    basename:= arr[count(arr)-1]
}

contains(arr, elem){
    arr[_] == elem
}

deny[reason] {
    provider_name:= get_basename(tfplan.resource_changes[_].provider_name) 
    location:= get_location(provider_name)
    not contains(data.allowed_locations, location)
    reason:= concat("",["Invalid location: '", location, "'. The allowed locations are: ", sprintf("%s", [data.allowed_locations])])
}
