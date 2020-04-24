def call(String name) {
    docker.withServer("${DOCKER_INT_ADDR}") {
        docker.withTool("docker-latest") {
            sh "docker rmi -f \$(docker images | grep " + name + " | sed 's/  */ /g' | cut -d' ' -f3 | sort -u)"
        }
    }
    cleanWs()
    chuckNorris()
}