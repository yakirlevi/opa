package torque

test_allowed_resource_types {
  result:= deny 
                with input as data.plan_mock
                with data.allowed_resource_types as ["azure_blob_storage"] 
  count(result) == 0
}

test_deny_unsupported_resource_types {
  result:= deny 
                with input as data.plan_mock
                with data.allowed_resource_types as ["azure_vm", "azure_date_lake_storage"] 
  count(result) == 1
}

test_validate_deny_message {
  result:= deny 
                with input as data.plan_mock
                with data.allowed_resource_types as ["azure_vm", "azure_date_lake_storage"] 
  expected_deny_message:= "Invalid resource type: 'azure_blob_storage'. The allowed resource types are: [\"azure_vm\", \"azure_date_lake_storage\"]"
  result[expected_deny_message]
}
