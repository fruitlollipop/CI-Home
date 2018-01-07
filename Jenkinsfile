pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "Start to Build"'
        sh 'docker build -t hellodjango:v5 .'
      }
    }
    stage('Test') {
      steps {
        sh 'echo "Start to Test"'
        sh 'docker run -d -p 8083:8082 --name lollipop hellodjango:v5'
        sh 'docker exec -i lollipop bash /app/run_tests.sh'
      }
    }
    stage('Deploy') {
      steps {
        sh 'echo "Start to Deploy"'
      }
    }
  }
}