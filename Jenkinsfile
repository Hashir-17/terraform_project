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
                # Use bash to create and activate the virtual environment
                bash -c "python3 -m venv venv"
                bash -c "source venv/bin/activate"
                bash -c "pip install --upgrade pip"
                bash -c "pip install pytest"
                '''
            }
        }

        stage('Run Tests') {
            steps {
                // Run the tests using pytest
                sh '''
                bash -c "source venv/bin/activate"  # Activate the virtual environment
                bash -c "cd src"  # Assuming your Python files are in the 'src' folder
                bash -c "python3 -m pytest test_addition.py"  # Run the tests
                '''
            }
        }
    }

    post {
        always {
            // Clean up the environment after the build
            echo 'Cleaning up environment'
            sh '''
            bash -c "deactivate"
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
