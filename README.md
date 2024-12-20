# service-deploy

An extendable multi-technology abstraction for deploying services and their related infrastructure

### Guiding Principles

- Developer self-service
- Garbage in, garbage out
- Separation of concerns
- Service-layer infrastructure
- Declarative IaC
- Least privileged

### Consumers

Some progyny and third-party services/tools may be too complicated for this pattern. We will offer an escape hatch using non self-service patterns. Squads must use `service-deploy` to get the convience and speed.

- New progyny services/tools
- Third-party services/tools

### Developer self-service

Allow squads to easily create and operate infrastructure using gitops. Terraform modules will be immutable and owned and maintained by etdo and infosec. This improves separation of concerns.

### Garbage in, garbage out

We want to keep the contents of this aws account as managed as possible. This is important for compliance and expense. We also want to enable squads to move quickly and to operate their software.

### Service-layer infrastructure

Infrastructure used directly by a service. e.g. `rds_clusters`, `s3_buckets`, `sqs_queues`, `dynamodb_tables`, `efs_volumes`, etc

### Extendable

- Pattern for adding declarative service level infrastructure using terraform modules and tfvars
- Pattern for adding helm charts and `*values.yaml` files

### service-iac

- Declarative terraform that allows service squad to easily provision and operate opinionated IAC
- Curated patterns allow infosec and devops to sleep at night
- Least privileged service `security_group`
- Extendable

### service-iam

- Terraform that creates opinionated service iam roles based on least privileged
- Curated patterns allow infosec and devops to sleep at night
- Least privileged service `iam`
- Extendable

### metadata

- Terraform that retreives and injects `aws_ssm_params` and `aws_secrets` into `*values.yaml` files

### helm

- Values are declared and looked up
- Common set of helm charts for progyny services: `http_service`, `deamon_service`, `db_migration`, etc
- Extendable to allow for third party charts

#### Notes

- Maintained by etdo
- Build pipeline: tests and creates a versioned tar archive and pushes it to a bucket
- Service pipelines pull the versioned archive and use tfvars and yaml files from the service repo
- Allows for env based overrides and env opt-out or escape hatch
- All modules write ssm params for deployments to pickup: terraform gen_helm_values > `generated_helm_values.yaml`

## Next steps

- Complete PoC
  - add config and secret support
  - add gen_helm_values
  - add more infra types: `s3_buckets`, `sqs_queues`, `dynamodb_tables`, etc
- Complete iam-roles
- Add GitHub runners
- Create GitHub actions/workflow patterns
- Wire up dagster with full automation
- Socialize with DevEx
- Create starter service
- Document and socialize

## Some Questions

- Do we need to allow other services to connect to RDS clusters? dagster?

## Local Usage

The helper scripts can be run locally and by pipeline. The scripts assume iam roles and set dynamic backends.

**terraform**

- generate_helm_values

```
$ ./generate_helm_values.sh
```

- plan

```
$ ./iac.sh {service_iac|service_iam} plan
```

- auto apply

```
./iac.sh {service_iac|service_iam} apply
```

**helm**

- deploy

```
$ ./helm.sh
```

## Service Pipelines

Pipelines will be versioned and sourced from an `etdo` managed repo and run on a bank of pre-provisioned dumb runners. Pipelines will use oidc to get AWS credentials. Will make use of gated approvals for apply and deploys to highers.

#### service-compile-test.yaml

- compile src
- run unit tests for compiled service

#### docker-build-push.yaml

- build docker image
- push docker image to central location for promotion across envs

#### service-iam.yaml

- creates curated and scoped service IAM role using terraform
- values come from `service.tfvars` and `{env}-iac.tfvars`

#### service-iac.yaml

- creates service infra using declaritive terraform
- values come from `service.tfvars` and `{env}-iac.tfvars`

#### helm-deployment.yaml

- creates `generated_helm_values.yaml` using declaritive terraform with values from `service.tfvars` and `{env}-iac.tfvars`. reads values from ssm params
- deploys service to specified eks-cluster
- values come from `helm_values.yaml` and `generated_helm_values.yaml`
