pipeline {

    agent {
      label "master"
     }
          
    tools {
       maven 'Maven' 
       jdk 'Java'      
    }
    
    stages {
            stage('Checkout SCM') {
                    steps {
                        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Shweta1319/devops-java-maven-code.git']]])
                    }
           }
           
            stage('Build') {
                    steps {
                        sh 'mvn install'
                    }
           }
           
           stage('Test'){
                    steps{
                      sh 'mvn test'
                    }
                    post {
                        always {
                            junit 'target/surefire-reports/*.xml'
                        }
                    }
             }
             
            stage('DeploytoNexus'){
                    steps{
                        sh 'mvn deploy'                     
                    }
             }
             stage('SonarQube') {
                    steps {
                        sh 'mvn sonar:sonar'
                    }
           }
}
