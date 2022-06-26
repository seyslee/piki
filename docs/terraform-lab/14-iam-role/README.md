# 14. IAM Role

## 사전준비

EC2 인스턴스에서 사용할 키페어를 로컬에서 생성합니다.

```bash
$ ssh-keygen -f mykey
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in mykey
Your public key has been saved in mykey.pub
The key fingerprint is:
SHA256:qbRFWrN2Pn1v3PtSlihijtpnDr7pdC1IvInrgtodnVM steve@steveui-MacBookPro.local
The key's randomart image is:
+---[RSA 3072]----+
|                 |
|                 |
|        +        |
|      .+ +       |
|      ooE .   . .|
|     ooB+=.o . .o|
|  . ..**+o+.o .+.|
| o o .=o++.. ...+|
|o . ++o*=.     +=|
+----[SHA256]-----+
```

passphrase는 빈값으로 입력해서 생성합니다.

```bash
$ ls mykey*
mykey     mykey.pub
```

비밀키인 `mykey`와 공개키인 `mykey.pub`이 생성된 걸 확인할 수 있습니다.

## init, plan, apply

**중요**: `s3.tf` 파일과 `iam.tf` 파일 안에 S3 버킷 이름은 각자의 고유한 버킷 이름으로 변경해주세요.  
생성할 때 버킷 이름이 이미 존재할 경우 생성할 수 없습니다.

테라폼을 초기화합니다.

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

초기화가 완료되었습니다.

리소스 플랜을 미리 확인합니다.

```bash
$ terraform plan
...

Plan: 19 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance = (known after apply)

────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee
to take exactly these actions if you run "terraform apply" now.
```

리소스를 생성합니다.

```bash
$ terraform apply
...

Plan: 19 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

```

중간에 `yes`를 입력해서 계속 진행합니다.

```bash
...
aws_route_table_association.main-public-2-a: Creation complete after 0s [id=rtbassoc-0ec02f67bc270f15f]
aws_instance.example: Still creating... [10s elapsed]
aws_instance.example: Creation complete after 12s [id=i-0a32086e70ec285af]

Apply complete! Resources: 19 added, 0 changed, 0 destroyed.

Outputs:

instance = "3.36.49.244"
```

생성이 완료되면 Outputs 값으로 EC2 인스턴스에 접속할 수 있는 IP가 출력됩니다.

SSH 로그인을 시도합니다.  
EC2의 OS가 Amazon Linux 2이기 때문에 ec2-user 계정으로 로그인합니다.

```bash
$ ssh -i mykey -l ec2-user 3.36.49.244
The authenticity of host '3.36.49.244 (3.36.49.244)' can't be established.
ED25519 key fingerprint is SHA256:7p1NTl/gidoo20iQ4bOmJbVYRs7yAghYIatLUTF6WOw.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

중간에 yes를 입력합니다.  

```bash
Warning: Permanently added '3.36.49.244' (ED25519) to the list of known hosts.

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
14 package(s) needed for security, out of 26 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-0-1-32 ~]$
```

EC2 인스턴스에 접속되었습니다.

AWS CLI가 설치되어 있는지 확인합니다.

```bash
[ec2-user@ip-10-0-1-32 ~]$ which aws
/usr/bin/aws
```

Amazon Linux 2는 기본적으로 AWS CLI가 설치되어 있습니다.

텍스트 파일을 만들고 S3 버킷에 파일 업로드가 잘 되는지 테스트합니다.

```bash
[ec2-user@ip-10-0-1-32 ~]$ echo "Hello world." >> hello.txt
[ec2-user@ip-10-0-1-32 ~]$ aws s3 cp hello.txt s3://mybucket-seyslee-terraform-training
upload: ./hello.txt to s3://mybucket-seyslee-terraform-training/hello.txt
```

참고로 EC2에 부여된 인스턴스 프로파일에는 s3 버킷 목록 조회 권한은 없기 때문에 명령어가 실행되지 않습니다.

```bash
[ec2-user@ip-10-0-1-32 ~]$ aws s3 ls

An error occurred (AccessDenied) when calling the ListBuckets operation: Access Denied
```

## destroy

실습이 끝났으니 테라폼으로 생성한 리소스를 삭제합니다.

```bash
$ terraform destroy
```
