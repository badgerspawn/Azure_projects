#!/bin/bash

# Check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
    echo "Error: jq is not installed. Please install jq to use this script."
    exit 1
fi

# Ensure the environment is specified
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi

ENV_DIR=$1
ROOT_DIR=$(pwd)
CONFIG_DIR="$ROOT_DIR/config"
TERRAFORM_DIR="$ROOT_DIR/terraform"
OUTPUT_FILE="$TERRAFORM_DIR/$ENV_DIR.auto.tfvars"

# Check if the environment directory exists
if [ ! -d "$CONFIG_DIR/$ENV_DIR" ]; then
    echo "Error: Environment '$ENV_DIR' does not exist."
    exit 1
fi

# Check if root config and secrets files exist
if [ ! -f "$CONFIG_DIR/secrets.json" ] || [ ! -f "$CONFIG_DIR/$ENV/secrets.json" ]; then
    echo "Error: 'secrets.json' is missing in the config or environment directory."
    exit 1
fi

# Read the contents of config/secrets.json
SECRETS=$(jq -r 'to_entries | .[] | "\(.key)=\(.value)"' $CONFIG_DIR/secrets.json)

# Read the contents of config/<ENV>/secrets.json
ENV_SECRETS=$(jq -r 'to_entries | .[] | "\(.key)=\(.value)"' $CONFIG_DIR/$ENV/secrets.json)

# Combine the two sets of secrets
ALL_SECRETS="$SECRETS\n$ENV_SECRETS"

# Write the secrets to terraform/<ENV>.env
echo "$ALL_SECRETS" | awk -F= 'BEGIN { OFS = "=" } { print "TF_" $1, $2 }' > terraform/$ENV.env


