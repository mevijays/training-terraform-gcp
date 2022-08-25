# GKE Terraform   
Need to enable following APIs in the project

1. Cloud DNS api
2. kubernetes api
3. compute engine api

## workload identity with GKE and service account  
workload identity is being used for containers running within gke to connect and authenticate against gcp services like GCS and cloud sql etc.  
**1) Pre-requisites**

Workload identity can be enabled on a new or an existing cluster.

Enable workload identity on a new cluster
``` 
gcloud container clusters create CLUSTER_NAME \
  --workload-pool=PROJECT_ID.svc.id.goog 
``` 
We can also enable this option in GCP console or with terraform.   
**2) Create the Google Service Account and Kubernetes Service account**

After we create the GSA with required IAM access, we can use a new manifest file to create the kubernetes service account (KSA).

In the annotation, we are specifying the GSA to be acted upon by the KSA.
```
# serviceAccount.yamlapiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    iam.gke.io/gcp-service-account: $GSA-NAME@PROJECT-ID.iam.gserviceaccount.com
  name: $APPNAME
  namespace: $NAMESPACE
```
Update our deployment.yaml container spec with the KSA information. This tells the pod to use the KSA.
```
# deployment.yamlspec:
      containers:
      - name: $NAME
        image: $IMAGE
        serviceAccountName: $KSA-NAME
```
**3) Create KSA — GSA Binding**

Create a IAM policy binding which grants KSA ‘iam.workloadIdentityUser’ role to the GSA.

```
gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:PROJECT-ID.svc.id.goog[$NAMESPACE/$KSA-NAME]" \
  $GSA-NAME@PROJECT-ID.iam.gserviceaccount.com

```
Please ensure that the GSA has required IAM permissions to the resources accessed by our application.

**4) Deploy the application**

Once the binding is done, we can deploy the application in GKE.

Although we can use a KSA for multiple applications, it’s better to maintain a separate KSA-GSA for each application (that requires GCP access) for identification and access control.