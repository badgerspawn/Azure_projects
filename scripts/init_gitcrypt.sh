#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Usage function to display help
usage() {
  echo "Usage: $0 -r <repo_path> -d <key_dir> -k <key_vault_name> -s <secret_name>"
  exit 1
}

# Parse arguments
while getopts "r:d:k:s:" opt; do
  case "$opt" in
    r) REPO_PATH="$OPTARG" ;;
    d) KEY_DIR="$OPTARG" ;;
    k) KEY_VAULT_NAME="$OPTARG" ;;
    s) SECRET_NAME="$OPTARG" ;;
    *) usage ;;
  esac
done

# Ensure all required arguments are provided
if [ -z "$REPO_PATH" ] || [ -z "$KEY_DIR" ] || [ -z "$KEY_VAULT_NAME" ] || [ -z "$SECRET_NAME" ]; then
  usage
fi

# Step 1: Navigate to the repository
echo "Navigating to repository at $REPO_PATH"
cd "$REPO_PATH" || { echo "Repository path not found!"; exit 1; }

# Step 2: Initialize git-crypt
echo "Initializing git-crypt"
#git-crypt init

# Step 3: Export the key
echo "Exporting git-crypt key to $SECRET_NAME"
git-crypt export-key "$SECRET_NAME"

# Step 4: Save the key to the specified directory
mkdir -p "$KEY_DIR"
mv "$SECRET_NAME" "$KEY_DIR/"
KEY_PATH="$KEY_DIR/$SECRET_NAME"
echo "Key saved to $KEY_PATH"

# Step 5: Base64 encode the key
ENCODED_KEY_FILE="${KEY_PATH}.b64"
echo "Encoding key in base64 format"
base64 "$KEY_PATH" > "$ENCODED_KEY_FILE"

# Step 6: Upload the base64-encoded key to Azure Key Vault
echo "Uploading base64-encoded key to Azure Key Vault"
az keyvault secret set --vault-name "$KEY_VAULT_NAME" --name "$SECRET_NAME" --file "$ENCODED_KEY_FILE"

# Step 7: Clean up the local key files
echo "Cleaning up local key files"
rm -f "$KEY_PATH" "$ENCODED_KEY_FILE"

echo "git-crypt repository initialized and key securely uploaded to Azure Key Vault."
