# Ecs

## Problem 1:
#### Context:
- Case: services created in private subnet and would not allow outside cluster to access
#### Issue:
- How can services access other?
#### Why should you care?:
- Security for services in cluster
#### Solution:
- Use service discovery
- Requirement: DNS hostnames in your VPC that ecs cluster created, must be enabled

## Reference

[Blog] Ben Peven - [Deep dive into Fargate Spot to run your ECS Tasks for up to 70% less](https://aws.amazon.com/blogs/compute/deep-dive-into-fargate-spot-to-run-your-ecs-tasks-for-up-to-70-less/) \

##Problem 2:
#### Context:
- case: repository does not exist or may require 'docker login'
#### Solution:
```
docker logout public.ecr.aws
```
## Reference

[QA] Sathyajith Bhat - [How to pull AWS Lambda container image](https://stackoverflow.com/questions/65720417/how-to-pull-aws-lambda-container-image)