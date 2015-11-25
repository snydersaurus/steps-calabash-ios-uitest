#!/bin/bash

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e

current_path=$(pwd)
cd $THIS_SCRIPT_DIR
bundle exec ruby "step.rb" \
	-t "${calabash_features}" \
	-d "${simulator_device}" \
	-o "${simulator_os_version}"
cd $current_path
