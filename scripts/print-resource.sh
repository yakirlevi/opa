resource_id=$1
contract_path=$CONTRACT_FILE_PATH
apt update -y >& /dev/null
apt install -y jq >& /dev/null

# will print the attribute "day" of the resource
jq --arg id "$resource_id" '.resources[] | select(.identifier == $id) | .attributes | .day' $contract_path
