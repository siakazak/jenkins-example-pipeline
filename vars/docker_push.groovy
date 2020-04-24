def call(String name, String tag, Boolean build=false) {
    docker.withServer("${DOCKER_INT_ADDR}") {
	    docker.withTool("docker-latest") {
	        docker.withRegistry("http://${NEXUS_INT_DOCKER_REGISTRY}", "297c5fc3-5a11-4ff0-9d91-4ea5fbda68b8") {
	        	if (build) {
	        		dockImage = docker.build(name, "./build-t00ls")
	        	}
	        	else {
	        		dockImage = docker.image(name)
	        	}
	            dockImage.push(tag)
	        }
	    }
	}
}