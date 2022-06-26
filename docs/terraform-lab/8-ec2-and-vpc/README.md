# 8. EC2 and VPC

## 사전준비

미리 로컬에서 SSH 키 페어를 생성합니다.  
생성된 공개키를 기반으로 AWS 리소스인 EC2 Key Pair가 생성됩니다.

```bash
$ ls
instance.tf      outputs.tf       securitygroup.tf versions.tf
key.tf           provider.tf      variables.tf     vpc.tf
```

```bash
$ ssh-keygen -f mykey
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in mykey
Your public key has been saved in mykey.pub
The key fingerprint is:
SHA256:SIvyMu27GKAf+M7R90+zU7DGl3YNi3pk8BeFlzsOWQU steve@steveui-MacBookPro.local
The key's randomart image is:
+---[RSA 3072]----+
|              Eo+|
|              .oo|
|      .       oo.|
|     o o  o  ooo |
|. . . o S. = oo=.|
|.o =      + X +..|
|o * + .  .oB o   |
| + O . . .oo.    |
| .* +o  ..oo     |
+----[SHA256]-----+
```

passphrase는 빈 칸으로 입력해서 생성합니다.  

```bash
$ ls
```

비밀키인 `mykey`와 공개키인 `mykey.pub`이 생성된 걸 확인할 수 있습니다.

## init, plan, apply

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v4.17.1...
- Installed hashicorp/aws v4.17.1 (signed by HashiCorp)

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

```bash
$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.example will be created
  + resource "aws_instance" "example" {
      + ami                                  = "ami-0cbec04a61be382d9"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t3.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "mykeypair"
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + subnet_id                            = (known after apply)
      + tags_all                             = (known after apply)
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id                 = (known after apply)
              + capacity_reservation_resource_group_arn = (known after apply)
            }
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + maintenance_options {
          + auto_recovery = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
          + instance_metadata_tags      = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_card_index    = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_internet_gateway.main-gw will be created
  + resource "aws_internet_gateway" "main-gw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "main"
        }
      + tags_all = {
          + "Name" = "main"
        }
      + vpc_id   = (known after apply)
    }

  # aws_key_pair.mykeypair will be created
  + resource "aws_key_pair" "mykeypair" {
      + arn             = (known after apply)
      + fingerprint     = (known after apply)
      + id              = (known after apply)
      + key_name        = "mykeypair"
      + key_name_prefix = (known after apply)
      + key_pair_id     = (known after apply)
      + public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8dQt0XHsn3C+Q9Upi/NmnoU+okXbeSKPh8TxOiyd33hzGFCNTTF5YyjJoxFluOde+pakFmwNDUI5FXzBddOKxLpepqzkEqjHqDLPZQ9asygChCXOKjMT+aCJf9eLFlLilkNpuxJXZE1XMTUv5y8F+3+2kCCXAlm3bXpQCACrLn4mPelAIBvfOzW6bGwWRpCjsShRgL9OmbWROKHq2Zu5p5X8FRrfrcg0lfwvcVw1P84WzQhzTpnRVO7xbyN4vt8UEyjdENhQgD4wJAFQ/4W+6JWa1KASCM5MNstpDIrCcJRkKR+3pxZSMHLlg/q9Dm5aAedcxIpEiXbs7Y/pYrvLkCmag0pH52iTh/elBlno25NPGTD66kFrkSKhykaSNEM2ZadH8z//lsUWZSHs5WgIlzjciR53UMA+ufRxcZrkoLY/zqeOvVc2BQxPOiWh0HUf5wXkNX/SUvFEzMfR5vUsYxV47Dpio8jaSVNqKegPmNEWWG8QGMtZM9LAzoQc25t0= steve@steveui-MacBookPro.local"
      + tags_all        = (known after apply)
    }

  # aws_route_table.main-public will be created
  + resource "aws_route_table" "main-public" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + instance_id                = ""
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "main-public-1"
        }
      + tags_all         = {
          + "Name" = "main-public-1"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.main-public-1-a will be created
  + resource "aws_route_table_association" "main-public-1-a" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_route_table_association.main-public-2-a will be created
  + resource "aws_route_table_association" "main-public-2-a" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_route_table_association.main-public-3-a will be created
  + resource "aws_route_table_association" "main-public-3-a" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_security_group.allow-ssh will be created
  + resource "aws_security_group" "allow-ssh" {
      + arn                    = (known after apply)
      + description            = "security group that allows ssh and all egress traffic"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
        ]
      + name                   = "allow-ssh"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "allow-ssh"
        }
      + tags_all               = {
          + "Name" = "allow-ssh"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.main-private-1 will be created
  + resource "aws_subnet" "main-private-1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-northeast-2a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.4.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "main-private-1"
        }
      + tags_all                                       = {
          + "Name" = "main-private-1"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_subnet.main-private-2 will be created
  + resource "aws_subnet" "main-private-2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-northeast-2b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.5.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "main-private-2"
        }
      + tags_all                                       = {
          + "Name" = "main-private-2"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_subnet.main-private-3 will be created
  + resource "aws_subnet" "main-private-3" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-northeast-2c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.6.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "main-private-3"
        }
      + tags_all                                       = {
          + "Name" = "main-private-3"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_subnet.main-public-1 will be created
  + resource "aws_subnet" "main-public-1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-northeast-2a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "main-public-1"
        }
      + tags_all                                       = {
          + "Name" = "main-public-1"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_subnet.main-public-2 will be created
  + resource "aws_subnet" "main-public-2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-northeast-2b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.2.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "main-public-2"
        }
      + tags_all                                       = {
          + "Name" = "main-public-2"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_subnet.main-public-3 will be created
  + resource "aws_subnet" "main-public-3" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "ap-northeast-2c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.3.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "main-public-3"
        }
      + tags_all                                       = {
          + "Name" = "main-public-3"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = false
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "main"
        }
      + tags_all                             = {
          + "Name" = "main"
        }
    }

Plan: 15 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_id        = (known after apply)
  + instance_public_ip = (known after apply)
  + instance_type      = "t3.micro"

────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly
these actions if you run "terraform apply" now.
```

