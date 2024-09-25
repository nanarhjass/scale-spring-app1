#!/bin/bash

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "Error: kubectl could not be found. Please install it and ensure it's in your PATH."
    exit 1
fi

# Optionally set the context if needed
# kubectl config use-context your-context-name

# Deploy the application
echo "Applying deployment manifest..."
kubectl apply -f ./k8s-manifests/deployment.yaml  --insecure-skip-tls-verify

# Check if the deployment was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply deployment.yaml"
    exit 1
fi

echo "Applying service manifest..."
kubectl apply -f ./k8s-manifests/service.yaml

# Check if the service was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply service.yaml"
    exit 1
fi

echo "Deployment completed successfully."
