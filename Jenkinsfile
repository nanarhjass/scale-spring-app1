pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven'
    }
    environment {
        CHEIF_AUTHOR = 'Asher'
        RETRY_CNT = 3
        DOCKERHUB_CREDENTIALS = 'dockerID'
        DOCKER_IMAGE = 'nanarh1/jenkinsproject'
        IMAGE_TAG = 'latest'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3')) 
        disableConcurrentBuilds()
        quietPeriod(5)
    }
    parameters {
        choice(name: 'TARGET_ENV', choices: ['UAT', 'SIT', 'STAGING'], description: 'Pick something')
    }

    stages {
        stage('Install kubectl') {
            steps {
                sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"'
                sh 'chmod +x ./kubectl'
            
            }
        }
        stage('Checkout SCM') {
            steps {
                checkout scm
                sh "echo $CHEIF_AUTHOR"
            }
        }
        // Other stages...

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([
                        file(credentialsId: 'ca.crt', variable: 'CA_CERT'),
                        file(credentialsId: 'client.crt', variable: 'CLIENT_CERT'),
                        file(credentialsId: 'client.key', variable: 'CLIENT_KEY')
                    ]) {
                        sh 'chmod +x k8s-manifests/deploy.sh'  // Update path if needed
                        sh 'k8s-manifests/deploy.sh'  // Update path if needed
                    }
                }
            }
        }
        // Other stages...
    }
    post {
        always {
            sh 'echo Completed'
        }
    }
}
