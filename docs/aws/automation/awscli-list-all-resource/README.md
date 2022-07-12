# awscli-list-all-resource

각각의 AWS 리소스별 AWS CLI로 전체 리소스 조회하고 결과를 `.tsv` 파일로 출력하는 가이드 문서입니다.

&nbsp;

## 전제조건

AWS CLI가 설치되어 있어야 합니다.

&nbsp;

## 본문

### EC2

```bash
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[Tags[?Key=='Name']|[0].Value,InstanceId,LaunchTime,State.Name,InstanceType,Placement.AvailabilityZone,PublicIpAddress,PlatformDetails,VpcId,SubnetId]' \
  --output text | paste -d "\t" - > resources-ec2.tsv
```

### AMI

```bash
aws ec2 describe-images \
  --query 'Images[*].[Name,ImageId,CreationDate,ImageLocation,OwnerId,Description,PlatformDetails]' \
  --owners self \
  --output text | paste -d "\t" - > resources-ami.tsv
```

### EBS Volume

```bash
aws ec2 describe-volumes \
  --query "Volumes[*].[Tags[?Key=='Name']|[0].Value,VolumeId,CreateTime,State,Size,Iops,VolumeType]" \
  --output text | paste -d "\t" - > resources-ebs.tsv
```

### EBS Snapshot

```bash
aws ec2 describe-snapshots \
  --owner-ids self \
  --query "Snapshots[*].[Tags[?Key=='Name'] | [0].Value,SnapshotId,StartTime,State,VolumeId,VolumeSize] | sort_by(@, &[2])" \
  --output text | paste -d "\t" - > resources-snapshot.tsv
```

`sort_by(@, &[2])` : Start Time 기준으로 생성이 오래된 스냅샷부터 출력합니다.

### Elastic IP

```bash
aws ec2 describe-addresses \
  --query "Addresses[*].[Tags[?Key=='Name']|[0].Value,InstanceId,PublicIp,AllocationId,AssociationId,Domain,NetworkInterfaceId,NetworkInterfaceOwnerId,PrivateIpAddress]" \
  --output text | paste -d "\t" - > resources-eip.tsv
```

### ENI

```bash
aws ec2 describe-network-interfaces \
  --query "NetworkInterfaces[*].[NetworkInterfaceId,Description,Status,PrivateDnsName,PrivateIpAddress]" \
  --output text | paste -d "\t" - > resources-eni.tsv
```

### ELB(Application, Network, Gateway)

```bash
aws elbv2 describe-load-balancers \
  --query "LoadBalancers[*].[LoadBalancerName,DNSName,CreatedTime,Scheme,VpcId,State.Code,Type]" \
  --output text | paste -d "\t" - > resources-elb.tsv
```

### ELB(Classic)

Classic Load Balancer는 명령어가 다릅니다.  
`aws elb`와 `aws elbv2`가 있다는 점을 주의합니다.

```bash
aws elb describe-load-balancers \
  --query "LoadBalancerDescriptions[*].[LoadBalancerName,DNSName,CreatedTime,Scheme,VPCId]" \
  --output text | paste -d "\t" - > resources-elb.tsv
```

### Target Group

```bash
aws elbv2 describe-target-groups \
  --query "TargetGroups[*].[TargetGroupName,TargetGroupArn,VpcId,LoadBalancerArns[0]]" \
  --output text | paste -d "\t" - > resources-tg.tsv
```

### AutoScaling Group

```bash
aws autoscaling describe-auto-scaling-groups \
  --query "AutoScalingGroups[*].[Tags[*]|[0].Value,AutoScalingGroupName,MinSize,MaxSize,DesiredCapacity,TargetGroupARNs[0],CreatedTime]" \
  --output text | paste -d "\t" - > resources-asg.tsv
```

### Autoscaling Launch configurations

```bash
aws autoscaling describe-launch-configurations \
  --query "LaunchConfigurations[*].[LaunchConfigurationName,ImageId,InstanceType,CreatedTime]" \
  --output text | paste -d "\t" - > resources-alc.tsv
```

### S3 Name, Last Modified

```bash
aws s3api list-buckets \
  --query "Buckets[*].[Name,CreationDate]" \
  --output text | paste -d "\t" - > resources.tsv
```

### S3 Lifecycle

```bash
aws s3api get-bucket-lifecycle-configuration --bucket {bucket name} \
  --output text | paste -d "\t" - > resources.tsv
```

### RDS

```bash
aws rds describe-db-instances \
  --query "DBInstances[*].[DBInstanceIdentifier,TagList[?Key=='Name']|[0].Value,DBInstanceClass,Engine,DBInstanceStatus,MasterUsername,DBName,AllocatedStorage,InstanceCreateTime,LatestRestorableTime,MultiAZ,EngineVersion,AutoMinorVersionUpgrade]" \
  --output text | paste -d "\t" - > resources-rds.tsv
```

### CloudFront

```bash
aws cloudfront list-distributions \
  --query "DistributionList.Items[*].[Id,Status,LastModifiedTime,DomainName,Aliases.Items[0],Origins.Items|[0].DomainName]" \
  --output text | paste -d "\t" - > resources-cf.tsv
```

### Lambda

```bash
aws lambda list-functions \
  --query "Functions[*].[FunctionName,FunctionArn,Runtime,Role,CodeSize,Description,MemorySize,LastModified]" \
  --output text | paste -d "\t" - > resources-lambda.tsv
```

### Transfer Family

```bash
aws transfer list-servers \
  --query "Servers[*].[Domain,EndpointType,ServerId,State]" \
  --output text | paste -d "\t" - > resources.tsv
```

### Beanstalk

```bash
aws elasticbeanstalk describe-applications \
  --query "Applications[*].[ApplicationName,Description,DateCreated,DateUpdated,ApplicationArn]" \
  --output text | paste -d "\t" - > resources-eb.tsv
```

### elasticache redis

```bash
aws elasticache describe-cache-clusters \
  --query "CacheClusters[*].[ReplicationGroupId,CacheClusterCreateTime,CacheClusterId,CacheNodeType,Engine,CacheClusterStatus]" \
  --output text | paste -d "\t" - > resources.tsv
```

### elasticache reserved node

```bash
aws elasticache describe-reserved-cache-nodes \
  --query "ReservedCacheNodes[*].[ReservedCacheNodeId,StartTime,ProductDescription]" \
  --output text | paste -d "\t" - > resources.tsv
```

### elasticache snapshot

```bash
aws elasticache describe-snapshots \
  --query "Snapshots[*].[SnapshotName,CacheClusterCreateTime,CacheClusterId,SnapshotStatus,CacheNodeType,Engine,EngineVersion]" \
  --output text | paste -d "\t" - > resources.tsv
```

### ACM

```bash
aws acm list-certificates \
  --query "CertificateSummaryList[*].[DomainName,CertificateArn]" \
  --output text | paste -d "\t" - > resources-acm.tsv
```

### Route53

```bash
aws route53 list-hosted-zones \
  --query "HostedZones[*].[Name,Id,Config.Comment,Config.PrivateZone,ResourceRecordSetCount]" \
  --output text | paste -d "\t" - > resources-r53.tsv
```
