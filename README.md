# Qulai Torque built-in OPA policy templates

A OPA template collection to create Torque security policies.

## Resources

* Documentation for using policies in Torque: https://docs.qtorque.io/admin-guide/security-policies#how-to-add-a-security-policy
* OPA documentation: https://www.openpolicyagent.org/docs/latest/

## Policy Template Files

Each template folder includes 3 file types.

- `*.rego`: The OPA policy
- `*.test.rego`: Tests 
- `*.mock.json`: Mocked 'input' data for the tests

## OPA Policy Evaluation
### OPA Policy Input Genenraion
OPA policy evaluation requires a json file as 'input', which means the data should be enforced.

For example, Terraform allows plan json creation by the following commands using Terraform CLI:
```bash
$ terraform init
$ terraform plan --out planfile
$ terraform show -json planfile > plan.json
```
### Perform OPA Policy Evaluation
Policy evaluation can be performed using the `opa eval` command as follows.

###### --data {path_to_variables_json_file}

```bash
$ opa eval --format pretty --data {PATH_TO_REGO_FILE} --input {PATH_TO_INPUT_JSON_FILE} {PATH_TO_QUERY}
```

- `PATH_TO_REGO_FILE`: Path to the policy rego file
- `PATH_TO_INPUT_JSON_FILE`: Path to the 'input' json file
- `PATH_TO_QUERY`: The query against the policy data and the 'input', should start with "data". For example, the query "data.torque" - will evaluate all the rules defined in the package called 'torque'.

* Policy data can be overloaded by external json files and refers to their content (in the policy logic: data.some_key). In order to overload the policy data as part of the evaluation, per every json file add "--data " and then the  path to the required file.