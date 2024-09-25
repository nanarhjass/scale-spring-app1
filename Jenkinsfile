pipeline {
    agent any
    tools {
        jdk 'jdk17'                   // Use JDK 17
        maven 'maven'                 // Use Maven
    }
    environment {
        CHEIF_AUTHOR = 'Asher'         // Environment variable for author
        RETRY_CNT = 3                  // Retry count variable
        DOCKERHUB_CREDENTIALS = 'dockerID'  // DockerHub credentials ID
        DOCKER_IMAGE = 'nanarh1/jenkinsproject'  // Docker image
        IMAGE_TAG = 'latest'           // Docker image tag
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '3'))   // Discard old builds to keep only 3
        disableConcurrentBuilds()                       // Prevent concurrent builds
        quietPeriod(5)                                  // Quiet period before starting a build
    }
    parameters {
        choice(name: 'TARGET_ENV', choices: ['UAT', 'SIT', 'STAGING'], description: 'Pick environment')  // Choice parameter for the target environment
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm                              // Checkout source control
                sh "echo ${CHEIF_AUTHOR}"                 // Echo the author name
            }
        }

        stage('Build Maven Project') {
            steps {
                sh 'mvn clean install'                    // Build project with Maven
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'mvn test'                             // Run tests with Maven
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}") // Build Docker image
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"  // Login to DockerHub
                        sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"                           // Push Docker image to registry
                    }
                }
            }
        }

        stage('Deploy to Kubernet


