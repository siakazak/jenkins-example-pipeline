#!/bin/bash

# Assuming you have no clusters created on your current gcloud core/project

REF=$(gcloud container clusters list | grep -v NAME | cut -d' ' -f1)

# Get cluster credentials from GCP

gcloud container clusters get-credentials $REF --zone us-central1-a --project devops2020-kubernetes-271505

# Label nodes

kubectl label node --all node-role.kubernetes.io/worker=

kubectl create ns jenkins
kubectl create ns sonar
kubectl create ns nexus
kubectl create ns build
kubectl create ns hello

# Deploy jenkins

echo "Deployoing jenkins..."
kubectl apply -f scripts/jenkins.yml
kubectl apply -f scripts/ingress.yml
kubectl apply -f scripts/postgres.yml
kubectl apply -f scripts/sonar.yml
kubectl apply -f scripts/nexus.yaml
kubectl apply -f scripts/docker.yml
kubectl apply -f scripts/slaves.yml

