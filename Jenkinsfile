@Library('skazak-library@skazak') _

branchName = 'skazak'
appName = 'helloworld-skazak'
tagName = "rc-${BUILD_NUMBER}"
imageName = "${NEXUS_INT_DOCKER_REGISTRY}/" + appName + ":" + tagName
testEnvHttp = 'http://helloworld.k8s.skazak.playpit.net'
prodEnvHttp = 'http://skazak-app.k8s.skazak.playpit.net'
checksPassed = false
failedSteps = "These steps failed:\n\n"
rollbackPerformed = ""

node() { 
    stage("Checkout SCM") {
        try {
            git branch: branchName, credentialsId: '64a5cc16-b6f8-4961-abd7-251f23c97fa4', url: 'https://github.com/MNT-Lab/pipeline-task'
            set_health(tagName, branchName, 'Siarhei Kazak') 
        } catch(Exception e) {
            currentBuild.result = 'UNSTABLE'
            failedSteps += "- Checkout SCM\n"
          }
    }
    
    stage("Build app"){
        try {
            def maven = tool name: 'Maven_363', type: 'maven'
            withEnv(["PATH+MAVEN=${maven}/bin"]) {
                sh 'mvn -f build-t00ls/helloworld-project/helloworld-ws/pom.xml clean install'
            }
        } catch(Exception e) {
            currentBuild.result = 'UNSTABLE'
            failedSteps += "- Build app\n"
          }
    }
    
    stage('SonarQube analysis') {
        def scannerHome = tool 'Scanner43';
        try {
            configFileProvider([configFile(fileId: 'e72a9ce4-64b1-4d6b-9d55-67a9be3aeb37', targetLocation: 'sonar-project.properties')]) {
                withSonarQubeEnv('mntlab_sonar') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
            wait_for_qg()
        } catch(Exception e) {
            currentBuild.result = 'UNSTABLE'
            failedSteps += "- SonarQube analysis\n"
          }
    }
    
    stage("Tests") {
        def maven = tool name: 'Maven_363', type: 'maven'
        withEnv(["PATH+MAVEN=${maven}/bin"]) {
            parallel(
                "pre-integration-test": {
                    echo "mvn pre-integration-test"
                },
                "integration-test": {
                    echo "mvn integration-test";
                },
                "post-integration-test": {
                    echo "mvn post-integration-test";
                }
            )
        }
    }

    stage("Trigger job and fetch artefact") {
        try {
            
            // trigger another job build
            
            build job: 'module-10-child1-build-job', parameters: [string(name: 'BRANCH_NAME', value: branchName)], quietPeriod: 1
            
            // archive output artifact
            
            copyArtifacts selector: lastSuccessful(), filter: "output.txt", projectName: "module-10-child1-build-job"
        } catch(Exception e) {
            currentBuild.result = 'UNSTABLE'
            failedSteps += "- Trigger job and fetch artefact\n"
          }
    }

    stage("Package and publish results") {
        
        parallel(
            "Archive artifact": {
                try {
                    sh 'tar -czf pipeline-skazak-${BUILD_NUMBER}.tar.gz Jenkinsfile output.txt build-t00ls/helloworld-project/helloworld-ws/target/helloworld-ws.war'
                            
                    nexus_upload('pipeline-skazak-${BUILD_NUMBER}.tar.gz', 'raw-hosted', 'pipeline-skazak', 'pipeline')
                    
                    archiveArtifacts artifacts: 'pipeline-skazak-${BUILD_NUMBER}.tar.gz', fingerprint: true

                } catch(Exception e) {
                    currentBuild.result = 'UNSTABLE'
                    failedSteps += "- Package and publish results: Archive artifact\n"
                  }
            },
            "Create Docker Image": {
                try {
                    docker_push(imageName, tagName, true)
                } catch(Exception e) {
                     currentBuild.result = 'UNSTABLE'
                     failedSteps += "- Package and publish results: Create Docker Image\n"
                  }
            }
        )
    }
    
    stage("Deploy to test env") {
        try {
            echo "Deploying to test env ${testEnvHttp}..."
            deploy('88bad7f8-f7f5-4c82-8b1a-869654a07827', 'hello', tagName)   
        } catch(Exception e) {
            currentBuild.result = 'UNSTABLE'
            failedSteps += "- Deploy to Kubernetes test env ${testEnvHttp}\n"
          }
    }
    
    stage("Perform test env sanity checks") {
        try {
            checksPassed = sanity_checks(testEnvHttp, tagName, 'Test')               
        } catch(Exception e) {
            echo 'failed for no reason'
            currentBuild.result = 'UNSTABLE'
            failedSteps += "- Perform Test Sanity checks\n"
          }
          
    }
    
    stage("Ask for manual approval") {
        input message: 'Deploy to Production?', ok: 'Sure!'
    }
    
    stage("Deploy to prod env") {
        try {
            if (checksPassed) {                
                echo "Deploying to prod env ${prodEnvHttp}..."
                deploy('ac4bea45-2215-4a50-87d9-e7826964df86', 'skazak', tagName)   
            }
            else {
                currentBuild.result = 'UNSTABLE'
                failedSteps += "- Deploy to Kubernetes prod env ${testProdHttp}\n"
            }
        } catch(Exception e) {
            currentBuild.result = 'UNSTABLE'
            failedSteps += "- Deploy to Kubernetes prod env ${testEnvHttp}\n"
          }
    }
    
    stage("Perform prod env sanity checks") {
        try {
            checksPassed = sanity_checks(prodEnvHttp, tagName, 'Prod')             
            if (checksPassed) {  
                docker_push(imageName, 'stable')
            }
                
        } catch(Exception e) {
            echo 'failed for no reason'
            currentBuild.result = 'UNSTABLE'
            failedSteps += "- Perform Prod Sanity checks\n"
          }
          
        
          
    }
    
    stage("Perform prod rollback") {
        if (! checksPassed) {
            try {
                echo "Rolling back prod env ${prodEnvHttp}..."
                deploy('ac4bea45-2215-4a50-87d9-e7826964df86', 'skazak', 'stable')
                  
                rollbackPerformed = '''WARNING!
Production build was unstable.
Rolled back to last stable version.'''

            } catch(Exception e) {
                currentBuild.result = 'UNSTABLE'
                failedSteps += "- Perform prod rollback ${testEnvHttp}\n"
              }
        }
    }
    
    stage("Cleanup") {
        try {
            cleanup(appName)
        } catch(Exception e) {
            currentBuild.result = 'UNSTABLE'
            failedSteps += "- Cleanup\n"
          }
    }
    
    stage("Send e-mails") {
        if ("${currentBuild.currentResult}" == 'SUCCESS') {
            failedSteps = "None of the steps failed.\n"
        }
        message = """BUILD № ${BUILD_NUMBER} went ${currentBuild.currentResult}!
${failedSteps}
${rollbackPerformed}

Check it out here: 
${BUILD_URL}
"""
        emailext attachLog: true, body: "${message}", subject: "Build ${BUILD_NUMBER} has just finished", to: 'siarhei_kazak@epam.com'
    }

}
