

**~/.ssh/config**
```bash
# ===== Personal Github =====
Host github.com-seyslee
  HostName github.com
  IdentityFile ~/.ssh/personal-git
  User seyslee

# ===== Company(username) Github =====
Host github.com-username-corp
  HostName github.com
  IdentityFile ~/.ssh/id_rsa
  User username-corp
```
회사와 개인 계정을 분리해서 설정한다.

<br>

Github에서 사용할 SSH 키 페어도 회사용과 개인용을 분리해서 설정해야 한다.

```bash
$ ls -l ~/.ssh/
total 56
-rw-r--r--  1 xxxxx  staff   264  3 11 16:28 config
## Company key pair
-rw-------  1 xxxxx  staff  2622  2 15 10:52 id_rsa
-rw-r--r--  1 xxxxx  staff   584  2 15 10:52 id_rsa.pub
-rw-------  1 xxxxx  staff  1419  4 29 16:00 known_hosts
-rw-------  1 xxxxx  staff   847  4 29 15:59 known_hosts.old
## Personal key pair
-rw-------  1 xxxxx  staff  3389  3  5 22:47 personal-git
-rw-r--r--  1 xxxxx  staff   749  3  5 22:47 personal-git.pub
```

<br>

개인 계정의 레포지터리를 Remote로 등록하는 경우

```bash
$ git remote add origin git@github.com-seyslee:seyslee/piki.git
```

<br>

Remote 확인

```bash
$ git remote -v
$ origin	git@github.com-seyslee:seyslee/piki.git (fetch)
$ origin	git@github.com-seyslee:seyslee/piki.git (push)
```