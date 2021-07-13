pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                  containers:
                    - name: busybox
                      image: gcr.io/google-containers/busybox:latest
                      imagePullPolicy: IfNotPresent
                      command:
                        - sleep
                      args:
                        - 1d
            '''
            workingDir '/home/jenkins/agent'
            namespace 'jenkins'
            podRetention onFailure()
        }
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '30'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
        retry(3)
    }
    parameters {
        string(name: 'PRODUCT', description: 'Which product')
    }
    stages {
        stage('Build') {
            steps {
                container('busybox') {
                    sh 'echo $POD_CONTAINER ... 1'
                }
                container('busybox') {
                    sh 'echo $POD_CONTAINER ... 2'
                }
            }
        }
        stage('Deploy') {
            input {
                message "Should we continue?"
                ok "yes"
            }
            steps {
                container('busybox') {
                    sh 'sleep 10m'
                }
            }
        }
    }
}
