# WordPress + MySQL with Docker

This project uses Docker to deploy WordPress with a MySQL backend on an AWS EC2 instance.

## How to Use

1. Pull MySQL image and run it with environment variables and volume.
2. Pull WordPress image and link it to the MySQL container.
3. Map port 80 of EC2 to WordPress container's port 80.

