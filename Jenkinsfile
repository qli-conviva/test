pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                  containers:
                    - name: busybox
                      image: busybox
                      imagePullPolicy: Always
            '''
            workingDir '/home/jenkins/agent'
            namespace 'jenkins'
            podRetention always
        }
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'HOURS')
        retry(3)
    }
    environment {
        env = 'dev'
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
            when {
                branch 'main'
            }
            input {
                message "Should we continue?"
                ok "Yes, we should."
            }
            steps {
                container('ubuntu') {
                    sh 'sleep 10m'
                }
            }
        }
    }
    post {
        always {
            echo 'I will always say Hello again!'
        }
    }
}
