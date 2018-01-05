pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "Start to Build"'
        sh 'docker build -t hellodjango:testenv .'
      }
    }
    stage('Test') {
      agent
      {
        docker { image 'hellodjango:v2' }
      }
      steps {
        sh 'echo "Start to Test"'
        sh 'whoami'
        sh 'run_tests.sh'
      }
    }
    stage('Deploy') {
      steps {
        sh 'echo "Start to Deploy"'
      }
    }
  }
}