`outputs.tf` 파일로 인해 Output을 보여주게 됩니다.

- 인스턴스의 ID
- 인스턴스의 공인 IP
- 인스턴스의 타입

```bash
Changes to Outputs:
  + instance_id        = (known after apply)
  + instance_public_ip = (known after apply)
  + instance_type      = "t3.micro"
```

```bash
$ terraform apply
...

Plan: 15 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_id        = (known after apply)
  + instance_public_ip = (known after apply)
  + instance_type      = "t3.micro"

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

yes를 입력해서 계속 진행합니다.

```bash
...

Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

Outputs:

instance_id = "i-0a4fb5fad9d3bdf31"
instance_public_ip = "3.35.140.38"
instance_type = "t3.micro"
```

Output 덕분에 AWS Management Console을 켜서 EC2의 Public IP를 확인할 필요는 없습니다.

생성된 EC2 인스턴스에 SSH로 접속합니다.  
`-i mykey` : SSH 원격접속 시에는 비밀키가 필요합니다.
`-l ec2-user` : 인스턴스 생성에 사용한 AMI가 Amazon Linux 2이기 때문에, SSH로 로그인할 계정은 `ec2-user`로 지정합니다.

```bash
$ ssh 3.35.140.38 -l ec2-user -i mykey
#     -----+-----    ----+---    --+--
#          |             |         +-> Private 키 파일명
#          |             +-----------> 인스턴스에 로그인할 ID
#          +-------------------------> 인스턴스의 Public IP
```

```bash
$ ssh 3.35.140.38 -l ec2-user -i mykey
The authenticity of host '3.35.140.38 (3.35.140.38)' can't be established.
ED25519 key fingerprint is SHA256:3PnXMnvqcHzvCcrbrO8VOF6mGN1DJw+/cIcHg2TRIjg.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

중간에 yes를 입력해서 계속 진행합니다.

```bash
$ ssh 3.35.140.38 -l ec2-user -i mykey
The authenticity of host '3.35.140.38 (3.35.140.38)' can't be established.
ED25519 key fingerprint is SHA256:3PnXMnvqcHzvCcrbrO8VOF6mGN1DJw+/cIcHg2TRIjg.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '3.35.140.38' (ED25519) to the list of known hosts.

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
2 package(s) needed for security, out of 6 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-0-1-220 ~]$ 
```

테라폼으로 생성한 EC2 인스턴스에 접속되었습니다!

```bash
[ec2-user@ip-10-0-1-220 ~]$ sudo -s
```

root 권한을 얻습니다.

```bash
[root@ip-10-0-1-220 ec2-user]# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 10.0.1.220  netmask 255.255.255.0  broadcast 10.0.1.255
        inet6 fe80::34:5aff:fec1:8ee4  prefixlen 64  scopeid 0x20<link>
        ether 02:34:5a:c1:8e:e4  txqueuelen 1000  (Ethernet)
        RX packets 55794  bytes 77979186 (74.3 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 5574  bytes 352242 (343.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 24  bytes 1944 (1.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 24  bytes 1944 (1.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

인스턴스의 IP 주소를 확인해봅니다.  
공인 IP가 인스턴스에 표시되지는 않습니다.

인스턴스에서 로그아웃합니다.

```bash
[root@ip-10-0-1-220 ec2-user]# exit
exit
[ec2-user@ip-10-0-1-220 ~]$ exit
logout
Connection to 3.35.140.38 closed.
```

## terraform destroy

항상 실습이 끝나면 테라폼으로 생성한 리소스를 삭제해줍니다.

```bash
$ terraform destroy
...

Plan: 0 to add, 0 to change, 15 to destroy.

Changes to Outputs:
  - instance_id        = "i-0a4fb5fad9d3bdf31" -> null
  - instance_public_ip = "3.35.140.38" -> null
  - instance_type      = "t3.micro" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

yes를 입력해서 `destroy`를 계속 진행합니다.
