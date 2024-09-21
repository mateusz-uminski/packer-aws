#! /bin/bash


# PACKER_* environmnet variables are set in shell-local context

tmp_ssh_private_key="${PACKER_TESTS_PATH}/${PACKER_BUILD_ID}.pem"

echo "create a temporary ssh key in ${tmp_ssh_private_key}"
echo "${PACKER_SSH_PRIVATE_KEY}" > "${tmp_ssh_private_key}"
chmod 400 "${tmp_ssh_private_key}"

echo "execute tests from ${PACKER_TESTS_PATH}"
pytest -vvv "${PACKER_TESTS_PATH}/" \
    --ssh-identity-file="${tmp_ssh_private_key}" \
    --hosts="ssh://${PACKER_USER}@${PACKER_HOST}" \
    --ssh-config="${PACKER_TESTS_PATH}/ssh_config"

echo "remove the temporary ssh key in ${tmp_ssh_private_key}"
rm -f "${tmp_ssh_private_key}"
