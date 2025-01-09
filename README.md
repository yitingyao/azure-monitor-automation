# Azure Cloud Monitoring & Alerting Automation

## Overview
This project automates the deployment of an Azure cloud monitoring system using **Terraform** and **GitHub Actions CI/CD pipelines**. It provisions essential Azure resources, including a Virtual Machine, Log Analytics Workspace, and CPU Usage Alerts, enabling real-time monitoring, alerting, and streamlined infrastructure management.

---

## Technical Features
- **Infrastructure as Code (IaC):** Automates resource provisioning with Terraform scripts.
- **Azure Monitoring & Log Analytics:** Centralized workspace to collect and analyze resource performance metrics.
- **CI/CD Integration:** Automates deployment, validation, and updates through GitHub Actions pipelines.
- **High Availability:** Resources are monitored for performance and uptime.
- **Scalable & Modular Design:** Easily extendable to include more Azure resources or services.

---

## Resources Created
- **Resource Group:** Organizes all related Azure resources.
- **Log Analytics Workspace:** Collects and centralizes monitoring data.
- **Virtual Machine:** Simulates workload for monitoring.
- **High CPU Usage Alert:** Triggers alerts when CPU usage exceeds the defined threshold.

---

## Prerequisites
- **Azure CLI:** Ensure it’s installed and authenticated (`az login`).
- **Terraform:** Ensure it's installed and verify installation with `terraform -v`.
- **GitHub Repository:** Set up for CI/CD integration.

---

## Steps to Run

### ✅ **1. Clone the Repository**
```powershell
git clone <repository-url>
cd azure-monitor-automation
```
Replace `<repository-url>` with your GitHub repository URL.

### ✅ **2. Authenticate Azure CLI & Set Subscription**
```powershell
az login
az account set --subscription <subscription-id>
```
Replace `<subscription-id>` with your Azure Subscription ID.

### ✅ **3. Initialize Terraform**
Initialize Terraform to download the necessary providers and set up the backend:
```powershell
terraform init
```

### ✅ **4. Plan Infrastructure**
Preview the infrastructure changes:
```powershell
terraform plan
```

### ✅ **5. Deploy Infrastructure**
Deploy resources on Azure:
```powershell
terraform apply -auto-approve
```

### ✅ **6. Verify Outputs**
After deployment, Terraform will show output variables:
```powershell
terraform output
```
Outputs include:
- Log Analytics Workspace Name
- Resource Group Name
- Virtual Machine Name

---

## 🔄 **CI/CD Pipeline (GitHub Actions)**
- **Pipeline File:** `.github/workflows/main.yml`
- **How It Works:**
  1. Push changes to the `main` branch:
     ```powershell
     git add .
     git commit -m "Updated Terraform infrastructure"
     git push origin main
     ```
  2. **GitHub Actions Pipeline** triggers automatically:
     - Checks for changes in `.tf` files before triggering the pipeline.
     - Validates Terraform code.
     - Plans infrastructure changes.
     - Applies changes to Azure resources.
  3. Monitor pipeline runs in **GitHub Repository > Actions**.

**What it does:** Automates infrastructure deployment using Terraform, ensuring consistent and reliable configurations with every code update.

---

## 📊 **Azure Log Analytics**
- **Resource:** Configured in `main.tf`
- **Purpose:** Collects and analyzes performance metrics from deployed resources.
- **How It Works:**
  - Data from the virtual machine is sent to the Log Analytics Workspace.
  - Performance metrics such as CPU usage are logged.
  - Alerts (e.g., high CPU usage) are triggered based on predefined conditions.

---

## 🛡️ **Destroy Resources (When Done)**
To prevent unwanted Azure charges, clean up the resources:
```powershell
terraform destroy -auto-approve
```
If Terraform fails to destroy the resource group due to lingering resources, manually delete it:
```powershell
az group delete --name monitoring-rg --yes --no-wait
```

---

## 📊 **Manual Monitoring with Azure CLI**
To manually monitor **CPU metrics** for the VM:
```powershell
az monitor metrics list --resource /subscriptions/<subscription-id>/resourceGroups/monitoring-rg/providers/Microsoft.Compute/virtualMachines/test-vm --metric "Percentage CPU" --output table
```
- Replace `<subscription-id>` with your **Azure Subscription ID**.
- Output will display **average CPU usage** in a table format.

---

This project demonstrates a streamlined, automated Azure infrastructure setup with robust monitoring and CI/CD integration, offering a solid foundation for scalable and manageable cloud deployments.

