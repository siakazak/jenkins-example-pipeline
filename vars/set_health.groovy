def call(String tag, String branch, String student) {
    sh "mkdir -p build-t00ls/helloworld-project/helloworld-ws/src/main/webapp/health && echo VERSION ${tag} > build-t00ls/helloworld-project/helloworld-ws/src/main/webapp/health/index.html"
    sh "echo BRANCH ${branch} >> build-t00ls/helloworld-project/helloworld-ws/src/main/webapp/health/index.html"
    sh "echo STUDENT ${student} >> build-t00ls/helloworld-project/helloworld-ws/src/main/webapp/health/index.html"
    sh "echo DEPLOYED \$(date +'%m-%d-%y %H:%M:%S') >> build-t00ls/helloworld-project/helloworld-ws/src/main/webapp/health/index.html"
}