// Start of Pipeline
pipeline {

// Restricting pipeline to run on master agent
    agent {
      label "master"
     }
 
 // Defining maven and jdk configuration for the pipeline
    tools {
       maven 'Maven' 
       jdk 'Java'      
    }
   
 // Defining Stages
    stages {
    
    // Checking out GIT code
            stage('Checkout SCM') {
                    steps {
                        deleteDir()
                        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Shweta1319/devops-java-maven-code.git']]])
                          }
            }
    
    // Compiling the code and publishing Jacoco reports
            stage('Build') {
                    steps {
                        sh 'mvn install'
                        jacoco()
                    }
            }
     
    // Running Test files and publising the JUnit reports
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
     
     // Uploading artifacts to Nexus Repository Manager
            stage('UploadtoNexus'){
                    steps{
                        sh 'mvn deploy'                     
                    }
             }
             
     //  Executing Sonar and creating reports on SonarQube server  
             stage('SonarQubeReport') {
                    steps {
                        sh 'mvn sonar:sonar'
                    }
             }
             
  // End of Stages 
    }
    
//End of Pipeline
}
