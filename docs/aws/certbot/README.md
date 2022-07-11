
# Let's Encrpyt 인증서 확인하기

## 개요

Let's Encrypt로 발급받은 SSL 인증서 확인하기

&nbsp;

## 환경

- **nginx/1.18.0** (Ubuntu)
- **OS** : Ubuntu 22.04 LTS

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

```bash
$ crontab -e
```

매일마다 실행할 `certbot` 명령어를 등록합니다.

&nbsp;

```bash
0 12 * * * /usr/bin/certbot renew --quiet
```

위 예제는 매일 정오에 `certbot renew --quiet` 명령을 실행합니다.  
이 명령어는 서버의 SSL 인증서가 향후 30일 이내에 만료되는지 확인하고 30일 이내에 만료되는 경우 갱신합니다.  
`--quiet` 옵션은 certbot이 명령어 실행 결과를 출력하지 않도록 지시하는 옵션입니다.
