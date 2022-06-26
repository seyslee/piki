# trivy cheatsheet

사용 편의성이 뛰어나고 성능도 좋은 취약점 스캐너  
Amazon Linux 2의 ALSA 취약점 소스도 제공한다.

[trivy에서 지원하는 데이터 소스](https://aquasecurity.github.io/trivy/v0.29.1/docs/vulnerability/detection/data-source/)

## 설치

```bash
$ brew install aquasecurity/trivy/trivy
```

```bash
$ trivy version
Version: 0.29.1
Vulnerability DB:
  Version: 2
  UpdatedAt: 2022-06-16 06:06:28.171512256 +0000 UTC
  NextUpdate: 2022-06-16 12:06:28.171511856 +0000 UTC
  DownloadedAt: 2022-06-16 07:07:50.248157 +0000 UTC
```

## 스캐닝

```bash
$ trivy image --severity "LEVELS" PUBLIC_REPO_URL
```

`--severity` 옵션으로 취약점 레벨을 정할 수 있습니다.

```bash
$ trivy image --severity HIGH,CRITICAL \
--output ./ebs-csi-driver.txt \
amazon/aws-ebs-csi-driver:v1.5.1
```

`--output` 옵션으로 결과를 별도 파일에 저장할 수 있습니다.

```bash
$ trivy image --severity "HIGH,CRITICAL" amazon/aws-ebs-csi-driver:v1.5.1
...
amazon/aws-ebs-csi-driver:v1.5.1 (amazon 2 (Karoo))

Total: 8 (HIGH: 7, CRITICAL: 1)

┌────────────────┬────────────────┬──────────┬────────────────────────┬───────────────────────┬────────────────────────────────────────────────────────────┐
│    Library     │ Vulnerability  │ Severity │   Installed Version    │     Fixed Version     │                           Title                            │
├────────────────┼────────────────┼──────────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────┤
│ cyrus-sasl-lib │ CVE-2022-24407 │ HIGH     │ 2.1.26-23.amzn2        │ 2.1.26-24.amzn2       │ cyrus-sasl: failure to properly escape SQL input allows an │
│                │                │          │                        │                       │ attacker to execute...                                     │
│                │                │          │                        │                       │ https://avd.aquasec.com/nvd/cve-2022-24407                 │
├────────────────┼────────────────┼──────────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────┤
│ expat          │ CVE-2022-25235 │ CRITICAL │ 2.1.0-12.amzn2         │ 2.1.0-12.amzn2.0.3    │ expat: Malformed 2- and 3-byte UTF-8 sequences can lead to │
│                │                │          │                        │                       │ arbitrary code...                                          │
│                │                │          │                        │                       │ https://avd.aquasec.com/nvd/cve-2022-25235                 │
│                ├────────────────┼──────────┤                        │                       ├────────────────────────────────────────────────────────────┤
│                │ CVE-2022-25236 │ HIGH     │                        │                       │ expat: Namespace-separator characters in "xmlns[:prefix]"  │
│                │                │          │                        │                       │ attribute values can lead to arbitrary code...             │
│                │                │          │                        │                       │ https://avd.aquasec.com/nvd/cve-2022-25236                 │
├────────────────┼────────────────┼──────────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────┤
│ expat          │ CVE-2022-25315 │ HIGH     │ 2.1.0-12.amzn2         │ 2.1.0-12.amzn2.0.2    │ expat: Integer overflow in storeRawNames()                 │
│                │                │          │                        │                       │ https://avd.aquasec.com/nvd/cve-2022-25315                 │
├────────────────┼────────────────┤          ├────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────┤
│ gzip           │ CVE-2022-1271  │          │ 1.5-10.amzn2           │ 1.5-10.amzn2.0.1      │ gzip: arbitrary-file-write vulnerability                   │
│                │                │          │                        │                       │ https://avd.aquasec.com/nvd/cve-2022-1271                  │
├────────────────┼────────────────┼──────────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────┤
│ openssl-libs   │ CVE-2022-0778  │ HIGH     │ 1:1.0.2k-19.amzn2.0.10 │ 1:1.0.2k-24.amzn2.0.2 │ openssl: Infinite loop in BN_mod_sqrt() reachable when     │
│                │                │          │                        │                       │ parsing certificates                                       │
│                │                │          │                        │                       │ https://avd.aquasec.com/nvd/cve-2022-0778                  │
├────────────────┼────────────────┼──────────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────┤
│ xz-libs        │ CVE-2022-1271  │ HIGH     │ 5.2.2-1.amzn2.0.2      │ 5.2.2-1.amzn2.0.3     │ gzip: arbitrary-file-write vulnerability                   │
│                │                │          │                        │                       │ https://avd.aquasec.com/nvd/cve-2022-1271                  │
├────────────────┼────────────────┼──────────┼────────────────────────┼───────────────────────┼────────────────────────────────────────────────────────────┤
│ zlib           │ CVE-2018-25032 │ HIGH     │ 1.2.7-18.amzn2         │ 1.2.7-19.amzn2.0.1    │ zlib: A flaw found in zlib when compressing (not           │
│                │                │          │                        │                       │ decompressing) certain inputs...                           │
│                │                │          │                        │                       │ https://avd.aquasec.com/nvd/cve-2018-25032                 │
└────────────────┴────────────────┴──────────┴────────────────────────┴───────────────────────┴────────────────────────────────────────────────────────────┘

usr/bin/aws-ebs-csi-driver (gobinary)

Total: 1 (HIGH: 1, CRITICAL: 0)

┌───────────────────┬────────────────┬──────────┬───────────────────┬──────────────────────────────────┬────────────────────────────────────────────────────────┐
│      Library      │ Vulnerability  │ Severity │ Installed Version │          Fixed Version           │                         Title                          │
├───────────────────┼────────────────┼──────────┼───────────────────┼──────────────────────────────────┼────────────────────────────────────────────────────────┤
│ k8s.io/kubernetes │ CVE-2021-25741 │ HIGH     │ v1.21.0           │ 1.19.15, 1.20.11, 1.21.5, 1.22.2 │ kubernetes: Symlink exchange can allow host filesystem │
│                   │                │          │                   │                                  │ access                                                 │
│                   │                │          │                   │                                  │ https://avd.aquasec.com/nvd/cve-2021-25741             │
└───────────────────┴────────────────┴──────────┴───────────────────┴──────────────────────────────────┴────────────────────────────────────────────────────────┘
```
