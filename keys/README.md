# Keys Folder
This folder will be mounted in the Zeek container. Everything you modify here will be reflected in the corresponding folder in the container(see docker-compose.yml for reference).

IT IS NOT RECOMMENDED to use the provided key pair as it is accessable by everyone who sees this repository. It is STRICTLY PROVIDED FOR DEMONSTRATION PURPOSES.

## Replace

Replace the provided keys with your own and ensure that they are in the "authorized_keys" folder of the root user on every device you are wanting to monitor.

Replace the "known_hosts" folder with one that has the host key fingerprints of your workers.

