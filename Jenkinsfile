pipeline {
  agent any

  options {
    ansiColor('xterm')
  }

  stages {
    stage ('Build') {
      steps {
        sh '''
make ladders
'''
      }
    }
  }
}
