def call(String yaml_id, String ns, String tag) {
    configFileProvider([configFile(fileId: yaml_id, targetLocation: 'hello.yml')]) {
        withEnv(["IMAGE_VERSION=${tag}"]) {
            kubernetesDeploy configs: '*.yml', dockerCredentials: [[credentialsId: '297c5fc3-5a11-4ff0-9d91-4ea5fbda68b8', url: 'http://10.39.244.82:8082']], kubeConfig: [path: ''], kubeconfigId: '164d6e31-594a-4a25-bd51-fb95a803bd49', secretName: 'nx-jenkins-secret', secretNamespace: ns, ssh: [sshCredentialsId: '*', sshServer: ''], textCredentials: [certificateAuthorityData: '', clientCertificateData: '', clientKeyData: '', serverUrl: 'https://']
        }        
    } 
}