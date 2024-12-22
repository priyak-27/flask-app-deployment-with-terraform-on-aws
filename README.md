In today's fast-paced development environment, infrastructure provisioning should be automated for better scalability, repeatability, and efficiency. This project uses Terraform, an Infrastructure as Code (IaC) tool, to automate the creation of AWS resources required to host a web application. By doing so, you can easily replicate the environment, reduce the risk of human error, and ensure consistency across different deployments. The infrastructure setup is fully automated so that each time the application team wants to test the application, they don’t need to manually recreate the environment.

## Project Requirements

The application team requires an automated infrastructure setup whenever they need to test changes made to their Flask application. They need a solution that enables them to:

- The application team will provide you with 'app.py' file
- Provision the necessary AWS resources (VPC, Subnet, Route Table, EC2) without manual intervention.
- Automatically deploy the Flask application on an EC2 instance each time they need to test it.
- Eliminate the need to manually create and configure the infrastructure every time they want to run or test the `app.py` file.
- Utilize Terraform to create, configure, and destroy the required infrastructure for testing.

## Project Overview

This project sets up the following AWS resources:
- A **VPC** (Virtual Private Cloud) to define a network.
- A **Subnet** within the VPC.
- A **Route Table** that routes traffic from the subnet to the **Internet Gateway** for public access.
- A **Security Group** to control inbound and outbound traffic (allows HTTP and SSH).
- An **EC2 Instance** running Ubuntu that hosts the Flask web app.
- A **Key Pair** for secure SSH access to the instance.
- The Flask app is automatically transferred to the EC2 instance and started when the instance boots.

## Tools Needed
1. **Terraform** - to provision AWS resources.
2. **AWS Account** - with appropriate permissions to create EC2 instances, VPCs, etc.
3. **Public SSH Key** - A public SSH key to access the EC2 instance. Make sure the corresponding private key is stored locally.

## Steps to Execute
step 1: **SSH pair** - first, create your SSH key pair on the local machine. you can save it in the default location or a specific location. In this project, I have stored it in the default location. If you are saving it in a specific location, please make changes in 'main.tf' and add the right path to your file.
step 2: **folder** - make sure your 'app.py' and 'main.tf' are in the same folder.
step 3: run **terraform init** to initiate your backend. Then run **terraform plan** to verify the changes to your infrastructure.
step 4: Then run **terraform apply** to apply changes to your infrastructure. once your flask operation starts you can browse http://public_ip_of_your_instance . to stop the application press **ctrl+c**
step 5: once testing is done please run **terraform destroy** to destroy the testing environment that you created above.
