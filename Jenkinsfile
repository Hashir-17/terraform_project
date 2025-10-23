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
                // Set up Python environment and install dependencies
                sh '''
                python3 -m venv venv  # Create virtual environment
                source venv/bin/activate
                pip install --upgrade pip
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
            sh 'deactivate'
        }

        success {
            echo 'Tests passed successfully!'
        }

        failure {
            echo 'Tests failed!'
        }
    }
}
