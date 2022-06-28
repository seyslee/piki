
# 10. Userdata

## 사전준비

로컬 환경에서 SSH 키 페어를 먼저 생성합니다.

```bash
$ ls
cloudinit.tf     key.tf           provider.tf      securitygroup.tf versions.tf
instance.tf      outputs.tf       scripts          variables.tf     vpc.tf
```

```bash
$ ssh-keygen -f mykey
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in mykey
Your public key has been saved in mykey.pub
The key fingerprint is:
SHA256:S3phZ5gVZ1RZpsJ/PvlLFoDS6pHYueaOQsI4Vaqu3aU steve@steveui-MacBookPro.local
The key's randomart image is:
+---[RSA 3072]----+
|          ..+..oo|
|     .    .=. .o |
|    o    ..oo..  |
|   o    o+=  o.  |
|  =    .S*o   ...|
| + o . +.=o    oo|
|. . o o o+     =.|
| o . + .+     o o|
|o . E ...o     .o|
+----[SHA256]-----+
```

passphrase는 빈칸으로 입력해서 키를 생성합니다.

```bash
$ ls mykey*
mykey     mykey.pub
```

비밀키인 `mykey`와 공개키인 `mykey.pub`이 생성되었습니다.

## init, plan, apply

테라폼 초기화를 진행합니다.

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Finding latest version of hashicorp/cloudinit...
- Installing hashicorp/aws v4.17.1...
- Installed hashicorp/aws v4.17.1 (signed by HashiCorp)
- Installing hashicorp/cloudinit v2.2.0...
- Installed hashicorp/cloudinit v2.2.0 (signed by HashiCorp)

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
...

Plan: 17 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_id        = (known after apply)
  + instance_public_ip = (known after apply)
  + instance_type      = "t3.micro"

────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly
these actions if you run "terraform apply" now.
```

17개의 리소스가 만들어질 예정입니다.

```bash
$ terraform apply
...

Plan: 17 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_id        = (known after apply)
  + instance_public_ip = (known after apply)
  + instance_type      = "t3.micro"

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

중간에 `yes`를 입력해서 계속 진행합니다.

```bash
...

Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

instance_id = "i-023aac47f417315bf"
instance_public_ip = "3.39.222.128"
instance_type = "t3.micro"
```

생성이 완료되었습니다.
생성한 EC2에 SSH로 로그인합니다.

```bash
$ ssh 3.39.222.128 -l ec2-user -i mykey
The authenticity of host '3.39.222.128 (3.39.222.128)' can't be established.
ED25519 key fingerprint is SHA256:fXJogaXJo85tB1j7zBH4GCQ9YaXjyoiwqVQSI1OjDkw.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '3.39.222.128' (ED25519) to the list of known hosts.

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
No packages needed for security; 1 packages available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-0-1-131 ~]$
```

유저데이터(스크립트)가 잘 적용되었는지 확인해봅니다.

```bash
[root@ip-10-0-1-131 log]# df -h
Filesystem                Size  Used Avail Use% Mounted on
devtmpfs                  462M     0  462M   0% /dev
tmpfs                     470M     0  470M   0% /dev/shm
tmpfs                     470M  412K  470M   1% /run
tmpfs                     470M     0  470M   0% /sys/fs/cgroup
/dev/nvme0n1p1            8.0G  1.6G  6.5G  20% /
/dev/mapper/data-volume1   20G   45M   19G   1% /data
tmpfs                      94M     0   94M   0% /run/user/1000
```

`/data` 파일시스템이 자동적으로 생성되었네요.

유저데이터의 실행 기록은 `/var/log/cloud-init-output.log` 파일에서 확인 가능합니다.

```bash
[root@ip-10-0-1-131 log]# tail -30 /var/log/cloud-init-output.log
First data block=0
Maximum filesystem blocks=2153775104
160 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
	4096000

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

+ mkdir -p /data
+ echo '/dev/data/volume1 /data ext4 defaults 0 0'
+ mount /data
+ curl https://get.docker.com
+ bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 20009  100 20009    0     0   386k      0 --:--:-- --:--:-- --:--:--  390k
# Executing docker install script, commit: b2e29ef7a9a89840d2333637f7d1900a83e7153f

ERROR: Unsupported distribution 'amzn'

Jun 07 16:14:44 cloud-init[2532]: util.py[WARNING]: Failed running /var/lib/cloud/instance/scripts/part-002 [1]
Jun 07 16:14:44 cloud-init[2532]: cc_scripts_user.py[WARNING]: Failed to run module scripts-user (scripts in /var/lib/cloud/instance/scripts)
Jun 07 16:14:44 cloud-init[2532]: util.py[WARNING]: Running module scripts-user (<module 'cloudinit.config.cc_scripts_user' from '/usr/lib/python2.7/site-packages/cloudinit/config/cc_scripts_user.pyc'>) failed
Cloud-init v. 19.3-45.amzn2 finished at Tue, 07 Jun 2022 16:14:44 +0000. Datasource DataSourceEc2.  Up 35.52 seconds
```

인스턴스에서 로그아웃합니다.

```bash
[root@ip-10-0-1-131 log]# exit
exit
[ec2-user@ip-10-0-1-131 ~]$ exit
logout
Connection to 3.39.222.128 closed.
```

## destroy

실습이 끝났습니다.  
테라폼으로 생성한 리소스 전체를 삭제합니다.

```bash
$ terraform destroy
...

Plan: 0 to add, 0 to change, 17 to destroy.

Changes to Outputs:
  - instance_id        = "i-023aac47f417315bf" -> null
  - instance_public_ip = "3.39.222.128" -> null
  - instance_type      = "t3.micro" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

중간에 `yes`를 입력해서 삭제를 진행합니다.

```bash
...

aws_vpc.main: Destruction complete after 1s
aws_ebs_volume.ebs-volume-1: Destruction complete after 36s

Destroy complete! Resources: 17 destroyed.
```

17개의 리소스가 삭제 완료되었습니다.
