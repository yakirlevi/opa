package torque.environment

import future.keywords.if

result := { "decision": "Denied", "reason": "Lab must have duration" } if {
  input.action_identifier.action_type == "Launch"  
  not contains(input, "duration_minutes")  
} else := { "decision": "Denied", "reason": "Lab duration exceeds max duration"  } if {
  input.action_identifier.action_type == "Launch"
  data.max_duration_minutes <= input.duration_minutes
}

result := { "decision": "Manual", "reason": "Lab duration requires approval" } if {
  input.action_identifier.action_type == "Launch"
  data.max_duration_minutes > input.duration_minutes
  data.duration_for_manual_minutes <= input.duration_minutes
}

result := { "decision": "Approved" } if {
  input.action_identifier.action_type == "Launch"
  data.duration_for_manual_minutes > input.duration_minutes
}

result := { "decision": "Approved" } if {
  input.action_identifier.action_type != "Launch"  
}
