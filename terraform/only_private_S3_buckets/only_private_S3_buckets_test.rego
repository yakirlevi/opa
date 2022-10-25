package torque

test_allow_private_s3 {
  result:= deny with input as data.plan_mock.robotshop_private_s3
  count(result) == 0
}

test_allow_non_s3_types {
  result:= deny with input as data.plan_mock.aws_instance
  count(result) == 0
}

test_deny_s3_with_non_private_acl {
  result:= deny with input as data.plan_mock.public_read_write_s3
  count(result) == 1
}

test_validate_deny_message {
  result:= deny with input as data.plan_mock.public_read_write_s3
  expected_deny_message:= "Deployment of not private S3 bucket is not allowed"
  result[expected_deny_message]
}