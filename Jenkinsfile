#!groovy

node {
    stage 'Checkout'
        checkout scm

    stage 'Build'
        echo "Branch is: ${env.BRANCH_NAME}"
        echo "Build is: ${env.BUILD_NUMBER}"
        env.DOCKER_USE_HUB = 1
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerbot',
                          usernameVariable: 'DOCKER_USERNAME', 
                          passwordVariable: 'DOCKER_PASSWORD']]) {
            wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                sh './build.sh'
            }
        }
}
