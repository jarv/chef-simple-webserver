# Summary

This is a simple cookbook for launching an EC2 instance in AWS and configuring
it to serve a simple static webpage on an Ubuntu server.  


# Installation

* Berks and Bundler are used to manage dependencies:

```
## Install rbenv (`brew install rbenv on OSX`)
$ rbenv install
$ sudo gem install bundler
$ bundle install
$ berks update
$ berks install
```

# AWS

In order to use this Chef cookbook you must have an AWS account. 
A cloud formation template will be used to create the following resources in EC2:

* EC2 Instance
* EC2 SSH KeyPair
* EC2 Security Group that permits SSH and HTTP inbound connections.

# Provisioning and Configuring the Server

If you have the aws commandline installed you can launch the instance and configure it by running:
```
./bootstrap.sh <stack-name>
```
Where "stack-name" is the name of the cloudformation stack that will be created in your AWS account.

## Provisioning

This uses CloudFormation to provision the required AWS resources for the web server. Either launch
a new stack using cf/webserver.yaml or use the AWS CLI:

```
aws cloudformation create-stack --region us-east-1 --stack-name webserver --template-body file://cf/webserver.yaml
aws cloudformation describe-stacks --region us-east-1  --stack-name webserver

```
* The stack outputs will contain the public endpoint of the EC2 instance.

## Configuration

Once the EC2 instance is launched use knife solo to run Chef to configure the server.

```
knife solo prepare ubuntu@<server address>
knife solo cook ubuntu@<server address> -o webserver::default
```

After the Chef run has completed you can confirm the configuration by pointing a web browser to the server address.

# Testing

There are two types of tests in this repo:

* Rspec tests ensure that the recipe in the webserver cookbook creates the html file and the nginx config.
* Test kitchen is used to spin up an EC2 instance and run the recipe on a real host.

## Unit tests

```
# Run the rspec unit tests
$ rspec
```

## Test Kitchen

Before running `kitchen` modify the `.kitchen.yml` with your key-pair and security group ID that permits
ssh and http.

```
# Run kitchen to provision an instance and configure it
# Create the test server
$ kitchen create default-ubuntu-1404
# Run the recipe
$ kitchen converge
```
