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
if [ ! -f "$CONFIG_DIR/config.json" ] || [ ! -f "$CONFIG_DIR/secrets.json" ]; then
    echo "Error: 'config.json' and/or 'secrets.json' are missing in the config directory."
    exit 1
fi

# Check if environment-specific config and secrets files exist
if [ ! -f "$CONFIG_DIR/$ENV_DIR/config.json" ] || [ ! -f "$CONFIG_DIR/$ENV_DIR/secrets.json" ]; then
    echo "Error: 'config.json' and/or 'secrets.json' are missing in the '$ENV_DIR' directory."
    exit 1
fi

echo "env = \"$ENV_DIR\"" > "$OUTPUT_FILE"

# Merge root config and secrets
ROOT_MERGED=$(jq -s '.[0] * .[1]' "$CONFIG_DIR/config.json" "$CONFIG_DIR/secrets.json")

# Merge environment-specific config and secrets
ENV_MERGED=$(jq -s '.[0] * .[1]' "$CONFIG_DIR/$ENV_DIR/config.json" "$CONFIG_DIR/$ENV_DIR/secrets.json")

# Merge root and environment-specific configurations, with environment overwriting root
FINAL_MERGED=$(echo "$ROOT_MERGED" | jq -s '.[0] * .[1]' - <(echo "$ENV_MERGED"))

# Convert the final JSON to Terraform variable format
echo "$FINAL_MERGED" | jq -r 'to_entries | map("\(.key) = \(.value | @json)") | .[]' >> "$OUTPUT_FILE"

echo "Environment '$ENV_DIR' tfvars generated."