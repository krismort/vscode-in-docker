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
              configName: "35.158.97.253",
              verbose: true,
              transfers: [
                sshTransfer(
                  execCommand: "sudo docker ps && sudo docker pull 35.158.97.253:5000/vscode && sudo docker volume create --name vscode_data && sudo docker volume create --name vscode_prj && sudo docker kill vscodeinst || true && sudo docker run -d -p 5901:5900 -p 3001:3000 --rm -v=vscode_prj:/home/code/mount --entrypoint=/usr/bin/entry-point-headless --name vscodeinst --volume=vscode_data:/home/code/.vscode vscode"
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
