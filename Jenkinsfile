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
        stage('Checkout SCM') {
            steps {
                checkout scm
                sh "echo $CHEIF_AUTHOR"
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package'
                sh 'echo done'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                }
            }
        }
        stage('Login to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKERHUB_CREDENTIALS}") {
                        echo "Logged into Docker Hub"
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKERHUB_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push()
                    }
                }
            }
        }
        stage('List Files in Workspace') {
            steps {
                sh 'ls -la'  // List all files
                sh 'ls -la k8s-manifests'  // List files in the k8s-manifests directory
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([
                        file(credentialsId: 'ca.crt', variable: 'CA_CERT'),
                        file(credentialsId: 'client.crt', variable: 'CLIENT_CERT'),
                        file(credentialsId: 'client.key', variable: 'CLIENT_KEY'),
                        file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                    ]) {
                        // Make deploy.sh executable
                        sh 'chmod +x k8s-manifests/deploy.sh'  // Update path if needed

                        // Execute the deploy script
                        sh 'k8s-manifests/deploy.sh'  // Update path if needed
                    }
                }
            }
        }
        stage('Debug') {
            steps {
                script {
                    sh 'echo KUBECONFIG: $KUBECONFIG'
                    sh 'cat $KUBECONFIG'
                }
            }
        }
    }
    post {
        always {
            sh 'echo Completed'
        }
    }
}
