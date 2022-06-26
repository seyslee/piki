# 20. state 조작

## init, plan, apply

```bash
$ ls
provider.tf  ssm.tf       variables.tf
```

테라폼 초기화를 합니다.

```bash
$ terraform init
```

provider 상세정보를 확인합니다.

```bash
$ terraform providers -v
Terraform v1.2.2
on darwin_arm64
+ provider registry.terraform.io/hashicorp/aws v4.18.0
```

Terraform `v1.2.2`에 Provider는 `aws v4.18.0`을 사용중입니다.

플랜을 미리 확인합니다.

```bash
$ terraform plan
```

SSM Parameter를 생성해보겠습니다.

```bash
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_ssm_parameter.myparameter will be created
  + resource "aws_ssm_parameter" "myparameter" {
      + arn       = (known after apply)
      + data_type = (known after apply)
      + id        = (known after apply)
      + key_id    = (known after apply)
      + name      = "/myapp/myparameter"
      + tags_all  = (known after apply)
      + tier      = (known after apply)
      + type      = "String"
      + value     = (sensitive value)
      + version   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_ssm_parameter.myparameter: Creating...
aws_ssm_parameter.myparameter: Creation complete after 0s [id=/myapp/myparameter]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

이제 terraform.tfstate 파일이 생성된 걸 확인할 수 있습니다.

```bash
$ ls
provider.tf       ssm.tf            terraform.tfstate variables.tf
```

## terraform state

state 파일에 포함된 리소스 목록을 확인합니다.

```bash
$ terraform state list
aws_ssm_parameter.myparameter
```

1개의 리소스가 생성된 걸 확인할 수 있습니다.

```bash
$ terraform state pull
{
  "version": 4,
  "terraform_version": "1.2.2",
  "serial": 1,
  "lineage": "d6212a49-df70-1cef-f6e8-5424a06e3e2d",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "aws_ssm_parameter",
      "name": "myparameter",
      "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "allowed_pattern": "",
            "arn": "arn:aws:ssm:ap-northeast-2:111111111111:parameter/myapp/myparameter",
            "data_type": "text",
            "description": "",
            "id": "/myapp/myparameter",
            "key_id": "",
            "name": "/myapp/myparameter",
            "overwrite": null,
            "tags": null,
            "tags_all": {},
            "tier": "Standard",
            "type": "String",
            "value": "myvalue",
            "version": 1
          },
          "sensitive_attributes": [],
          "private": "bnVsbA=="
        }
      ]
    }
  ]
}
```

json 형식이라 읽기 어렵습니다.

대신 `terraform state list`와 `terraform state show`로 훨씬 편하게 볼 수 있습니다.

```bash
$ terraform state list
aws_ssm_parameter.myparameter

$ terraform state show aws_ssm_parameter.myparameter
# aws_ssm_parameter.myparameter:
resource "aws_ssm_parameter" "myparameter" {
    arn       = "arn:aws:ssm:ap-northeast-2:111111111111:parameter/myapp/myparameter"
    data_type = "text"
    id        = "/myapp/myparameter"
    name      = "/myapp/myparameter"
    tags_all  = {}
    tier      = "Standard"
    type      = "String"
    value     = (sensitive value)
    version   = 1
}
```

더 보기 편합니다.

ssm.tf 파일에서 `myparameter`를 `mynewparameter`로 변경해보겠습니다.

```bash
$ vi ssm.tf
resource "aws_ssm_parameter" "mynewparameter" {
  name  = "/myapp/myparameter"
  type  = "String"
  value = "myvalue"
}
```

그리고 플랜을 확인해보겠습니다.

```bash
$ terraform plan
aws_ssm_parameter.myparameter: Refreshing state... [id=/myapp/myparameter]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  - destroy

Terraform will perform the following actions:

  # aws_ssm_parameter.mynewparameter will be created
  + resource "aws_ssm_parameter" "mynewparameter" {
      + arn       = (known after apply)
      + data_type = (known after apply)
      + id        = (known after apply)
      + key_id    = (known after apply)
      + name      = "/myapp/myparameter"
      + tags_all  = (known after apply)
      + tier      = (known after apply)
      + type      = "String"
      + value     = (sensitive value)
      + version   = (known after apply)
    }

  # aws_ssm_parameter.myparameter will be destroyed
  # (because aws_ssm_parameter.myparameter is not in configuration)
  - resource "aws_ssm_parameter" "myparameter" {
      - arn       = "arn:aws:ssm:ap-northeast-2:111111111111:parameter/myapp/myparameter" -> null
      - data_type = "text" -> null
      - id        = "/myapp/myparameter" -> null
      - name      = "/myapp/myparameter" -> null
      - tags      = {} -> null
      - tags_all  = {} -> null
      - tier      = "Standard" -> null
      - type      = "String" -> null
      - value     = (sensitive value)
      - version   = 1 -> null
    }

