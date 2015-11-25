#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e

ruby "${THIS_SCRIPTDIR}/step.rb" \
	-t "${calabash_features}" \
	-d "${simulator_device}" \
	-o "${simulator_os_version}"
