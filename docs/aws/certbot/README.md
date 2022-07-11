
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
$ ps -ef --forest | grep nginx
ubuntu     31918   31905  0 14:45 pts/1    00:00:00                              \_ grep --color=auto nginx
root       28743       1  0 07:55 ?        00:00:00 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
www-data   30061   28743  0 08:24 ?        00:00:00  \_ nginx: worker process
www-data   30062   28743  0 08:24 ?        00:00:01  \_ nginx: worker process
```

nginx 마스터 프로세스와 워커 프로세스가 떠있습니다.

&nbsp;

nginx 설정 확인

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

### 인증서 정보 확인

root 권한으로 실행해야 합니다.

```bash
$ certbot certificates
The following error was encountered:
[Errno 13] Permission denied: '/var/log/letsencrypt/.certbot.lock'
Either run as root, or set --config-dir, --work-dir, and --logs-dir to writeable paths.
Ask for help or search for solutions at https://community.letsencrypt.org. See the logfile /tmp/tmpj2ik17bb/log or re-run Certbot with -v for more details.
```

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