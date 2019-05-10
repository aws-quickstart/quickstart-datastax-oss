#!/bin/sh
bucket=scotth-ddac-test

echo "Setting up $bucket"

aws s3 sync ./templates/ s3://$bucket/quickstart-datastax-ddac/templates/
aws s3 sync ./submodules/quickstart-aws-vpc/templates/ s3://$bucket/quickstart-datastax-ddac/submodules/quickstart-aws-vpc/templates/
aws s3 sync ./scripts/ s3://$bucket/quickstart-datastax-ddac/scripts/

aws cloudformation create-stack  --region us-west-2 --stack-name scotth-ddac-dev  --disable-rollback  --capabilities CAPABILITY_IAM  --template-body file://$(pwd)/templates/datastax-ddac-master.template.yaml  --parameters file://$(pwd)/minimal-west.json
