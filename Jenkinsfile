pipeline {
    agent any

    environment {
        PYTHON_ENV = 'python3'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the Git repository
                git 'https://github.com/Hashir-17/terraform_project.git'
            }
        }

        stage('Set Up Python Environment') {
            steps {
                // Install dependencies globally (no virtual environment)
                sh '''
                # Install pip and pytest globally
                python3 -m pip install --upgrade pip
                pip install pytest
                '''
            }
        }

        stage('Run Tests') {
            steps {
                // Run the tests using pytest
                sh '''
                cd src  # Assuming your Python files are in the 'src' folder
                python3 -m pytest test_addition.py  # Run the tests
                '''
            }
        }
    }

    post {
        always {
            // Clean up the environment after the build
            echo 'Cleaning up environment'
        }

        success {
            echo 'Tests passed successfully!'
        }

        failure {
            echo 'Tests failed!'
        }
    }
}
