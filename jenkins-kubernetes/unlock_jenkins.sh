echo "Jenkins unlock password:"
kubectl -n jenkins exec -it $(kubectl get po -n jenkins | grep -v NAME | cut -d' ' -f1) cat /var/jenkins_home/secrets/initialAdminPassword
