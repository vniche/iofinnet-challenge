# terraform

This Ansible playbook provides a way to provision and manage a MinIO cluster in host (with the usage of Docker secrets and persistent volumes).

## Summary

This playbook consists of the following requirements and tasks:

1. Operator creates and encrypts a file in `files/minio_password` with the MinIO cluster password as content:
    - `mkdir && files/ && echo -n "s3cr3t123#" > files/minio_password`
    - `ansible-vault encrypt files/minio_password`
P.S. By using `ansible-vault`, when executing playbooks that use such content, remember to pass the argument `--ask-vault-pass` and input the same secret used for encryption.
2. Adds any necessary configurations for the hosts in `inventory/hosts` for SSH connections.
3. First playbook tasks ensure packages information and system certificates up-to-date.
4. Creates the `cluster` directory in the remote host if it does not exist yet.
5. Copy and decrypts the cotent of `files/minio_password` to the remote host `cluster` directory.
6. Executes the template `templates/docker-compose.yaml.j2` and ensure the resulting content as a file in the remote host as `cluster/docker-compose.yaml`.
7. Ensure the docker-compose services are up if:
    - There were changes either in the `files/minio_password` content or in the result of executing the template `templates/docker-compose.yaml.j2`.
    - A the fact `force_up` resolves to true. Usage: `ansible-playbook -i inventory/hosts up.yaml --ask-vault-pass -e 'force_up=true'`

As a complementary playbook, `down.yaml` provides a playbook to stop the provisioned services through the following tasks:

1. Ensures docker-compose services are down through `docker compose down`.
2. Given the proper condition, deletes the persistent volumes created by the `up.yaml` playbook. Usage:
    - `ansible-playbook -i inventory/hosts down.yaml -e 'clear_data=true'`
