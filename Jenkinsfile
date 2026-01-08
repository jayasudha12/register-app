pipeline {

    agent { label 'jenkins-Agent' }

    tools {
        jdk 'java17'
        maven 'Maven3'
    }

    environment {
        APP_NAME    = "register-app"
        RELEASE     = "1.0.0"
        DOCKER_USER = "puvisha007"
        IMAGE_NAME  = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG   = "${RELEASE}-${BUILD_NUMBER}"
    }

    stages {

        stage("Cleanup Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Checkout Source Code") {
            steps {
                git branch: 'main',
                    credentialsId: 'github',
                    url: 'https://github.com/jayasudha12/register-app.git'
            }
        }

        stage("Build Application") {
            steps {
                sh 'mvn clean verify'
            }
        }

        stage("SonarQube Analysis") {
            steps {
                    script {
                         withSonarQubeEnv(credentialsId:  'jenkins-sonarqube-token') {
                         sh "mvn sonar:sonar"
                         }
                   }
             }
        }

        stage("Quality Gate") {
            steps {
                script {
                       waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                 }
            }
        }

        stage("Docker Build & Push") {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker build -t $IMAGE_NAME:$IMAGE_TAG .
                        docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest
                        docker push $IMAGE_NAME:$IMAGE_TAG
                        docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build successful!"
            echo "🐳 Docker Image pushed:"
            echo "   $IMAGE_NAME:$IMAGE_TAG"
            echo "   $IMAGE_NAME:latest"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
        always {
            cleanWs()
        }
    }
}
