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
            // Use withCredentials to retrieve the kubeconfig file
            withCredentials([file(credentialsId: 'kubectl1', variable: 'KUBE_CONFIG')]) {
                // Move the kubeconfig file to the workspace
                sh "cp \$KUBE_CONFIG ${env.WORKSPACE}/kubeconfig.yaml"
                
                // Set the KUBECONFIG environment variable to the new location
                env.KUBECONFIG = "${env.WORKSPACE}/kubeconfig.yaml"
                
                // Debugging outputs
                sh "echo KUBECONFIG is set to: \$KUBECONFIG"
                sh "cat \$KUBECONFIG"  // Display contents of kubeconfig for verification

                // Check Kubernetes connectivity
                sh "kubectl get nodes --insecure-skip-tls-verify"
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
