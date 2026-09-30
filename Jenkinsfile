pipeline {
    agent any

    environment {
        IMAGE_NAME = 'instrumento-web'
        CONTAINER_NAME = 'instrumento'
    }

    triggers {
        pollSCM('H/2 * * * *')
    }

    stages {
        stage('Clonar repositorio') {
            steps {
                checkout scm
            }
        }

        stage('Compilar imagen') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Pruebas') {
            steps {
                sh '''
                    docker rm -f test-web 2>/dev/null || true
                    docker run -d --name test-web -p 8083:80 ${IMAGE_NAME}:${BUILD_NUMBER}
                    sleep 5
                    curl -f http://localhost:8083
                    docker rm -f test-web
                '''
            }
        }

        stage('Desplegar') {
            steps {
                sh '''
                    docker rm -f ${CONTAINER_NAME} 2>/dev/null || true
                    docker run -d --name ${CONTAINER_NAME} -p 8081:80 ${IMAGE_NAME}:${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        failure {
            sh 'docker rm -f test-web 2>/dev/null || true'
            echo 'El pipeline falló, revisar los logs.'
        }
        success {
            echo 'Despliegue correcto en http://localhost:8081'
        }
    }
}
