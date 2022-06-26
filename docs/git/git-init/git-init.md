---
title: "Github init 하기"
date: 2022-01-14T18:36:09+09:00
lastmod: 2022-01-14T18:36:24+09:00
tags: ["git"]
description: "첫 til 포스트입니다."
---

# 개요

git 레포지터리 연결하는 방법  
<br>

# 환경

- **OS** : macOS Monterey 12.1

- **Shell** : zsh

- **Terminal Program** : iTerm2
  
  <br>

# 절차

### 1. init

```bash
$ cd til
```

til 디렉토리로 이동한다.

```bash
$ ls
```

방금 새로 만들었기 때문에 파일이 존재하지 않는다.

이제부터 이 디렉토리 내부를 github repository로 쓸 예정이다.

```bash
$ git init
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint:
hint:     git config --global init.defaultBranch <name>
hint:
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint:
hint:     git branch -m <name>
Initialized empty Git repository in /Users/ive/githubrepos/til/.git/
$ git branch
$ git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

<br>

### 2. branch 설정

branch를 master 말고 main 으로 변경한다.

```
$ git branch -m master main
$ git status
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

<br>

### 3. 파일생성 및 commit

레포 만들면 처음에 README.md를 생성하는 건 국룰이다.

```bash
$ echo "Hello world from til" > README.md
$ ls
README.md
```

```
$ cat README.md
Hello world from til
```

```bash
$ ls
README.md
$ git add .
$ git status
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
    new file:   README.md
```

최초 커밋 메세지 "Initialized"

```bash
$ git commit -m "Initialized"
[main (root-commit) 1fcd408] Initialized
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
```

<br>

### 4. 원격저장소 등록

```bash
$ git remote add origin https://github.com/seyslee/til.git
                                           ---+---
                                              |
                                              `--> Change to your github username
```

각자 유저네임에 맞게 원격저장소(remote) URL을 변경해주자.

```bash
$ git remote -v
origin    https://github.com/seyslee/til.git (fetch)
origin    https://github.com/seyslee/til.git (push)
```

원격저장소(remote)가 잘 등록되었다.  
<br>

### 5. push

마지막으로 local file을 github 저장소로 밀어넣는 작업인 push를 실행하면 끝!

```bash
$ git push -u origin main
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Writing objects: 100% (3/3), 234 bytes | 234.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/seyslee/til.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```
