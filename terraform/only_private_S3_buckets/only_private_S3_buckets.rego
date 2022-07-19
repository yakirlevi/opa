package torque

import input as tfplan

# --- Validate S3 buckets acls are private ---

deny[reason] {
    resources:= tfplan.resource_changes[_]
    resources.type == "aws_s3_bucket"
    resources.change.after.acl != "private"
    reason:= "Deployment of not private S3 bucket is not allowed"
}
