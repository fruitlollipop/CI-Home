pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'echo "Start to Build"'
        sh 'docker build -t hellodjango:v6 .'
      }
    }
    stage('Test') {
      steps {
        sh 'echo "Start to Test"'
        sh 'docker run -d -p 8083:8082 --name lollipop hellodjango:v6'
        sh 'wget https://github.com/mozilla/geckodriver/releases/download/v0.19.1/geckodriver-v0.19.1-linux64.tar.gz'
        sh 'tar zxf geckodriver-v0.19.1-linux64.tar.gz && chmod +x geckodriver-v0.19.1-linux64.tar.gz'
        sh 'export PATH=$PATH:.'
        sh './run_tests.sh'
      }
    }
    stage('Deploy') {
      steps {
        sh 'echo "Start to Deploy"'
      }
    }
  }
}