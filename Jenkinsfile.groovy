pipeline {
     agent any
        
     stages {
         stage('Checkout') {
             steps {
                 git branch: 'main', url: 'https://github.com/fahricetin/angularProject.git'
                 stash includes: '**/*', name: 'angularProject'
             }
         }
         stage('Checkov') {
             steps {
                 script {
                     docker.image('bridgecrew/checkov:latest').inside("--network host --entrypoint=''") {
                         unstash 'angularProject'
                         try {
                             sh 'checkov -d . -o cli -o junitxml --output-file-path console,results.xml --repo-id fahricetin/angularProject.git --branch main'
                             junit skipPublishingChecks: true, testResults: 'results.xml'
                         } catch (err) {
                             junit skipPublishingChecks: true, testResults: 'results.xml'
                             throw err
                         }
                     }
                 }
             }
         }
     }
     options {
         preserveStashes()
         timestamps()
     }
 }
