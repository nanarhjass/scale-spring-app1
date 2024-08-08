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
    }
}
