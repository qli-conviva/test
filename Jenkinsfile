pipeline {
    agent {
        kubernetes {
            yaml: '''
                kind: Pod
                spec:
                containers:
                  - name: ubuntu
                    image: ubuntu:20.04
                    imagePullPolicy: Always
    '''
            podRetention: always()
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
            container('ubuntu') {
                sh 'sleep 10m'
            }
        }
        stage('Deploy') {
            when {
                branch 'master'
            }
            input {
                message "Should we continue?"
                ok "Yes, we should."
                parameters {
                    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                }
            }
            container('ubuntu') {
                sh 'sleep 10m'
            }
        }
    }
    post {
        always {
            echo 'I will always say Hello again!'
        }
    }
}
