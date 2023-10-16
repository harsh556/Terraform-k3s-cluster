# Terraform-k3s-cluster
**Changes in the Configuration files for successfully running This Terraform script**

- [ ] Access and Secret access keys to be specified in the values.tfvar file .

      
![var file](https://github.com/harsh556/Terraform-k3s-cluster/assets/114024228/8778066f-5b8c-4e4b-888b-c4edb768063f)


- [ ] Path to the ssh public key file must be specified in the main.tf file and the pem file must be placed under it .


 
 ![connection](https://github.com/harsh556/Terraform-k3s-cluster/assets/114024228/8dcdafc8-1df7-4445-ab66-8b79c14d1132)



 **Run Command Terraform init to initialize Terraform so that all the necessary plugins required to be installed to run the script get installed**

 Command -  terraform init

 
![init](https://github.com/harsh556/Terraform-k3s-cluster/assets/114024228/ee5abbf3-a9cf-47ab-bb27-968dec119b82)



**Run Command - terraform plan -var-file=values.tfvars**




![3](https://github.com/harsh556/Terraform-k3s-cluster/assets/114024228/75ac1dda-1133-486b-8d37-fd307dd74abb)




**Run Command - terraform apply -var-file=values.tfvars**



![6](https://github.com/harsh556/Terraform-k3s-cluster/assets/114024228/298ee812-f1e9-466f-88e3-6c140cb61a0b)




**Terraform Script has deployed three servers(EC2 Instances) that'll act as three master nodes of the k3s Cluster**
