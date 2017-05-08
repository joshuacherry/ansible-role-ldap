#!/usr/bin/env bash
set -euxo pipefail
IFS=$'\n\t'

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

declare -r OS=${1:-${OS}}
declare -r PLAYBOOK=${2:-${PLAYBOOK}}
declare -r WORKSPACE=${WORKSPACE:-/tmp/ansible-inspec}

function cleanup() {
  docker-compose stop "${OS}"
  docker-compose rm -f "${OS}"
}

function debug() {
  local container="$(docker-compose ps -q "${OS}")"
  docker exec -it "${container}" /bin/bash
  cleanup
}

function main() {
  docker-compose up -d "${OS}"

  local container="$(docker-compose ps -q "${OS}")"

  # Install role.
  docker cp . "${container}:${WORKSPACE}"

  docker exec -t "${container}" mkdir "${WORKSPACE}/tests/roles"
  docker exec -t "${container}" ln -s "${WORKSPACE}/" "${WORKSPACE}/tests/roles/role_under_test"

  printf "\n"

  # Install requirements if `requirements.yml` is present.
  if [ -f "$PWD/tests/requirements.yml" ]; then
    printf ${green}"Requirements file detected; installing dependencies."${neutral}"\n"
    docker exec -t "${container}" env ANSIBLE_FORCE_COLOR=1 ansible-galaxy \
                install --roles-path "${WORKSPACE}/tests/roles/" \
                -r "${WORKSPACE}/tests/requirements.yml"
  fi

printf "\n"

  # Validate syntax
  docker exec -t "${container}" env ANSIBLE_FORCE_COLOR=1 ansible-playbook \
              -i "${WORKSPACE}/tests/inventory" \
              --syntax-check \
              -v "${WORKSPACE}/tests/${PLAYBOOK}.yml"

  # Run Playbook.
  docker exec -t "${container}" env ANSIBLE_FORCE_COLOR=1 ansible-playbook \
              -i "${WORKSPACE}/tests/inventory" \
              -c local \
              -v "${WORKSPACE}/tests/${PLAYBOOK}.yml"

  # Run Ansible playbook again (idempotence test).
  idempotence=$(mktemp)
  docker exec -t "${container}" env ANSIBLE_FORCE_COLOR=1 ansible-playbook \
              -i "${WORKSPACE}/tests/inventory" \
              -c local \
              -v "${WORKSPACE}/tests/${PLAYBOOK}.yml" | tee -a $idempotence
  tail $idempotence \
  | grep -q 'changed=0.*failed=0' \
  && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
  || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)

  # Sleep to allow Services to boot.
  # FIXME: A retry loop checking if it has launched yet would be better.
  sleep 5

  # Run tests.
  docker exec -t "${container}" inspec exec "${WORKSPACE}/tests/specs/${PLAYBOOK}_spec.rb"
}

#Debug running container
if [ "${@: -1}" = "debug" ] 
then
  trap debug EXIT
else
  trap cleanup EXIT
fi

main "${@}"
