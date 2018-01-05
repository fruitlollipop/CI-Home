pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "Start to Build"'
        sh 'pwd'
        sh 'whoami'
        sh 'cd /mnt/hgfs/Share/Projects/CI-Home && docker build -t hellodjango:testenv .'
      }
    }
    stage('Test') {
      agent
      {
        docker { image 'hellodjango:testenv' }
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