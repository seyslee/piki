# 깃허브 여러 계정 사용하기

1대의 랩탑 환경에서 회사용 깃허브 계정과 개인용 깃허브 계정을 같이 사용하기 위한 설정 방법을 안내하는 가이드입니다.

&nbsp;

## 1. gitconfig

### gitconfig 설정

```bash
$ tree ~ -aL 1 | grep git
├── .gitconfig           # 공용 gitconfig
├── .gitconfig-company   # 회사용 gitconfig
└── .gitconfig-personal  # 개인용 gitconfig
```

**기본**  
기본 `.gitconfig` 설정파일을 작성합니다.

```conf
[url "git@github.com:"]
  insteadOf = https://github.com/

[user]
  name = your-personal-github-name
  email = your-personal@github-email.com

[includeIf "gitdir:/Users/alice/github/personal/"]
  path = .gitconfig-personal

[includeIf "gitdir:/Users/alice/github/company/"]
  path = .gitconfig-company
```

**company**  
회사용 `.gitconfig` 설정파일을 작성합니다.

```bash
$ cat ~/.gitconfig-personal
[user]
  name = your-personal-github-name
  email = your-personal@github-email.com
```

**personal**  
개인용 `.gitconfig` 설정파일을 작성합니다.

```bash
$ cat ~/.gitconfig-company
[user]
  name = your-company-github-name
  email = your-company@github-email.com
```

### gitconfig 테스트

**company**  
회사 깃허브 디렉토리에 들어간 다음, 회사용 `.gitconfig`의 설정을 가져오는 지 확인합니다.

```bash
$ git config --show-origin user.name
file:/Users/alice/.gitconfig-company  alice

$ git config --show-origin user.email
file:/Users/alice/.gitconfig-company  alice@company.com
```

**personal**  
개인 깃허브 디렉토리에 들어간 다음, 회사용 `.gitconfig`의 설정을 가져오는 지 확인합니다.

```bash
$ git config --show-origin user.name
file:/Users/alice/.gitconfig-personal seyslee

$ git config --show-origin user.email
file:/Users/alice/.gitconfig-personal seyslee@kakao.com
```

&nbsp;

## 2. Github SSH

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
Host github.com-YOUR_COMPANY_GITHUB_NAME
  HostName github.com
  IdentityFile ~/.ssh/id_rsa
  User YOUR_COMPANY_GITHUB_NAME
```

회사와 개인 계정을 분리해서 설정합니다.

&nbsp;

Github에서 사용할 SSH 키 페어도 회사용과 개인용을 분리해서 설정해야 한다.

```bash
$ tree ~/.ssh/
/Users/alice/.ssh/
├── config            # Github SSH 설정파일
├── id_rsa            # 회사 깃허브 계정 전용 키
├── id_rsa.pub        # 회사 깃허브 계정 전용 키
├── known_hosts
├── personal-git      # 개인 깃허브용 키
└── personal-git.pub  # 개인 깃허브용 키
```

&nbsp;

## 사용시 주의사항

### 개인 레포지터리의 Remote 등록방법

개인 계정의 레포지터리를 Remote로 등록할 경우 아래 명령어를 사용해서 remote를 등록해야합니다.

```bash
$ git remote add origin git@github.com-seyslee:seyslee/piki.git
```

추가된 remote 상세 정보를 확인합니다.

```bash
$ git remote -v
origin  git@github.com-seyslee:seyslee/piki.git (fetch)
origin  git@github.com-seyslee:seyslee/piki.git (push)
```
