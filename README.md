# terraform project
## Sela bootcamp week 5



This is a project built as part of a DEVOPS BOOTCAMP.
Its main purpose is to study infrastructure deployment using code only.

The project uses an azure environment to deploy a complete production infrastructure to a web application.
The infrastructure includes, among others:
- Scale set vm runing on ubunto OS 
- Load balancer for routing the load between the servers
- azurue postgresql manneged service
- using azure blub storage to store tfstate


### Details:
#### network


The network (10.0.0.0 \ 26) is divided into two subnets
- public (10.0.0.0/26)
open to the word to app web acsess on port 8080,
and for ssh acsess for the devaloper from specific ip address
- privete (10.0.0.88/29)
- Closed to any external access, accessible from the public subnet only.
And also only in port 22 for SSH connection and port 5432 for database

#### vms
elastic scale set of ubunto servers "Standard_DS1_v2" class

#### postgresql
mannged flexible server "B_Standard_B1ms" class

#### public Load balancer
with prob set of rules and outbend nat

## output


 
- public ip
- mannge server ip (ssh connction)
- admin passwords and username


