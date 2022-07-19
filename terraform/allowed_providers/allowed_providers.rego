package torque

import input as tfplan

# --- Validate providers allowed names ---

get_basename(path) = basename{
    arr:= split(path, "/")
    basename:= arr[count(arr)-1]
}

contains(arr, elem) {
  arr[_] = elem
}

deny[reason] {
  provider_name:= get_basename(tfplan.resource_changes[_].provider_name)
  not contains(data.allowed_providers, provider_name)
  reason:= concat("",["Invalid provider: '", provider_name, "'. The allowed providers are: ", sprintf("%s", [data.allowed_providers])])
}
