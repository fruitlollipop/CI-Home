pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "Start to Build"'
        sh 'docker run --name mysql-server -p 8084:3306 -e MYSQL_ROOT_PASSWORD=zhou19891001 -d mysql:5.7.21'
        sh 'chmod +x run_app.sh'
        sh './run_app.sh -f Dockerfile -d /app -t app:runner -p 8083 Lollipop'
      }
    }
    stage('Test') {
      steps {
        sh 'echo "Start to Test"'
      }
    }
    stage('Deploy') {
      steps {
        sh 'echo "Start to Deploy"'
      }
    }
  }
}