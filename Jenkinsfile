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
  }
  catch (err) {
    throw err
  }
}
