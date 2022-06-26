# 16. Interpolation

## 사전준비

SSH 키 페어를 로컬에서 생성합니다.

이 키를 기반으로 EC2 SSH Key Pair를 생성합니다.

```bash
$ ssh-keygen -f mykey
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in mykey
Your public key has been saved in mykey.pub
The key fingerprint is:
SHA256:c3Vn8B3YNrjoJaiLfdmn6DNDvD1EodslKkrXP8uFhQU steve@steveui-MacBookPro.local
The key's randomart image is:
+---[RSA 3072]----+
|           E  =. |
|           ..o *o|
|          o +.+ *|
|         o *o= o |
|        S B.=.   |
|     . + O +o    |
|    . = + B. .   |
|     o o Bo*..   |
|        oo++*    |
+----[SHA256]-----+
```

passphrase는 빈 값으로 생성합니다.

```bash
$ ls mykey*
mykey     mykey.pub
```

비밀키인 `mykey`와 공개키인 `mykey.pub`이 생성되었습니다.

## init, plan, apply

테라폼을 초기화합니다.

```bash
$ terraform init
Initializing modules...
Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 2.59.0 for vpc-dev...
- vpc-dev in .terraform/modules/vpc-dev
Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 2.59.0 for vpc-prod...
- vpc-prod in .terraform/modules/vpc-prod

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching ">= 2.68.0"...
- Installing hashicorp/aws v4.18.0...
- Installed hashicorp/aws v4.18.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

플랜을 확인합니다.

```bash
$ terraform plan
...

Plan: 42 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

```bash
$ terraform apply
...

module.vpc-dev.aws_route_table_association.public[1]: Creation complete after 1s [id=rtbassoc-00a4ca8168d8d2331]
aws_instance.example: Still creating... [10s elapsed]
aws_instance.example: Creation complete after 12s [id=i-0e108d2eee80f6c24]

Apply complete! Resources: 42 added, 0 changed, 0 destroyed.
```

production VPC와 production EC2 인스턴스가 생성될 것입니다.

```bash
$ cat instance.tf
...
  # the security group
  vpc_security_group_ids = [var.ENV == "prod" ? aws_security_group.allow-ssh-prod.id : aws_security_group.allow-ssh-dev.id]
...
```

`ENV` 값이 `prod`일 경우에는 `allow-ssh-prod` 라는 보안그룹을 생성하고, 아닐 경우에는 `allow-ssh-dev` 라는 보안그룹을 생성하도록 설정되어 있기 때문입니다.

만약 테라폼으로 생성할 때 개발환경으로 변경하고 싶으면 테라폼을 실행할 때 `-var` 옵션을 사용해 `ENV=dev` 변수 값을 전달할 수 있습니다.

```bash
$ terraform apply -var ENV=dev
```

## destroy

실습이 끝난 후에는 테라폼으로 생성한 전체 리소스를 삭제해줍니다.

```bash
$ terraform destroy
```

잠시 기다린 후 42개의 리소스가 삭제되었습니다.

```bash
...

module.vpc-dev.aws_vpc.this[0]: Destroying... [id=vpc-076f143bffae76352]
module.vpc-prod.aws_vpc.this[0]: Destruction complete after 0s
module.vpc-dev.aws_vpc.this[0]: Destruction complete after 1s

Destroy complete! Resources: 42 destroyed.
```
