pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "Start to Build"'
        sh 'whoami'
        sh 'hostname'
      }
    }
    stage('Test') {
      steps {
        sh 'echo "Start to Test"'
        sh 'whoami'
      }
    }
    stage('Deploy') {
      steps {
        sh 'echo "Start to Deploy"'
      }
    }
  }
}