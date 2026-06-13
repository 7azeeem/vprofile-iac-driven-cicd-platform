pipeline {
    agent any

    tools {
        jdk 'JDK17'
        maven 'maven'
    }
    environment {
        regstry = 'ecr:us-east-1:awsIAM'
        imagename = "552267529856.dkr.ecr.us-east-1.amazonaws.com/projectapp"
        projectRegistry = "https://552267529856.dkr.ecr.us-east-1.amazonaws.com"
    }
    stages {

        stage('Fetch code') {
            steps {
                git branch: 'docker', url: 'https://github.com/hkhcoder/vprofile-project.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage('Unit Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Checkstyle Analysis') {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage('CODE ANALYSIS with SONARQUBE') {

            environment {
                scannerHome = tool 'sonarscanner'
            }

            steps {
                withSonarQubeEnv('sonar-pro') {
                    sh """
                    ${scannerHome}/bin/sonar-scanner \
                    -Dsonar.projectKey=project \
                    -Dsonar.projectName=project-repo \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/test-classes \
                    -Dsonar.junit.reportsPath=target/surefire-reports \
                    -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build app image') {
            steps {
                script {
                    dockerimage = docker.build( imagename + ":$BUILD_NUMBER" , "./Docker-files/app/multistage/") 
            }
        }
    }

    stage('Push to ECR') {
        steps {
            script {
                docker.withRegistry(projectRegistry, regstry) {
                    dockerimage.push("$BUILD_NUMBER")
                    dockerimage.push("latest")
                }
            }
        }
    }

    post {
        success {
            slackSend(
                channel: '#devopsci_cd',
                color: 'good',
                message: """✅ PIPELINE SUCCESS
All stages passed successfully 🎉
Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
${env.BUILD_URL}
"""
            )
        }

        failure {
            slackSend(
                channel: '#devopsci_cd',
                color: 'danger',
                message: """❌ PIPELINE FAILED
Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
${env.BUILD_URL}
"""
            )
        }

        aborted {
            slackSend(
                channel: '#devopsci_cd',
                color: 'danger',
                message: """❌ PIPELINE FAILED
FAILED AT QUALITY GATE ⛔
Job: ${env.JOB_NAME}
Build: #${env.BUILD_NUMBER}
${env.BUILD_URL}
"""
            )
        }
    }
}