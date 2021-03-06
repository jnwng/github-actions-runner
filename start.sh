#!/usr/bin/env bash

set -e

if [[ -z ${GH_RUNNER_TOKEN} ]];
then
    echo "Environment variable 'GH_RUNNER_TOKEN' is not set"
    exit 1
fi

if [[ -z ${GH_REPOSITORY} ]];
then
    echo "Environment variable 'GH_RUNNER_TOKEN' is not set"
    exit 1
fi

# generate random password
# silent fail because it wont be able override password on restartt
newPass=$(pwgen -s1 20)
printf "runner\n${newPass}\n${newPass}\n" | passwd 2> /dev/null || echo

# print runner version
echo "github runner version: $(./config.sh --version)"
echo "github runner commit: $(./config.sh --commit)"

workDir=/tmp/_work/$(pwgen -s1 5)

mkdir -p ${workDir}
echo "Runner working directory: ${workDir}"

/runner/config.sh --unattended --url ${GH_REPOSITORY} --token ${GH_RUNNER_TOKEN} --labels ${GH_RUNNER_LABELS} --replace --work ${workDir}

exec /runner/run.sh
