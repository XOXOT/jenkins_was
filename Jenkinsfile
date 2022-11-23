pipeline {
    agent  {
        label 'dind-agent'
    }
    stages {
        stage('Build image') {
            steps {
                script {
                    app = docker.build("terraform-tae/was-registry/fatclinic")
                }
            }
        }
        
        stage("Push image to gcr") {
            steps {
                script {
                    docker.withRegistry('https://asia-northeast3-docker.pkg.dev', 'gcr:terraform-tae') {
                        app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }

    }
}
