#!/bin/bash
kubectl apply -f k8s-manifests/deployment.yaml --validate=false
kubectl apply -f k8s-manifests/service.yaml --validate=false
