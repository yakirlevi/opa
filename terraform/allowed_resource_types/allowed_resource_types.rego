package torque

import input as tfplan

# --- Validate resource types ---

contains(arr, elem){
    arr[_] == elem
}

deny[reason] {
    resource_type:= tfplan.resource_changes[_].type
    not contains(data.allowed_resource_types, resource_type)
    reason:= concat("",["Invalid resource type: '", resource_type, "'. The allowed resource types are: ", sprintf("%s", [data.allowed_resource_types])])
}
