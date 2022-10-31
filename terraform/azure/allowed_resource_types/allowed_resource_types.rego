package torque

import input as tfplan

deny[reason] {
    allowed_set:= { x | x:= data.allowed_resource_types[_] }
    results_set:= { r | r:= tfplan.resource_changes[_].type }
    diff:= results_set - allowed_set
    
    # print("allowed_set:       ", allowed_set)
    # print("used_locations:    ", results_set)
    # print("diff:              ", diff)

    count(diff) > 0 # if true -> deny! and return this error ("reason") below
    reason:= concat("", ["Invalid resource type: '", sprintf("%s", [results_set[_]]), "'. The allowed Azure resource types are: ", sprintf("%s", [data.allowed_resource_types])])
}
