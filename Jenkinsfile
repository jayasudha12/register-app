pipeline {

    /* Run pipeline on your existing Jenkins agent */
    agent { label 'jenkins-Agent' }

    /* Tools configured in Manage Jenkins → Tools */
    tools {
        jdk 'java17'
        maven 'Maven3'
    }

    /* Environment variables */
    environment {
        APP_NAME    = "register-app"
        RELEASE     = "1.0.0"
        DOCKER_USER = "puvisha007"
        DOCKER_PASS = credentials("dockerhub-creds")
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
                sh 'mvn clean package'
            }
        }

        stage("Run Unit Tests") {
            steps {
                sh 'mvn test'
            }
        }

        stage("Docker Build & Push") {
            steps {
                sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    docker build -t $IMAGE_NAME:$IMAGE_TAG .
                    docker push $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build successful!"
            echo "Docker Image pushed: $IMAGE_NAME:$IMAGE_TAG"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
        always {
            cleanWs()
        }
    }
}
