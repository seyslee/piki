# 깃허브 여러 계정 사용하기

1대의 머신에서 여러 개의 깃허브 계정 사용하기 위한 설정 가이드

## 설정방법

`~/.ssh/config` 설정파일을 아래 내용을 참고해서 작성합니다.

```bash
# ===============
# Personal Github
# ===============
Host github.com-seyslee
  HostName github.com
  IdentityFile ~/.ssh/personal-git
  User seyslee

# ===============
# Company Github
# ===============
Host github.com-YOUR_COMPANY_NAME
  HostName github.com
  IdentityFile ~/.ssh/id_rsa
  User YOUR_NAME
```

회사와 개인 계정을 분리해서 설정합니다.

&nbsp;

Github에서 사용할 SSH 키 페어도 회사용과 개인용을 분리해서 설정해야 한다.

```bash
$ tree ~/.ssh/
/Users/steve/.ssh/
├── config            # Github SSH 설정파일
├── id_rsa            # 회사 깃허브 계정 전용 키
├── id_rsa.pub        # 회사 깃허브 계정 전용 키
├── known_hosts
├── personal-git      # 개인 깃허브용 키
└── personal-git.pub  # 개인 깃허브용 키
```

&nbsp;

개인 계정의 레포지터리를 Remote로 등록하는 경우

```bash
$ git remote add origin git@github.com-seyslee:seyslee/piki.git
```

&nbsp;

Remote 확인

```bash
$ git remote -v
origin	git@github.com-seyslee:seyslee/piki.git (fetch)
origin	git@github.com-seyslee:seyslee/piki.git (push)
```
