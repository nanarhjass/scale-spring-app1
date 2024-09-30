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
        DOCKER_IMAGE = 'nanarh1/myapp'
        IMAGE_TAG = 'latest'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))
        disableConcurrentBuilds()
        quietPeriod(5)
    }
    parameters {
        choice(name: 'TARGET_ENV', choices: ['UAT', 'SIT', 'STAGING'], description: 'Pick environment')
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
                sh "echo ${CHEIF_AUTHOR}"
            }
        }

        stage('Build Maven Project') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubectl1', variable: 'KUBE_CONFIG')]) {
                        // Copy kubeconfig to a writable directory
                        sh "cp \$KUBE_CONFIG ${env.WORKSPACE}/kubeconfig.yaml"

                        
                        // Set the KUBECONFIG environment variable
                        env.KUBECONFIG = "${env.WORKSPACE}/kubeconfig.yaml"
                        
                        // Check Kubernetes connectivity with insecure flag
                        sh "kubectl get nodes --insecure-skip-tls-verify"
                        
                        // Make the deployment script executable and run it
                        sh "chmod +x ./k8s-manifests/deploy.sh"
                        sh "./k8s-manifests/deploy.sh --insecure-skip-tls-verify"
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'echo Pipeline Completed'
        }
    }
}
