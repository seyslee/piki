# 9. EBS 볼륨

## 사전준비

이번에도 로컬 SSH 키를 기반으로 EC2 Key Pair를 생성하려고 합니다.

로컬에서 SSH Key Pair를 먼저 생성합니다.

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
SHA256:2dV6SNIVncqPydkz4YPhhoPfcDbSlqpqg5CmQcVoWis steve@steveui-MacBookPro.local
The key's randomart image is:
+---[RSA 3072]----+
|  o           oo.|
| o.o       . o ..|
|o...      . = o  |
|E..      o + * . |
|..  .   S o B % .|
| . +     . = ^ B |
|  + . .   . @ . +|
| .   . o   o .   |
|      ..o..      |
+----[SHA256]-----+
```

passphrase는 빈 칸으로 넣어줘서 생성합니다.

```bash
$ ls mykey*
mykey     mykey.pub
```

비밀키 `mykey`와 공개키 `mykey.pub`이 생성되었습니다.

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

테라폼 초기화가 완료되었습니다.

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

17개의 리소스가 생성될 예정입니다.

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

중간에 `yes`를 입력합니다.

```bash
Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

instance_id = "i-072229dfc4b3b9bf0"
instance_public_ip = "3.38.169.23"
instance_type = "t3.micro"
```

Output에 출력된 `instance_public_ip`는 테라폼으로 생성된 EC2 인스턴스의 공인 IP입니다.  
위 IP로 SSH 접속합니다.

```bash
$ ssh 3.38.169.23 -l ec2-user -i mykey
```

`-l` : 인스턴스에 로그인할 계정 이름입니다. Amazon Linux 2 운영체제이기 때문에 ec2-user로 로그인합니다.
`-i` : 처음에 생성한 비밀키의 파일명을 입력합니다.

```bash
$ ssh 3.38.169.23 -l ec2-user -i mykey
The authenticity of host '3.38.169.23 (3.38.169.23)' can't be established.
ED25519 key fingerprint is SHA256:mCapW5/DTPXwWBWiZRooUXngybqU61p2mv5pXhwiMlQ.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '3.38.169.23' (ED25519) to the list of known hosts.

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
2 package(s) needed for security, out of 6 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-0-1-174 ~]$
```

파일시스템을 확인합니다.

```bash
[ec2-user@ip-10-0-1-174 ~]$ sudo -s
[root@ip-10-0-1-174 ec2-user]# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        462M     0  462M   0% /dev
tmpfs           470M     0  470M   0% /dev/shm
tmpfs           470M  408K  470M   1% /run
tmpfs           470M     0  470M   0% /sys/fs/cgroup
/dev/nvme0n1p1  8.0G  1.6G  6.5G  20% /
tmpfs            94M     0   94M   0% /run/user/1000
```

8GB 용량의 루트 볼륨 뿐이네요.

데이터 볼륨으로 사용할 ext4 타입의 파일시스템을 추가로 생성해줍니다.

```bash
[root@ip-10-0-1-174 ec2-user]# mkfs.ext4 /dev/xvdh
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
1310720 inodes, 5242880 blocks
262144 blocks (5.00%) reserved for the super user
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
```

마운트 포인트로 사용할 디렉토리를 만들어줍니다. 경로는 `/data` 입니다.
```bash
[root@ip-10-0-1-174 ec2-user]# mkdir /data
```

데이터 볼륨을 마운트 해줍니다.

```
[root@ip-10-0-1-174 ec2-user]# mount /dev/xvdh /data
```

파일시스템을 다시 확인합니다.

```
[root@ip-10-0-1-174 ec2-user]# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        462M     0  462M   0% /dev
tmpfs           470M     0  470M   0% /dev/shm
tmpfs           470M  408K  470M   1% /run
tmpfs           470M     0  470M   0% /sys/fs/cgroup
/dev/nvme0n1p1  8.0G  1.6G  6.5G  20% /
tmpfs            94M     0   94M   0% /run/user/1000
/dev/nvme1n1     20G   45M   19G   1% /data
```

`/data` 파일시스템이 새로 생성되었습니다.

`nvme1n1` 볼륨이 `/data` 마운트포인트로 연결된 걸 확인하실 수 있습니다.

```bash
[root@ip-10-0-1-174 ec2-user]# lsblk
NAME          MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
nvme0n1       259:0    0   8G  0 disk
├─nvme0n1p1   259:1    0   8G  0 part /
└─nvme0n1p128 259:2    0   1M  0 part
nvme1n1       259:3    0  20G  0 disk /data
```

새로 만든 `/data/` 볼륨은 이 인스턴스를 재부팅하면 사라지게 됩니다.  
이를 방지하기 위해 `/etc/fstab`에 영구 등록하도록 하겠습니다.

```bash
$ cat /etc/fstab
#
UUID=2a7884f1-a23b-49a0-8693-ae82c155e5af     /           xfs    defaults,noatime  1   1
```

```bash
$ vi /etc/fstab
#
UUID=2a7884f1-a23b-49a0-8693-ae82c155e5af     /           xfs    defaults,noatime  1   1
/dev/xvdh /data ext4 defaults 0 0
```

마운트를 해제했다가 다시 마운트 테스트를 해보겠습니다.

```bash
[root@ip-10-0-1-174 ec2-user]# umount /data
[root@ip-10-0-1-174 ec2-user]# mount /data
```

파일시스템을 다시 확인합니다.
`/data` 볼륨이 정상적으로 마운트되었습니다.

```bash
[root@ip-10-0-1-174 ec2-user]# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        462M     0  462M   0% /dev
tmpfs           470M     0  470M   0% /dev/shm
tmpfs           470M  408K  470M   1% /run
tmpfs           470M     0  470M   0% /sys/fs/cgroup
/dev/nvme0n1p1  8.0G  1.6G  6.5G  20% /
tmpfs            94M     0   94M   0% /run/user/1000
/dev/nvme1n1     20G   45M   19G   1% /data
```

인스턴스에서 로그아웃 합니다.

```bash
[root@ip-10-0-1-174 ec2-user]# exit
exit
[ec2-user@ip-10-0-1-174 ~]$ exit
logout
Connection to 3.38.169.23 closed.
```

## destroy

실습이 끝났습니다.  
테라폼으로 생성한 모든 리소스를 삭제합니다.

```bash
$ terraform destroy
...

Plan: 0 to add, 0 to change, 17 to destroy.

Changes to Outputs:
  - instance_id        = "i-072229dfc4b3b9bf0" -> null
  - instance_public_ip = "3.38.169.23" -> null
  - instance_type      = "t3.micro" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```

yes를 입력해서 계속 진행합니다.

```bash
...
Destroy complete! Resources: 17 destroyed.
```

테라폼으로 생성한 리소스가 모두 삭제 되었습니다.
