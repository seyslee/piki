
# 개요

파이썬 코드로 시스템 구성도를 그릴 수 있다.

<br>

**diagrams**  
파이썬 기반의 시스템 구성도를 그리는 오픈소스 라이브러리  

<br>

# 환경

- **OS** : macOS Monterey 12.3.1
- **Shell** : zsh + ohymzsh
- **Python 3.9.12**
- **Homebrew 3.4.11**

<br>

# 전제조건

macOS용 패키지 관리자인 brew가 미리 설치되어 있어야 함

<br>

# 설치 및 사용방법

### graphviz 설치

diagrams를 사용하려면 일단 graphviz를 먼저 설치해야 한다.  

**graphviz**  
AT&T와 벨 연구소에서 만든 관계도 시각화<sup>Graph Visualization</sup> 소프트웨어이다.  

graphviz가 설치되어 있지 않은 상태에서 diagram 코드를 실행하게 되면 아래와 같은 에러가 발생한다.  

```bash
$ python3 diagram.py
Traceback (most recent call last):
  File "/opt/homebrew/lib/python3.9/site-packages/graphviz/backend/execute.py", line 81, in run_check
    proc = subprocess.run(cmd, **kwargs)
  File "/opt/homebrew/Cellar/python@3.9/3.9.12/Frameworks/Python.framework/Versions/3.9/lib/python3.9/subprocess.py", line 505, in run
    with Popen(*popenargs, **kwargs) as process:
  File "/opt/homebrew/Cellar/python@3.9/3.9.12/Frameworks/Python.framework/Versions/3.9/lib/python3.9/subprocess.py", line 951, in __init__
    self._execute_child(args, executable, preexec_fn, close_fds,
  File "/opt/homebrew/Cellar/python@3.9/3.9.12/Frameworks/Python.framework/Versions/3.9/lib/python3.9/subprocess.py", line 1821, in _execute_child
    raise child_exception_type(errno_num, err_msg, err_filename)
FileNotFoundError: [Errno 2] No such file or directory: PosixPath('dot')

The above exception was the direct cause of the following exception:

Traceback (most recent call last):
  File "/Users/steve/github/personal/diagram.py", line 8, in <module>
    ELB("lb") >> EC2("web") >> RDS("userdb")
  File "/opt/homebrew/lib/python3.9/site-packages/diagrams/__init__.py", line 154, in __exit__
    self.render()
  File "/opt/homebrew/lib/python3.9/site-packages/diagrams/__init__.py", line 188, in render
    self.dot.render(format=self.outformat, view=self.show, quiet=True)
  File "/opt/homebrew/lib/python3.9/site-packages/graphviz/_tools.py", line 172, in wrapper
    return func(*args, **kwargs)
  File "/opt/homebrew/lib/python3.9/site-packages/graphviz/rendering.py", line 119, in render
    rendered = self._render(*args, **kwargs)
  File "/opt/homebrew/lib/python3.9/site-packages/graphviz/_tools.py", line 172, in wrapper
    return func(*args, **kwargs)
  File "/opt/homebrew/lib/python3.9/site-packages/graphviz/backend/rendering.py", line 317, in render
    execute.run_check(cmd,
  File "/opt/homebrew/lib/python3.9/site-packages/graphviz/backend/execute.py", line 84, in run_check
    raise ExecutableNotFound(cmd) from e
graphviz.backend.execute.ExecutableNotFound: failed to execute PosixPath('dot'), make sure the Graphviz executables are on your systems' PATH
```

```bash
$ brew install graphviz
...
==> Installing graphviz
==> Pouring graphviz--3.0.0.arm64_monterey.bottle.tar.gz
🍺  /opt/homebrew/Cellar/graphviz/3.0.0: 292 files, 7.4MB
==> Running `brew cleanup graphviz`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
```

```bash
$ brew info graphviz
graphviz: stable 3.0.0 (bottled), HEAD
...
```

설치된 graphviz의 버전은 `stable 3.0.0`으로 확인된다.  

<br>

### diagrams 설치

```bash
# using pip (pip3)
$ pip install diagrams
```

diagrams는 brew를 통해 설치할 수 없다. `brew search diagrams`로 검색해도 결과가 없는 걸로 확인.

<br>

### diagrams 사용법

간단한 데모 구성도 코드를 작성해본다.

```python
# diagram.py
from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB

with Diagram("Web Service", show=False):
    ELB("lb") >> EC2("web") >> RDS("userdb")
```

작성한 파이썬 코드를 `diagram.py` 라는 이름으로 저장한다.

```bash
$ python3 diagram.py
```

터미널에서 diagram.py 코드를 실행한다.

```bash
$ ls -l
total 72
-rw-r--r--   1 steve  staff    240  5 13 17:47 diagram.py
-rw-r--r--   1 steve  staff  32191  5 13 17:56 web_service.png
```

결과물인 `web_service.png`가 생성된 걸 확인할 수 있다.  

![](./1.png)

더 복잡한 구성도 작성 방법은 언제나 그렇듯 [diagrams의 공식 문서](https://diagrams.mingrammer.com/docs/getting-started/installation)를 참고하도록 한다.  

<br>

# 결론

이젠 코드로 구성도까지 그리는 시대가 와버렸다.  
코드로는 모든 일이 가능하다. 내가 하는 일 조차도!  