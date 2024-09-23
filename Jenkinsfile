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
                  withCredentials([file(credentialsId: "${KUBECONFIG_CREDENTIALS}", variable: 'KUBE_CONFIG_FILE')]) {
                        withEnv(["KUBECONFIG=$KUBE_CONFIG_FILE"])  {
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
