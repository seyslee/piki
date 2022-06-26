클라우드 실무에서는 여러개의 AWS 계정을 관리해야하는 경우가 많다.

생각보다 여러개의 계정 관리가 CLI에서는 헷갈리기 때문에, 기록해둔다.

<br>

**Profile 스위칭**
```bash
$ export AWS_PROFILE=profile-name-to-switch
```

<br>

**관련 파일 구조**

기본적으로 사용자의 홈 디렉토리에 위치한다.

```bash
~/
└── .aws/
    ├── config
    └── credentials
```

- AWS 공식 문서상에서 `Access Key ID`와 `Secret Access Key` 값은 credentials에 별도로 분리해서 사용하는 걸 권장하고 있다.
  
  > Specifies the AWS access key used as part of the credentials to authenticate the command request. Although this can be stored in the config file, we recommend that you store this in the credentials file. - AWS
  >
  > **AWS 공식문서**  
  > https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-settings

<br>

**config**

샘플 `config` 파일

```yaml
# alice is iam user
[profile alice]
region = ap-northeast-2
output = json

# bob is assumed-role
[profile bob]
role_arn = arn:aws:iam::111111111111:role/role-name
source_profile = default
mfa_serial = arn:aws:iam::111111111111:mfa/alice

# carol is iam user
[profile carol]
region = ap-northeast-2
output = json
```