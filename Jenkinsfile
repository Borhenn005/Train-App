pipeline {
    agent any
    environment {
            NEXUS_VERSION = "nexus3"
            NEXUS_PROTOCOL = "http"
            NEXUS_URL = "localhost:8081"
            NEXUS_REPOSITORY = "maven-snapshots"
    }
    stages{
        stage('Compile-package'){
            steps{
                script{
                    sh 'mvn package'
                }
            }
        }
        stage('Sonarqube Analysis'){
            steps{
                script{
                    jacoco()
                    def mvnHome = tool name: 'maven', type: 'maven'
                    withSonarQubeEnv('sonar'){
                        sh "${mvnHome}/bin/mvn verify sonar:sonar"
                    }
                }
            }
        }
        stage("Quality gate status check") {
            steps {
                script{
                sleep(10)
              timeout(time: 1, unit: 'HOURS') {
                def qg = waitForQualityGate()
                if(qg.status != 'OK') {
                    error "Pipeline aborted due to quality gate failure: ${qg.status}"
                }
                }
              }
            }
          }
        stage("Deploying jar to Nexus Repository"){
            steps{
                script{
                     nexusPublisher nexusInstanceId: 'nexus', nexusRepositoryId: 'maven-releases', packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: '', filePath: './target/ExamThourayaS2-1.jar']],mavenCoordinate: [artifactId: 'ExamThourayaS2', groupId: 'tn.esprit.spring', packaging: 'jar', version: '1']]]
                }
            }
        }

            stage('Build And Deploy Docker Image'){
                    steps{
                        script{
                            echo "deploying the application"
                            withCredentials([usernamePassword(credentialsId:'dockerhub',usernameVariable:'USER',passwordVariable:'PWD')]) {
                                sh "docker login -u $USER -p $PWD"
                                sh "docker build -t paradax/train-app:1.0 ."
                                sh "docker push paradax/train-app:1.0"

                        }
                    }
                }
            }

        stage('Docker Compose'){
            steps{
                script{
                    sh 'docker compose up'
                }
            }
        }
    }
}
