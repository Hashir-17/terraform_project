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
                // Set up a Python virtual environment and install dependencies
                sh '''
                # Create a virtual environment
                python3 -m venv venv
                source venv/bin/activate  # Activate the virtual environment
                pip install --upgrade pip
                pip install pytest
                '''
            }
        }

        stage('Run Tests') {
            steps {
                // Run the tests using pytest
                sh '''
                source venv/bin/activate  # Activate the virtual environment
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
            sh 'deactivate'  # Deactivate the virtual environment
        }

        success {
            echo 'Tests passed successfully!'
        }

        failure {
            echo 'Tests failed!'
        }
    }
}