Plan: 1 to add, 0 to change, 1 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

테라폼은 저희가 이름 바꾼 걸 인지하지 못하고 SSM Parameter 리소스를 삭제하고 다시 만들려고 합니다.

이 때 상태 조작을 통해 제어할 수 있습니다.

```bash
$ terraform state list
aws_ssm_parameter.myparameter
```


```bash
# 형식
$ terraform state mv <기존 이름> <변경할 이름>

# 실제 실행한 명령어
$ terraform state mv aws_ssm_parameter.myparameter aws_ssm_parameter.mynewparameter
Move "aws_ssm_parameter.myparameter" to "aws_ssm_parameter.mynewparameter"
Successfully moved 1 object(s).
```

다시 apply 해봅니다.

```bash
$ terraform apply
aws_ssm_parameter.mynewparameter: Refreshing state... [id=/myapp/myparameter]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

상태 조작을 통해 테라폼이 SSM Parameter 리소스의 변경된 이름을 인지했습니다.

terraform state mv 는 실제로 많이 사용됩니다. 루트 모듈을 만들게 되면 terraform state mv 명령어를 사용해야 합니다.

특정 리소스를 더 관리할 필요 없다면 `terraform state rm`을 하면 됩니다.

```bash
$ terraform state rm aws_ssm_parameter.mynewparameter
Removed aws_ssm_parameter.mynewparameter
Successfully removed 1 resource instance(s).
```

대신 실제 SSM Parameter 리소스는 AWS에 남아있습니다. 상태 파일에서만 해당 리소스를 삭제하는 걸 의미합니다.

state의 리소스 목록을 조회합니다.

```bash
$ terraform state list
# return blank
```

리소스를 `terraform state rm`으로 삭제했기 때문에 아무런 결과도 출력되지 않습니다.

테라폼으로 리소스를 다시 생성해보겠습니다.

```bash
$ terraform apply
```

에러가 발생합니다.

```
...

╷
│ Error: error creating SSM Parameter (/myapp/myparameter): ParameterAlreadyExists: The parameter already exists. To overwrite this value, set the overwrite option in the request to true.
│
│   with aws_ssm_parameter.mynewparameter,
│   on ssm.tf line 1, in resource "aws_ssm_parameter" "mynewparameter":
│    1: resource "aws_ssm_parameter" "mynewparameter" {
│
╵
```

이미 AWS에 존재하는 리소스라 생성할 수 없다고 나옵니다.

이처럼 State 파일에서 rm으로 지웠더라도 AWS에는 그대로 남아있게 됩니다.

이미 존재하는 AWS 리소스를 state 파일로 가져오려면 import를 사용합니다.

```bash
$ terraform import aws_ssm_parameter.mynewparameter /myapp/myparameter
aws_ssm_parameter.mynewparameter: Importing from ID "/myapp/myparameter"...
aws_ssm_parameter.mynewparameter: Import prepared!
  Prepared aws_ssm_parameter for import
aws_ssm_parameter.mynewparameter: Refreshing state... [id=/myapp/myparameter]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

리소스 목록을 확인합니다.

```bash
$ terraform state list
aws_ssm_parameter.mynewparameter
```

state와 실제 AWS 리소스 상태를 일치화했기 때문에 이젠 destroy로 삭제가 가능합니다.

## destroy

실습이 끝났으니 SSM Parameter 리소스를 삭제하도록 합니다.

```bash
$ terraform destroy
aws_ssm_parameter.mynewparameter: Refreshing state... [id=/myapp/myparameter]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_ssm_parameter.mynewparameter will be destroyed
  - resource "aws_ssm_parameter" "mynewparameter" {
      - arn       = "arn:aws:ssm:ap-northeast-2:111111111111:parameter/myapp/myparameter" -> null
      - data_type = "text" -> null
      - id        = "/myapp/myparameter" -> null
      - name      = "/myapp/myparameter" -> null
      - tags      = {} -> null
      - tags_all  = {} -> null
      - tier      = "Standard" -> null
      - type      = "String" -> null
      - value     = (sensitive value)
      - version   = 1 -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

`yes`를 입력해 계속 삭제를 진행합니다.

```bash
...
  Enter a value: yes

aws_ssm_parameter.mynewparameter: Destroying... [id=/myapp/myparameter]
aws_ssm_parameter.mynewparameter: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.
```

1개의 리소스가 삭제되었습니다.

```bash
$ terraform state list
# return blank
```

이제 SSM Parameter 리소스는 state file에서 조회되지 않습니다.
