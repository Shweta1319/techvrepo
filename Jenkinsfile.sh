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
                      nexusArtifactUploader artifacts: [[artifactId: 'java-maven-junit-helloworld', classifier: '', file: 'target/java-maven-junit-helloworld-2.0-SNAPSHOT.jar', type: 'jar']], credentialsId: '1a4bc6a6-b1af-40b0-9627-dd588c942cbe', groupId: 'com.example', nexusUrl: '54.80.214.39:8081/', nexusVersion: 'nexus2', protocol: 'http', repository: 'http://54.80.214.39:8081/repository/maven-snapshots/', version: '2.0-SNAPSHOT'
                      
                    }
             }
             
             stage('DeploytoTomcat'){
                    steps{
                        deploy adapters: [tomcat8(credentialsId: '1de8381f-0df6-4c36-99af-467ac731a2a7', path: '', url: 'http://18.222.185.192:9090/')], contextPath: 'banerwar', war: '**/*.war'                    }
             }

    }
}
