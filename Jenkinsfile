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
    image: quay.imanuel.dev/dockerhub/library---docker:stable
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  - name: dart
    image: quay.imanuel.dev/dockerhub/library---dart:stable
    command:
    - cat
    tty: true
'''
            defaultContainer 'docker'
        }
    }
    stages {
        stage('Build binary') {
            steps {
                container('dart') {
                    sh "dart pub get"
                    sh "dart pub get --offline"
                    sh "dart compile exe bin/influx_alerter.dart -o bin/influx_alerter"
                    archiveArtifacts artifacts: 'bin/influx_alerter', followSymlinks: false, onlyIfSuccessful: true
                }
            }
        }
        stage('Push') {
            steps {
                container('docker') {
                    sh "docker build -t quay.imanuel.dev/imanuel/influx-alerter:v1.$BUILD_NUMBER -f ./Dockerfile ."
                    sh "docker tag quay.imanuel.dev/imanuel/influx-alerter:v1.$BUILD_NUMBER quay.imanuel.dev/imanuel/influx-alerter:latest"

                    sh "docker tag quay.imanuel.dev/imanuel/influx-alerter:v1.$BUILD_NUMBER iulbricht/influx-alerter:v1.$BUILD_NUMBER"
                    sh "docker tag quay.imanuel.dev/imanuel/influx-alerter:v1.$BUILD_NUMBER iulbricht/influx-alerter:latest"

                    withDockerRegistry(credentialsId: 'quay.imanuel.dev', url: 'https://quay.imanuel.dev') {
                        sh "docker push quay.imanuel.dev/imanuel/influx-alerter:v1.$BUILD_NUMBER"
                        sh "docker push quay.imanuel.dev/imanuel/influx-alerter:latest"
                    }
                    withDockerRegistry(credentialsId: 'hub.docker.com', url: '') {
                        sh "docker push iulbricht/influx-alerter:v1.$BUILD_NUMBER"
                        sh "docker push iulbricht/influx-alerter:latest"
                    }
                }
            }
        }
    }
}
