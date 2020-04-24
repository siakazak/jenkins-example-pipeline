def call() {
    script {
      Integer waitSeconds = 10
      Integer timeOutMinutes = 10
      Integer maxRetry = (timeOutMinutes * 60) / waitSeconds as Integer
      for (Integer i = 0; i < maxRetry; i++) {
        try {
          timeout(time: waitSeconds, unit: 'SECONDS') {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              error "Sonar quality gate status: ${qg.status}"
            } else {
              i = maxRetry
            }
          }
        } catch (Throwable e) {
          if (i == maxRetry - 1) {
            throw e
          }
        }
      }
    }
}