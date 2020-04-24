def call(String filename, String repo, String art_id, String gid, String version='${BUILD_NUMBER}') {
    nexusArtifactUploader artifacts: [[artifactId: art_id, classifier: '', file: filename, type: 'tar.gz']], credentialsId: '297c5fc3-5a11-4ff0-9d91-4ea5fbda68b8', groupId: gid, nexusUrl: '$NEXUS_INT_ADDR', nexusVersion: 'nexus3', protocol: 'http', repository: repo, version: version
}