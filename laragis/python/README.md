# 🐍 Python Base Container  

## 🚀 Overview  
This repository provides a minimal Python base container setup using Docker. It includes Poetry for dependency management and is structured to be lightweight and easily extendable.  

## 🌟 Features  
- 🏗 Based on `python:3.11-slim`  
- 📦 Uses Poetry for package management (`v2.1.1`)  
- ⚙️ Configurable via `.env` file  
- 🐳 Includes `docker-compose.yaml` for easy container management  

## 🛠 Getting Started  

### 1️⃣ Setup Environment  
Copy the example environment file and modify it if needed:  
```sh
cp .env.example .env
```  

### 2️⃣ Build the Docker Image  
```sh
make build
```  

### 3️⃣ Run the Container  
```sh
make up
```  

## ⚙️ Configuration  

The `.env` file contains configurable settings:  
```ini
ORG_NAME=ttungbmt
APP_SLUG=python
APP_NAME=python
APP_VERSION=0.1.0
BASE_IMAGE=python:3.11-slim
TZ=Asia/Ho_Chi_Minh
POETRY_VERSION=2.1.1
```  

## 🛠 Development  

### 🖥 Running Inside the Container  
```sh
make shell
```  

Or 

```sh
make shell-root
```

### ❌ Stopping and Removing Containers  
```sh
make down
```