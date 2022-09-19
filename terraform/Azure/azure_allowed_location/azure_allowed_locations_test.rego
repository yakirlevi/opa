package torque

test_azure_allowed_locations {
  result:= deny 
                with input as data.plan_mock
                with data.azure_allowed_locations as ["eastus"]                
  count(result) == 0
}

test_deny_unsupported_location {
  result:= deny 
                with input as data.plan_mock
                with data.azure_allowed_locations as ["eastus2", "westus2"] 
  count(result) == 1
}

test_validate_deny_message {
  result:= deny 
                with input as data.plan_mock
                with data.azure_allowed_locations as ["eastus2", "westus2"] 
  expected_deny_message:= "Invalid location: 'eastus'. The allowed locations are: [\"eastus2\", \"westus2\"]"
  result[expected_deny_message]
}
