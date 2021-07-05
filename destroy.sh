aws ec2 describe-instances | jq '."Reservations"[] | ."Instances"[] | ."InstanceId",."PublicIpAddress"'
cd terraform-ec2
terraform destroy
