package torque

import input as tfplan

# --- Validate azure vm types ---

get_basename(path) = basename{
    arr := split(path, "/")
    basename:= arr[count(arr)-1]
}

contains(arr, elem){
    arr[_] == elem
}

deny[reason] {
    resource := tfplan.resource_changes[_]
    get_basename(resource.provider_name) == "azure"
    vm_type:= tfplan.resource_changes[_].change.after.vm_type
    contains(data.prohibited_vm_types, vm_type)
    reason:= concat("",["Invalid vm type: '", vm_type, "'. The prohibited vm types are: ", sprintf("%s", [data.prohibited_vm_types])])
}
