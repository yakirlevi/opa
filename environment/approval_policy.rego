package torque.environment

import future.keywords.if

default status := "approval_required"
default reason := ""



result := { "decision": "Denied", "reason": "sandbox duration exceed max duration" } if {
    data.max_duration < input.duration
} else := { "decision": "Manual", "reason": "sandbox duration require approval" } if {
    data.duration_for_manual < input.duration
} else := { "decision": "Approved" } if {
    data.duration_for_manual > input.duration
}

# decision := "deny" if {
#     data.max_duration < input.duration_minutes
#     reason := "aaa"
# } else := "manual_approval" if {
#     data.duration_for_manual < input.duration_minutes
# } else := "approved" if {
#     data.duration_for_manual > input.duration_minutes
# }

# reason := "duration required manual approve" if data.duration_for_manual < input.duration

# decision := "deny" if data.max_duration < input.duration
# reason := "Given duration not allowed" if data.max_duration < input.duration
    

# deny[reason] {
#     data.max_duration > input.duration
#     reason := "Duration is too long"
# }
# reason = "Sandbox duration required approval from admin." 
# {
# 	status == "approval_required"
# }
