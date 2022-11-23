pipeline {
    agent  {
        label 'dind-agent'
    }
    stages {
        stage('Build image') {
            steps {
                script {
                    app = docker.build("terraform-tae/fatclinic")
                }
            }
        }
        
        stage("Push image to gcr") {
            steps {
                script {
                    docker.withRegistry('https://asia.gcr.io', 'gcr:terraform-tae') {
                        app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('Push Yaml'){
            when {
                expression {
                    return env.dockerBuildResult ==~ /(?i)(Y|YES|T|TRUE|ON|RUN)/
                }
            }
            steps {
                script{
                    try {
                        git url: 'https://github.com/XOXOT/jenkins_was.git', branch: "main", credentialsId: 'git'
                        // sh "rm -rf /var/lib/jenkins/workspace/${env.JOB_NAME}/*"
                        sh """
                        #!/bin/bash
                        cat>deploy.yaml<<-EOF
                        apiVersion: apps/v1
                        kind: Deployment
                        metadata:
                        name: tomcat-deployment
                        spec:
                        replicas: 2
                        selector:
                            matchLabels:
                            tier: was
                        template:
                            metadata:
                            labels:
                                tier: was
                            spec:
                            containers:
                            - image: asia.gcr.io/terraform-tae/fatclinic:${env.BUILD_NUMBER}
                                name: fatclinic
                        EOF"""
                        //sh "cat /var/lib/jenkins/workspace/${env.JOB_NAME}/yaml/deploy.yaml"
                        withCredentials([gitUsernamePassword(credentialsId: 'git')]) {
                            sh """
                            git add .
                            git commit -m "Deploy ${env.JOB_NAME} ${env.BUILD_NUMBER}"
                            git push https://github.com/XOXOT/jenkins_was.git
                            """
                        }                      
                        sh "sudo rm -rf /var/lib/jenkins/workspace/${env.JOB_NAME}/*"
                        env.pushYamlResult=true
    }
}
