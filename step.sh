#!/bin/bash

this_script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e

export BUNDLE_GEMFILE="${this_script_dir}/Gemfile"

bundle install
bundle exec ruby "$this_script_dir/step.rb" \
	-b "${simulator_device}" \
	-c "${simulator_os_version}"
