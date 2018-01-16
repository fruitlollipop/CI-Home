pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "Start to Build"'
        sh 'chmod +x run_app.sh'
        sh './run_app.sh -d /app -f Dockerfile -t app:lollipop -p 8083 Lollipop'
        sh 'docker run --name mysql-server -p 8084:3306 -e MYSQL_ROOT_PASSWORD=zhou19891001 -d mysql5.7.20:ubuntu'
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