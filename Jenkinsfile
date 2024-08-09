pipeline {
    agent any
    tools {
        jdk 'jdk17a'
        maven 'maven'
    }
    environment {
        CHIEF_AUTHOR = 'Asher'
        RETRY_CNT = 3
    }
    parameters {
        choice(name: 'CHOICES', choices: ['one', 'two', 'three'], description: '')
    }
    triggers {
        cron('H */4 * * 1-5')
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Scan') {
            steps {
                script {
                     def ScannerHome = tool name: 'sonar', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                     withSonarQubeEnv('sonar') {
                     sh "${ScannerHome} -Dsonar.projectKey=nanarhjass_scale-spring-app1 -Dsonar.organization=nanarhjass -Dsonar.sources=. -Dsonar.host.url=https://sonarcloud.io -Dsonar.login=1e8588b846b0881847653620fa5e350970723bbf"}
                }
            }
        }
    }
}

