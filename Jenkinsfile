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

            // 사전 준비
            sh("""
               git config --global user.name "XOXOT"
               git config --global user.email "1418083@donga.ac.kr"
               git checkout -B main
            """)

            // 전역변수에 값 넣기
            // previousTAG 변수에 이전 빌드 번호 넣음 
            script {
                previousTAG = sh(script: 'echo 'expr ${env.BUILD_NUMBER} - 1'', returnStdout: true).trim()
            }

            // previousTAG 를 최신 빌으 번호로 바꿔서 push 
            withCredentials([usernamePassword(credentialsId: 'github-signin', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                sh("""
                   #!/usr/bin/env bash
                   git config --local credential.helper "!f() { echo username=\\$GIT_USERNAME; echo password=\\$GIT_PASSWORD; }; f"
                   echo ${previousTAG}
                   sed -i 's/fatclinic:$[previousTAG}/fatclinic:${env.BUILD_NUMBER}/g' ./deploy.yaml
                   git add deploy.yaml
                   git status
                   git commit -m "update the image tag"
                   git push origin HEAD:master
                """)
            }
        }
    }             

}
