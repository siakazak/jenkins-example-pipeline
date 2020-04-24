def call(String url, String version, String label) {
    checkRcPassed = false
    checkVersionPassed = false
    wait_until_ready(url)
    parallel(
        "Main page response code": {
            rc = get_http_rc(url)
            if (rc == 200) {
                echo "ok"
                checkRcPassed = true
            }
            else {
                checkRcPassed = false
                echo "failed with rc=" + rc
                failedSteps += "- Perform " + label + " Sanity checks\n"
                currentBuild.result = 'UNSTABLE'
            }
        },
        
        "Health page info": {
            content = get_content(url + "/health")                   
            if (content.contains(version)) {
                echo "ok"
                checkVersionPassed = true
            }
            else {
                checkVersionPassed = false
                echo "failed with wrong version"
                failedSteps += "- Perform " + label + " Sanity checks\n"
                currentBuild.result = 'UNSTABLE'
            }
        }
    )
    
    if (checkVersionPassed && checkRcPassed) {
        return true
    }
    return false
}