#!/bin/bash

##############################################################################
############################### UTIL FUNCTIONS ###############################
##############################################################################

check_utilities () {
  echo "[$0] ***** Checking required tools... *****"
  REQUIRED_TOOLS=("docker" "docker compose" "yq" "jq")

  for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v $tool &> /dev/null; then
      echo "[$0] ERROR: $tool is not installed. Please install $tool and try again."
      exit 1
    fi
  done

  # Check if versions of required tools are correct
  check_version() {
    local tool=$1
    local required_version=$2
    local current_version=$($tool --version | grep -oP '\d+\.\d+')
    if [[ $(echo -e "$current_version\n$required_version" | sort -V | head -n1) != "$required_version" ]]; then
      echo "[$0] ERROR: $tool version $required_version or higher is required. Current version is $current_version."
      exit 1
    fi
  }

  # Define required versions for each tool
  declare -A REQUIRED_VERSIONS
  REQUIRED_VERSIONS=( ["docker"]="20.10" ["docker-compose"]="1.29" ["yq"]="4.6" ["jq"]="1.6" )

  # Check versions
  echo "[$0] ***** Checking version of required tools... *****"
  for tool in "${!REQUIRED_VERSIONS[@]}"; do
    check_version $tool ${REQUIRED_VERSIONS[$tool]}
  done
}