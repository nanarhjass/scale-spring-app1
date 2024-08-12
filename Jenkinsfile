pipeline {
    agent {label 'master'}
    tools{
        jdk 'jdk17'
        maven 'maven'
    }
    environment {
        CHEIF_AUTHOR = 'Asher'
        RETRY_CNT = 3
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
        stage('Code Scan') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh 'mvn  -Dsonar.projectKey=scale-spring-app1 -Dsonar.organization=nanarhjass org.sonarsource.scanner.maven:sonar-maven-plugin:3.7.0.1746:sonar'
                }
               
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
        
    }
    post {
       always {
           sh 'echo Completed'
       }
    }
}


