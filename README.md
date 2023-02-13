# Terraform Vsphere esxi Kubernetes Cluster

This is a terraform module to deploy a Kubernetes cluster on Vsphere esxi cluster.

## requirements

- Vsphere esxi cluster
- Terraform
- Vsphere credentials in administrator

i use esxi 7.0.0 and terraform 1.3.6

## Installations

- Clone this repository
- Install terraform


## install rancker

in the folder vsphere you can find the terraform file to create the kubernetes cluster
- Edit the terraform.tfvars file
- Run terraform init
- Run terraform plan
- Run terraform apply

### Delete

- Run terraform destroy

## config for rancher

in the folder rancher you can find the terraform file to create the rancher server
- Edit the terraform.tfvars file

for the file terraform.tfvars we need to add api key and secret key for rancher for create this you need to connect for the first time on the rencher app.
to get the default password you need to run this command on the rancher server

```
sudo docker logs  <id container>  2>&1 | grep "Bootstrap Password:"
```

after that you can connect to the rancher app and create the api key and secret key

- Run terraform init

### Delete

- Run terraform destroy