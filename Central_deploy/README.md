.
├── Makefile
├── config
│   ├── config.tfvars
│   ├── secrets.tfvars
│   ├── env1
│   │   ├── config.tfvars
│   │   ├── secrets.tfvars
│   ├── env2
│   │   ├── config.tfvars
│   │   ├── secrets.tfvars
│   └── ...
├── terraform
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── modules
│   │   ├── k8s
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── network
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── security
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── ...
│   └── ...
└── ...