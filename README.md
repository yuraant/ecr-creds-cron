# ecr-creds-cron
#### Description
The service provides credentials to use images from private ECR. It useful for local development in local Kubernetes cluster.
Also can be use for clustes that based on not AWS infrastructure and you do not have an option to provide access to ECR by 
IAM Role for workers.  

ECR provides token only for 12 hours. We need to have a CronJob to renew token before it expired. 

The service consists of Job, CronJob, Secrets, ServiceAccount.
* **Job** runs ones at first deployment. It allows to set credentials immediately after deployment
* **CronJob** runs every 8 hours to renew credentials 
* **ServiceAccount** uses for providing credentials as default for namespace. So you do not need to specify imagePullSecrets
for your containers.
* **Secrets** consists AWS credentials and  AWS account details to get Docker login secret

Job and CronJob use image that build from [Dockerfile](Dockerfile) . This image has AWS CLI to run command `aws ecr get-login` and kubectl 
to run commands `kubectl create/delete secret` or `kubectl patch serviceaccount`.

#### How to use
Clone this repo first.

We need to put AWS credentials and AWS account id in them in `templates/secrets.yaml`. All values should be encrypted by 
based64.

Example value for aws region:
```bash
user# echo -n 'eu-west-1' | base64

ZXUtd2VzdC0x

user#
```

 When all fields (AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_ACCOUNT) are filled, you can deploy this service 
 to your k8s cluster.
```bash
user# kubectl apply -f ecr-creds-cron/templates

cronjob.batch/ecr-cred-updater created
job.batch/ecr-cred-updater created
role.rbac.authorization.k8s.io/ecr-cred-updater created
rolebinding.rbac.authorization.k8s.io/ecr-cred-updater created
secret/ecr-cred-updater created
serviceaccount/ecr-cred-updater created

user#
```