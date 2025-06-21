
# SP Public Safety Climate Project - Local Infrastructure Setup

## Goal so far:
Set up a local Kubernetes development environment using Minikube and Docker as the driver. Create organized namespaces based on data layers (infra, bronze, silver, gold) and deploy basic services: **Nginx** and **PostgreSQL**.

## Prerequisites:
- Windows 10 with Docker Desktop installed and running
- Minikube installed
- Helm installed (v3 or newer)
- kubectl configured and working

## Step-by-step executed so far:

### 1. Start Minikube using Docker driver:

```
minikube start --driver=docker
```

### 2. Create the namespaces:

```
kubectl create namespace infra
kubectl create namespace bronze
kubectl create namespace silver
kubectl create namespace gold
```

### 3. Deploy Nginx (inside the `infra` namespace):

**File:** `infra/manifests/nginx-deploy.yaml`

Apply the manifest:

```
kubectl apply -f infra/manifests/nginx-deploy.yaml
```

### 4. Test Nginx access via Port-forward:

```
kubectl port-forward svc/nginx-service 8080:80 -n infra
```

Open in the browser:

```
http://localhost:8080
```

### 5. Deploy PostgreSQL via Helm:

**Add Bitnami repository:**

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

**Install PostgreSQL with Helm:**

```
helm install postgresql bitnami/postgresql --namespace infra -f infra/helm/postgresql/values.yaml
```

### 6. Test PostgreSQL access via Port-forward:

```
kubectl port-forward svc/postgresql 5432:5432 -n infra
```

Then connect using PGAdmin, DBeaver, or terminal:

```
Host: localhost
Port: 5432
Database: projeto_sp
User: adminuser
Password: adminpassword
```
## MinIO deployment

MinIO was deployed using Helm with a custom `values.yaml` file.  
Port-forwarding is required to access both the S3 API and the MinIO Web Console.

### Port-forward for API (required for Terraform):

```
kubectl port-forward svc/meu-minio 9000:9000 -n infra
```

### Port-forward for Web Console:

```
kubectl port-forward pod/<minio-console-pod-name> 9090:9090 -n infra
```

### Accessing the console:

```
http://localhost:9090
```

### Default credentials:

```
- Username: minioadmin
- Password: minioadmin123
```

S3 buckets for the bronze, silver, and gold layers are being managed and created through Terraform.  
Keep the port-forward for the API running when applying Terraform plans that interact with MinIO.

## Terraform Infrastructure Management

Infrastructure management for both Kubernetes resources and MinIO buckets is handled with Terraform.

Directory structure:

```
infra/
└── terraform/
    ├── providers.tf
    ├── backend.tf
    ├── minio_buckets.tf
    ├── k8s_namespaces.tf
    └── variables.tf
```

Providers used:

- Kubernetes Provider
- Helm Provider
- AWS Provider (configured to point to the local MinIO instance using the S3-compatible API)


Managed resources:

- Kubernetes namespaces (optional, currently created manually)
- S3 buckets on MinIO for bronze, silver, and gold layers

**Important:**
The port-forwarding for the MinIO API (port 9000) must be active while applying Terraform plans that create or manage S3 buckets.

Terraform commands:

```
terraform init
terraform plan
terraform apply
```

## Current project status:

| Item               | Status                                                        |
|--------------------|---------------------------------------------------------------|
| Minikube           |  Running                                                    |
| Docker             |  Running                                                    |
| Namespaces         |  Created                                                    |
| Nginx              |  Deployed and accessible                                    |
| PostgreSQL         |  Deployed via Helm with custom values.yaml                  |
| MinIO              |  Deployed via Helm with web console accessible on port 9090 |
| Terraform	         |  Initialized and managing MinIO buckets                     |
| MinIO Buckets (S3) |  Managed via Terraform (bronze, silver, gold)               |
| Port-forwarding    |  Required for PostgreSQL and MinIO API/Console              |
