
# 11. Route 53

## init, plan, apply

테라폼을 초기화합니다.

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v4.17.1

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

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_route53_record.mail1-record will be created
  + resource "aws_route53_record" "mail1-record" {
      + allow_overwrite = (known after apply)
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + name            = "terraform.training"
      + records         = [
          + "1 aspmx.l.google.com.",
          + "10 aspmx2.googlemail.com.",
          + "10 aspmx3.googlemail.com.",
          + "5 alt1.aspmx.l.google.com.",
          + "5 alt2.aspmx.l.google.com.",
        ]
      + ttl             = 300
      + type            = "MX"
      + zone_id         = (known after apply)
    }

  # aws_route53_record.server1-record will be created
  + resource "aws_route53_record" "server1-record" {
      + allow_overwrite = (known after apply)
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + name            = "server1.terraform.training"
      + records         = [
          + "104.236.247.8",
        ]
      + ttl             = 300
      + type            = "A"
      + zone_id         = (known after apply)
    }

  # aws_route53_record.www-record will be created
  + resource "aws_route53_record" "www-record" {
      + allow_overwrite = (known after apply)
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + name            = "www.terraform.training"
      + records         = [
          + "104.236.247.8",
        ]
      + ttl             = 300
      + type            = "A"
      + zone_id         = (known after apply)
    }

  # aws_route53_zone.terraform-training will be created
  + resource "aws_route53_zone" "terraform-training" {
      + arn           = (known after apply)
      + comment       = "Managed by Terraform"
      + force_destroy = false
      + id            = (known after apply)
      + name          = "terraform.training"
      + name_servers  = (known after apply)
      + tags_all      = (known after apply)
      + zone_id       = (known after apply)
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + ns-servers = (known after apply)

───────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```

1개의 존과 3개의 레코드가 생성될 예정입니다.

```bash
$ terraform apply
...

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + ns-servers = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

중간에 `yes`를 입력해서 계속 진행합니다.

Route 53 Zone 생성이 50초 이상 걸린다는 점 참고 바랍니다.

```bash
...
aws_route53_zone.terraform-training: Creating...
aws_route53_zone.terraform-training: Still creating... [10s elapsed]
aws_route53_zone.terraform-training: Still creating... [20s elapsed]
aws_route53_zone.terraform-training: Still creating... [30s elapsed]
aws_route53_zone.terraform-training: Still creating... [40s elapsed]
aws_route53_zone.terraform-training: Creation complete after 49s [id=Z01151092Q1MVHQA7GF6K]
aws_route53_record.mail1-record: Creating...
aws_route53_record.www-record: Creating...
aws_route53_record.server1-record: Creating...
...
```

```bash
...
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

ns-servers = tolist([
  "ns-1420.awsdns-49.org",
  "ns-1634.awsdns-12.co.uk",
  "ns-432.awsdns-54.com",
  "ns-845.awsdns-41.net",
])

```

Outputs로 출력된 ns-servers에 포함된 AWS 네임서버를 참조해야 합니다.  

DNS 질의를 테스트 해봅니다.  
`host` 명령어는 도메인 질의 및 테스트 툴입니다.

```bash
# host 명령어 사용법
host [옵션] [도메인 혹은 IP 주소] [DNS 서버]
```

```bash
$ host server1.terraform.training ns-1420.awsdns-49.org
Using domain server:
Name: ns-1420.awsdns-49.org
Address: 205.251.197.140#53
Aliases:

server1.terraform.training has address 104.236.247.8
```

`server1.terraform.training`에 대한 응답을 잘하고 있습니다.

반드시 Outputs로 출력된 네임서버를 설정한 상태에서 질의를 해야합니다.  
현재 테라폼으로 생성한 도메인 레코드들은 모두 AWS 내부에만 존재하는 주소들이기 때문입니다.

```bash
$ host server1.terraform.training
Host server1.terraform.training not found: 3(NXDOMAIN)
```

저희에게 지정된 네임서버를 설정하지 않은 상태에서 DNS 질의를 해보면 존재하지 않는 도메인(`NXDOMAIN`)이라는 에러가 출력됩니다.

MX 레코드에 대한 응답도 테스트합니다.

```bash
$ host -t MX terraform.training ns-1420.awsdns-49.org
Using domain server:
Name: ns-1420.awsdns-49.org
Address: 205.251.197.140#53
Aliases:

terraform.training mail is handled by 1 aspmx.l.google.com.
terraform.training mail is handled by 10 aspmx2.googlemail.com.
terraform.training mail is handled by 10 aspmx3.googlemail.com.
terraform.training mail is handled by 5 alt1.aspmx.l.google.com.
terraform.training mail is handled by 5 alt2.aspmx.l.google.com.
```

MX 레코드에 대한 질의도 설정한대로 응답을 주고 있습니다.

## destroy

실습이 끝났습니다.  
테라폼으로 생성한 리소스를 모두 삭제합니다.

```bash
$ terraform destroy
...

Plan: 0 to add, 0 to change, 4 to destroy.

Changes to Outputs:
  - ns-servers = [
      - "ns-1420.awsdns-49.org",
      - "ns-1634.awsdns-12.co.uk",
      - "ns-432.awsdns-54.com",
      - "ns-845.awsdns-41.net",
    ] -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

중간에 `yes`를 입력해서 리소스 삭제를 계속 진행합니다.

```bash
...
aws_route53_zone.terraform-training: Destroying... [id=Z01151092Q1MVHQA7GF6K]
aws_route53_zone.terraform-training: Destruction complete after 1s

Destroy complete! Resources: 4 destroyed.
```

테라폼으로 생성한 존과 도메인 리소스가 삭제되었습니다.
