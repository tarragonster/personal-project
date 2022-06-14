# Route53

###Transfer domain to other aws account

```shell
1. Transfer domain:
aws --region us-east-1 route53domains transfer-domain-to-another-aws-account --domain-name "monsterra.io" --account-id "345163048667"
 
2. Cancel transfer domain:
aws --region us-east-1 route53domains cancel-domain-transfer-to-another-aws-account --domain-name "monsterra.io"
 
2. Accept domain:
aws route53domains accept-domain-transfer-from-another-aws-account --domain-name "monsterra.io" --password "O?%y9O`E7_&!mo"
```