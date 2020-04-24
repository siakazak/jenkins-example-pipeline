#!/bin/env zsh

source /home/twiceaday/.zshrc
gcloud container clusters get-credentials prod --zone us-central1-a --project devops2020-kubernetes-271505
JENKINS_HOME="/var/jenkins_home"
JENKINS_POD=$(kubectl -n jenkins get po | grep -v NAME | grep -v slave | cut -d' ' -f1)
kubectl -n jenkins cp ~/.kube/config $JENKINS_POD:$JENKINS_HOME/kubeconfig
