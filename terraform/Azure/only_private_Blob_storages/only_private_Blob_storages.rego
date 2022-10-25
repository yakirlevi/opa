package torque

import input as tfplan

# --- Validate blob storage are private ---

deny[reason] {
    resources:= tfplan.resource_changes[_]
    resources.type == "azure_blob_storage"
    resources.change.after.acl != "private"
    reason:= "Deployment of not private Blob storage is not allowed"
}
