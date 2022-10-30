# Qulai Torque built-in OPA policy templates

OPA template collection to create Torque security policies.

## Resources

* Documentation for using policies in Torque: https://docs.qtorque.io/admin-guide/security-policies#how-to-add-a-security-policy

* OPA documentation: https://www.openpolicyagent.org/docs/latest/

## Policy In Torque

Torque allows adding a security policy based on the OPA policy templates that this repo contains. As described in the documentation above, account admin users can create an instance from a template, specify the external data values, and define the enforcement scope - the whole account or specific spaces.

## Policy Template Files

Each template folder includes 3 file types.

- `*.rego`: The OPA policy
- `*_test.rego`: Tests 
- `*_mock.json`: Mocked 'input' data for the tests

## Policy Evaluation

### Policy Input Genenraion

OPA policy evaluation requires a json file as 'input', which means the data should be enforced.

For example, Terraform allows plan json creation by the following commands using Terraform CLI:
```bash
$ terraform init
$ terraform plan --out planfile
$ terraform show -json planfile > plan.json
```

### Adding External Data

Policy data can be overloaded by external json files and refers to their content, using *data.some_key* in the policy rego file.
Most of the templates in this repository use external data to enable dynamic behavior. The supporting structure includes one level of json, while the keys map to an array of strings.

### Perform Policy Evaluation
Policy evaluation can be performed using the `opa eval` command as follows.

```bash
$ opa eval --format pretty --data {PATH_TO_REGO_FILE} --input {PATH_TO_INPUT_JSON_FILE} {PATH_TO_QUERY}
```

- `PATH_TO_REGO_FILE`: Path to the policy rego file
- `PATH_TO_INPUT_JSON_FILE`: Path to the 'input' json file
- `PATH_TO_QUERY`: The query against the policy data and the 'input', should start with `data`. For example, the query `data.torque` - will evaluate all the rules defined in the package called *'torque'*.

- In order to overload the policy data as part of the evaluation, per every json file add "`--data `" and then the required file path.

## Contributions

We welcome contributions!

### Pull Requests

Fixing bugs or implementing new policy templates and submitting a Pull Request.

A new policy must include the following files in a dedicated folder:
* The `*.rego` file with the policy code, includes the package name `torque`  and at least one rule called `deny`, which returns an array of error message strings in case of failure.
* `*_test.rego` defining the tests to be run and expected results when the PR checks are performed. All test names in this file should start with the prefix `test_`.
* `*_mock.json` containing test data mocks. You should include data for both valid and invalid evaluations of each rule in the policy.

To submit a PR follow the standard process.

1. Fork the repository
2. Clone locally and create a new branch
3. Commit and push
4. Submit a pull request

Before submitting the PR for the new policy or bug fix you should confirm it works using `opa eval` as shown above and validates the mock-based tests work using `opa test` command against the policy files folder.

Tests evaluation example:

```
# opa test {PATH_TO_FOLDER} -v
data.terraform.test_allow_valid: PASS (7.390419ms)
data.terraform.test_deny_invalid: PASS (603.838µs)
data.terraform.test_validate_deny_message: PASS (483.273µs)
--------------------------------------------------------------------------------
PASS: 3/3
```