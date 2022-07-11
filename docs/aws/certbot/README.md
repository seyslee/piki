
# Let's Encrpyt 인증서 확인하기

## 개요

Let's Encrypt로 발급받은 SSL 인증서 정보를 확인하는 방법을 간단히 소개합니다.  
nginx 환경 기준으로 작성된 글입니다.

&nbsp;

## 환경

- **nginx/1.18.0** (Ubuntu)
- **OS** : Ubuntu 22.04 LTS
- **certbot v1.21.0**

&nbsp;

## SSL 인증서 확인하기

### nginx 설정 확인

웹서버로 nginx를 사용하는 구성입니다.

```bash
$ ps -ef --forest | grep nginx | grep -v grep
root       28743       1  0 07:55 ?        00:00:00 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
www-data   30061   28743  0 08:24 ?        00:00:00  \_ nginx: worker process
www-data   30062   28743  0 08:24 ?        00:00:01  \_ nginx: worker process
```

nginx의 마스터 프로세스와 워커 프로세스 2개가 동작하고 있습니다.

&nbsp;

nginx 설정을 확인합니다.

```bash
$ cat /etc/nginx/sites-available/default

...

server {

  server_name www.company.com;

  client_max_body_size 100M;

  location / {
    proxy_pass http://127.0.0.1:1337;
  }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/www.company.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/www.company.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

...

```

SSL 인증서와 키가 등록되어 있습니다.  
TCP/443 포트(HTTPS)로 접근시 SSL 인증서를 사용하는 설정입니다.  
참고로 `# managed by Certbot` 주석에 적혀있는 것처럼 대부분이 Certbot에 의해 자동 등록된 설정입니다.

&nbsp;

### SSL 인증서 정보 확인

`certbot`은 HTTPS/TLS/SSL 인증서를 발급받고 설치할 수 있는 툴입니다.

SSL 인증서 정보를 확인하는 명령어입니다.

```bash
$ sudo certbot certificates
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Found the following certs:
  Certificate Name: www.company.com
    Serial Number: 0xx00fxafe000a000b0ea0000x00638e000
    Key Type: RSA
    Domains: www.company.com
    Expiry Date: 2022-10-09 07:24:52+00:00 (VALID: 89 days)
    Certificate Path: /etc/letsencrypt/live/www.company.com/fullchain.pem
    Private Key Path: /etc/letsencrypt/live/www.company.com/privkey.pem
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

&nbsp;

`certbot` 명령어를 실행할 권한이 부족할 경우 아래와 같은 에러가 발생합니다.

```bash
$ certbot certificates
The following error was encountered:
[Errno 13] Permission denied: '/var/log/letsencrypt/.certbot.lock'
Either run as root, or set --config-dir, --work-dir, and --logs-dir to writeable paths.
Ask for help or search for solutions at https://community.letsencrypt.org. See the logfile /tmp/tmpj2ik17bb/log or re-run Certbot with -v for more details.
```

&nbsp;

### 자동갱신 설정

Let's Encrypt에서 발급받은 SSL 인증서는 기본 유효기간이 90일입니다.  
Let's Encrypt 공식문서에서는 SSL 인증서를 2개월(60일) 주기로 갱신하는 걸 권장합니다.

```bash
$ certbot --version
certbot 1.21.0
```

현재 `certbot v1.21.0`을 사용하고 있습니다.

&nbsp;

이미 certbot 설치 과정에서 인증서 갱신 cron job이 `/etc/cron.d/certbot` 파일에 자동 등록됩니다.  
별도로 관리자가 인증서 갱신 스케줄을 등록할 필요가 없습니다.

```bash
$ cat /etc/cron.d/certbot
# /etc/cron.d/certbot: crontab entries for the certbot package
#
# Upstream recommends attempting renewal twice a day
#
# Eventually, this will be an opportunity to validate certificates
# haven't been revoked, etc.  Renewal will only occur if expiration
# is within 30 days.
#
# Important Note!  This cronjob will NOT be executed if you are
# running systemd as your init system.  If you are running systemd,
# the cronjob.timer function takes precedence over this cronjob.  For
# more details, see the systemd.timer manpage, or use systemctl show
# certbot.timer.
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

0 */12 * * * root test -x /usr/bin/certbot -a \! -d /run/systemd/system && perl -e 'sleep int(rand(43200))' && certbot -q renew
```

매일마다 2번, 자정(00:00)과 정오(12:00)에 SSL 인증서 갱신을 시도하는 크론 잡입니다.  
SSL 인증서의 유효기간이 30일 미만으로 남게 되면 자동으로 갱신 됩니다.  
유효기간이 30일 이상이면 유효기간 체크만 하고 갱신은 스킵합니다.

&nbsp;

## 참고자료

**인증서 자동 갱신 관련 글**  
<https://serverfault.com/questions/790772/cron-job-for-lets-encrypt-renewal>
