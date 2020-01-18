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
                        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/TechVerito-Github/devops-java-maven-code.git']]])
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
             
             stage('DeploytoTomcat'){
                    steps{
                        deploy adapters: [tomcat8(credentialsId: '1de8381f-0df6-4c36-99af-467ac731a2a7', path: '', url: 'http://18.222.185.192:9090/')], contextPath: 'banerwar', war: '**/*.war'                    }
             }

    }
}
