# フォルダ構成

- フォルダ構成は以下の通り

```
.
├── envs
│   ├── backend.tf                    tfstateファイル管理定義ファイル
│   ├── data.tf                       外部データソース定義ファイル
│   ├── locals.tf                     ローカル変数定義ファイル
│   ├── main.tf                       デプロイリソース定義ファイル
│   ├── outputs.tf                    リソース戻り値定義ファイル
│   ├── providers.tf                  プロバイダー定義ファイル
│   ├── variables.tf                  変数定義ファイル
│   └── versions.tf                   Terraformバージョン定義ファイル
└── modules
    ├── alb                           ALB
    │   ├── config
    │   │   └── sorry_page.txt
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── cloudwatch                    Amazon CloudWatch
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── ec2                           Amazon EC2
    │   ├── config
    │   │   └── cwagent.json
    │   ├── data.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── userdata
    │   │   └── linux_init.sh
    │   └── variables.tf
    ├── eventbridge                   Amazon EventBridge
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── iam_role                      AWS IAM Role
    │   ├── custom_policy.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── internet_gateway              Internet Gateway
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── nat_gateway                   NAT Gateway
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── route_table                   Route Table
    │   ├── locals.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── security_group                Security Group
    │   ├── locals.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── subnet                        Subnet
    │   ├── locals.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── systems_manager               AWS Systems Manager
    │   ├── config
    │   │   └── automation.yaml
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── user_notifications            AWS User Notifications
    │   ├── config
    │   │   └── cloudwatch.json
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── vpc                           Amazon VPC
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```
