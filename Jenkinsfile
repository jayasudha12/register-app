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
        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
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
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false,
                        credentialsId: 'jenkins-sonarqube-token'
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

        stage("Trivy Scan") {
            steps {
                script {
                    sh """
                        docker run --rm \
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        aquasec/trivy image ${IMAGE_NAME}:latest \
                        --no-progress \
                        --scanners vuln \
                        --exit-code 0 \
                        --severity HIGH,CRITICAL \
                        --format table
                    """
                }
            }
        }

        stage("Cleanup Artifacts") {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
                    sh "docker rmi ${IMAGE_NAME}:latest || true"
                }
            }
        }

        stage("Trigger CD Pipeline") {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'jenkins-api-token', variable: 'JENKINS_API_TOKEN')
                    ]) {
                        sh """
                            curl -v -k \
                            --user clouduser:${JENKINS_API_TOKEN} \
                            -X POST \
                            -H 'cache-control: no-cache' \
                            -H 'content-type: application/x-www-form-urlencoded' \
                            --data 'IMAGE_TAG=${IMAGE_TAG}' \
                            'http://ec2-13-53-36-0.eu-north-1.compute.amazonaws.com:8080/job/gitops-register-app-cd/buildWithParameters?token=gitops-token'
                        """
                    }
                }
            }
        }

    } // ✅ stages end

    post {

        success {
            echo "✅ Build successful!"
            echo "🐳 Docker Image pushed:"
            echo "   ${IMAGE_NAME}:${IMAGE_TAG}"
            echo "   ${IMAGE_NAME}:latest"

            emailext body: '''${SCRIPT, template="groovy-html.template"}''',
                    subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Successful",
                    mimeType: 'text/html',
                    to: "puvishapa@gmail.com"
        }

        failure {
            echo "❌ Build failed. Check logs."

            emailext body: '''${SCRIPT, template="groovy-html.template"}''',
                    subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Failed",
                    mimeType: 'text/html',
                    to: "puvishapa@gmail.com"
        }

        always {
            cleanWs()
        }
    }
}
