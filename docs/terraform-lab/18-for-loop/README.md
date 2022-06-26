# 18. for 반복문

## code1

```bash
$ ls
variables.tf
```

현재 code1 디렉토리에는 `variables.tf` 라는 파일만 있습니다.

2개의 리스트와 1개의 맵이 정의되어 있어서 for문 테스트를 할 수 있습니다.

테라폼 콘솔에 들어갑니다.

```bash
$ terraform console
>
```

```bash
> [for s in ["a", "b", "c"]: s]
[
  "a",
  "b",
  "c",
]
```

```bash
> [for s in ["a", "b", "c"]: upper(s)]
[
  "A",
  "B",
  "C",
]
```

for 반복문을 사용해서 모든 문자열을 대문자로 변환할 수도 있습니다.


```bash
> [for s in var.list1: s + 1]
[
  2,
  11,
  10,
  102,
  4,
]
```

```bash
> [for s in var.list2: upper(s)]
[
  "APPLE",
  "PEAR",
  "BANANA",
  "MANGO",
]
```

리스트 안에 있는 값들을 모두 대문자로 치환합니다.

```bash
> [for key, value in var.map1: key] 
[
  "apple",
  "banana",
  "mango",
  "pear",
]
```

```bash
> [for key, value in var.map1: value] 
[
  5,
  10,
  0,
  3,
]
```

```bash
> {for key, value in var.map1: value => key}
{
  "0" = "mango"
  "10" = "banana"
  "3" = "pear"
  "5" = "apple"
}
```

map 안에 들어있는 value와 key 값을 바꿔서 출력해봅니다.

## code2

code2 디렉토리로 이동합니다.

```bash
$ ls
ebs.tf       provider.tf  variables.tf
```

EBS 볼륨 코드의 내용을 확인하면 for 문을 사용해서 Myvolume 태그와 변수로 선언된 var.project_tags 태그를 합치는 내용이 있습니다.

```bash
$ cat ebs.tf
resource "aws_ebs_volume" "example" {
  availability_zone = "ap-northeast-2a"
  size              = 8

  tags = {for k, v in merge({ Name = "Myvolume" }, var.project_tags): k => lower(v)}
}
```

`lower()` 함수로 인해 합쳐진 태그들의 값은 모두 소문자로 치환하게 됩니다.

테라폼을 초기화합니다.

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v4.18.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

플랜을 통해 어떻게 변환되었는지 미리 확인해봅니다.

```bash
$ terraform plan
...

Terraform will perform the following actions:

  # aws_ebs_volume.example will be created
  + resource "aws_ebs_volume" "example" {
      ...
      + tags              = {
          + "Component"   = "frontend"
          + "Environment" = "production"
          + "Name"        = "myvolume"
        }
      + tags_all          = {
          + "Component"   = "frontend"
          + "Environment" = "production"
          + "Name"        = "myvolume"
        }
      ...
    }

Plan: 1 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Name 태그와 변수로 선언된 Component, Environment 태그가 합쳐진 걸 확인할 수 있습니다.

태그의 값들은 모두 소문자로 변환되었습니다. 대표적인 예로 MyVolume이 `myvolume`으로 출력된 걸 확인할 수 있습니다.

`apply`까지 할 필요는 없기 때문에 여기서 실습을 마치겠습니다.

## 참고

이번 과정에서는 생성한 리소스가 없기 때문에 `terraform destroy`를 실행할 필요 없습니다.

결과가 궁금하다면 한 번 `terraform destroy`를 실행해봐도 괜찮습니다.

```bash
$ terraform destroy

No changes. No objects need to be destroyed.

Either you have not created any objects yet or the existing objects were already deleted outside of Terraform.

Destroy complete! Resources: 0 destroyed.
```
