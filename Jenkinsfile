pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    // Checkout the source code from your version control system (e.g., Git)
                    checkout scm

                    // Build and compile the Node.js application
                    sh 'docker build -t myproject-build -f angularProject/Dockerfile .'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Run tests for the Node.js application (modify this command based on your testing framework)
                    sh 'docker stop myproject-build-test || true'
                    sh 'docker container rm myproject-build-test || true'
                    sh 'docker run --rm -d -p 8080:80 --name myproject-build-test myproject-build'
                    sh 'curl http://localhost:8080'
                    sh 'docker stop -t 10 myproject-build-test'
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    // Stop and remove the existing container if it's running
                    sh 'docker stop myproject-container || true'
                    sh 'docker rm myproject-container || true'

                    // Run the Docker image and deploy the application
                    sh 'docker run -p 80:80 --name myproject-container myproject-build'
                }
            }
        }
    }
    
}
