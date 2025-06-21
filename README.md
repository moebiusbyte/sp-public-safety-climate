
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

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  namespace: infra
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: infra
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
```

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

**Create custom values file:**

**Path:** `infra/helm/postgresql/values.yaml`

**Current content:**

```
global:
  postgresql:
    auth:
      postgresPassword: "senha123"
      username: "adminuser"
      password: "adminpassword"
      database: "projeto_sp"

primary:
  service:
    ports:
      postgresql: 5432

  persistence:
    enabled: false

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

volumePermissions:
  enabled: true

metrics:
  enabled: false
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

## Current project status:

| Item        | Status   |
|-------------|----------|
| Minikube    | ✅ Running |
| Namespaces  | ✅ Created |
| Nginx       | ✅ Deployed and tested |
| PostgreSQL  | ✅ Deployed via Helm with custom values.yaml |
