pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "Start to Build"'
        sh 'docker build -t hellodjango:v3 .'
      }
    }
    stage('Test') {
      steps {
        sh 'echo "Start to Test"'
        sh 'docker run -d -p 8083:80 --name lollipop hellodjango:v3'
        sh 'docker exec -i lollipop bash /app/run_tests.sh'
      }
    }
    stage('Deploy') {
      steps {
        sh 'echo "Start to Deploy"'
        sh 'docker stop lollipop'
      }
    }
  }
}