node {
  try {
    stage('Checkout') {
      checkout scm
    }
    stage('Environment') {
      sh 'git --version'
      echo "Branch: ${env.BRANCH_NAME}"
      sh 'docker -v'
      sh 'printenv'
    }
    stage('Deploy'){
      if(env.BRANCH_NAME == 'master'){
        sh 'docker build -t vscode --no-cache .'
        sh 'docker tag vscode localhost:5000/vscode'
        sh 'docker push localhost:5000/vscode'
        sh 'docker rmi -f v localhost:5000/vscode'
      }
    }
    stage('SSH transfer') {
      script {
        sshPublisher(
          continueOnError: false, failOnError: true,
          publishers: [
            sshPublisherDesc(
              configName: "vscode",
              verbose: true,
              transfers: [
                sshTransfer(
                  execCommand: "pwd"
                )
              ]
            )
          ]
        )
      }
    }
  }
  catch (err) {
    throw err
  }
}
