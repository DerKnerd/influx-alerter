// Uses Declarative syntax to run commands inside a container.
pipeline {
    triggers {
        pollSCM("*/5 * * * *")
    }
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
  containers:
  - name: docker
    image: docker:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
'''
            defaultContainer 'docker'
        }
    }
    stages {
        stage('Push') {
            steps {
                container('docker') {
                    sh "docker build -t registry-hosted.imanuel.dev/tools/influx-alerter:$BUILD_NUMBER -f ./Dockerfile ."
                    sh "docker tag registry-hosted.imanuel.dev/tools/influx-alerter:$BUILD_NUMBER iulbricht/influx-alerter:$BUILD_NUMBER"
                    sh "docker tag registry-hosted.imanuel.dev/tools/influx-alerter:$BUILD_NUMBER iulbricht/influx-alerter:latest"

                    withDockerRegistry(credentialsId: 'nexus.imanuel.dev', url: 'https://registry-hosted.imanuel.dev') {
                        sh "docker push registry-hosted.imanuel.dev/tools/influx-alerter:$BUILD_NUMBER"
                    }
                    withDockerRegistry(credentialsId: 'hub.docker.com', url: '') {
                        sh "docker push iulbricht/influx-alerter:$BUILD_NUMBER"
                        sh "docker push iulbricht/influx-alerter:latest"
                    }
                }
            }
        }
    }
}
