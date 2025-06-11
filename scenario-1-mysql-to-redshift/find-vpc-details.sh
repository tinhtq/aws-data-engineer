#!/bin/bash

# Script to help find existing VPC and subnet details for DMS configuration

echo "🔍 Finding existing VPC and subnet details in ap-southeast-1..."
echo "=================================================="

# List all VPCs
echo "📋 Available VPCs:"
aws ec2 describe-vpcs \
  --region ap-southeast-1 \
  --query 'Vpcs[*].{VpcId:VpcId,CidrBlock:CidrBlock,Name:Tags[?Key==`Name`].Value|[0],IsDefault:IsDefault}' \
  --output table

echo ""
echo "📋 Private subnets (for DMS replication instance):"
echo "Note: DMS requires at least 2 subnets in different AZs"

# Get all private subnets (assuming they don't have route to internet gateway)
aws ec2 describe-subnets \
  --region ap-southeast-1 \
  --filters "Name=state,Values=available" \
  --query 'Subnets[*].{SubnetId:SubnetId,VpcId:VpcId,CidrBlock:CidrBlock,AvailabilityZone:AvailabilityZone,Name:Tags[?Key==`Name`].Value|[0]}' \
  --output table

echo ""
echo "💡 To use a specific VPC, update terraform.tfvars with:"
echo "vpc_id = \"vpc-xxxxxxxxx\""
echo "private_subnet_ids = [\"subnet-xxxxxxxxx\", \"subnet-yyyyyyyyy\"]"
echo ""
echo "⚠️  Important requirements:"
echo "- Use at least 2 private subnets in different AZs"
echo "- Subnets should have outbound internet access (via NAT Gateway) for DMS to work"
echo "- Make sure your MySQL and Redshift are accessible from these subnets"
