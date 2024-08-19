pipeline {
    agent {
        label 'agent1'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Checkout the source code from your version control system (e.g., Git)
                    //checkout scm

                    // Build and compile the Node.js application
                    echo 'Bulid Project Starting'
                    dh 'su root'
                    sh 'rm -rf angularProject'
                    sh 'git config --global http.sslverify false'
                    sh 'git clone https://github.com/fahricetin/angularProject.git'
                    sh 'cd angularProject'
                    sh 'docker build -t myproject-build -f angularProject/Dockerfile .'
                    echo 'Docker Image Created Suceessfully'
                }
            }
        }

        stage('Scan') {
            steps {
                // Scan the image | Input value from first script copied below, '' prismaCloudScanImage - Scan Prisma Cloud Images"
                prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', ignoreImageBuildTime: true, image: 'myproject-build', key: '', logLevel: 'info', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json'
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
                    sh 'docker run -d -p 80:80 --name myproject-container myproject-build'
                }
            }
        }
    }
  
    post {
        always {
            // The post section lets you run the publish step regardless of the scan results | Input value from second script copied below, "prismaCloudPublish - Publish Prisma Cloud analysis results."
           prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
        }
    }
    
}
