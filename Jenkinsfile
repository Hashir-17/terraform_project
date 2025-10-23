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
                # Create a virtual environment using python3
                python3 -m venv venv
                
                # Activate the virtual environment using bash
                source venv/bin/activate
                
                # Upgrade pip in the virtual environment
                pip install --upgrade pip
                
                # Install pytest in the virtual environment
                pip install pytest
                '''
            }
        }

        stage('Run Tests') {
            steps {
                // Run the tests using pytest in the virtual environment
                sh '''
                # Activate the virtual environment in bash
                source venv/bin/activate
                
                # Run tests in the 'src' directory
                cd src  # Assuming your Python files are in the 'src' folder
                python3 -m pytest test_addition.py  # Run the tests
                '''
            }
        }
    }

    post {
        always {
            // Clean up the environment after the build (deactivate the virtual environment)
            echo 'Cleaning up environment'
            sh '''
            # Deactivate the virtual environment
            deactivate
            '''
        }

        success {
            echo 'Tests passed successfully!'
        }

        failure {
            echo 'Tests failed!'
        }
    }
}
