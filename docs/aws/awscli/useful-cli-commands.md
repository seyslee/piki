# 유용한 AWS CLI 명령어 모음

## Security Group

### 전체 Security Group 이름과 ID 출력

```bash
aws ec2 describe-security-groups \
--query 'SecurityGroups[].[Tags[?Key==`Name`] | [0].Value, GroupId, Description]' \
--region ap-northeast-2
```

&nbsp;

## AWS Config

### 사용하지 않는 Security Group 확인

**전제조건**  
AWS Config에서 [ec2-security-group-attached-to-eni](https://docs.aws.amazon.com/config/latest/developerguide/ec2-security-group-attached-to-eni.html) 룰이 활성화되어 있어야 합니다.

```bash
aws configservice get-compliance-details-by-config-rule \
  --config-rule-name ec2-security-group-attached-to-eni \
  --compliance-types NON_COMPLIANT \
  --query 'EvaluationResults[*].EvaluationResultIdentifier.EvaluationResultQualifier.[ResourceType,ResourceId]'
```
