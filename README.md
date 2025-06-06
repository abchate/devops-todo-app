# DevOps Todo App

A full-stack web application with React frontend and Node.js/Express backend, featuring comprehensive DevOps tooling including blue/green deployment, Netlify frontend deployment, Prometheus alerting, and complete monitoring stack.

## Project Structure

```
devops-todo-app/
├── frontend/               # React application built with Vite
│   ├── src/                # React source files
│   ├── tests/              # Frontend tests
│   ├── dist/               # Production build output
│   ├── Dockerfile          # Frontend container definition
│   └── nginx.conf          # Nginx configuration for production
├── backend/                # Node.js + Express server
│   ├── src/                # Server source files
│   │   ├── controllers/    # API controllers
│   │   ├── routes/         # API routes
│   │   └── server.js       # Express server configuration
│   ├── tests/              # Backend tests
│   └── Dockerfile          # Backend container definition
├── deploy/                 # Deployment scripts and configurations
│   ├── deploy.sh           # Interactive Netlify CLI deployment script
│   ├── deploy-drag.sh      # Manual Netlify drag-and-drop deployment script
│   └── switch-bluegreen.sh # Blue/Green deployment switching script
├── nginx/                  # Nginx configurations
│   └── backend-proxy.conf  # Proxy configuration for blue/green deployments
├── prometheus/             # Prometheus configuration
│   ├── prometheus.yml      # Prometheus config file
│   └── alert-rules.yml     # Alert rules configuration
├── alertmanager/           # Alertmanager configuration
│   └── alertmanager.yml    # Alertmanager config with email notifications
├── docker-compose.yml      # Docker Compose with blue/green setup
├── Jenkinsfile             # Jenkins CI/CD pipeline
└── k6-test.js              # K6 performance testing script
```

## Features

- **Frontend**: React application with Vite
- **Backend**: Node.js and Express REST API
- **Testing**: Unit tests with Jest, React Testing Library, and K6 performance testing
- **DevOps**:
  - Docker containerization with multi-stage builds
  - Docker Compose for service orchestration
  - Blue/Green deployment with Nginx proxy
  - Jenkins CI/CD pipeline
  - Prometheus for metrics collection and alerting
  - Alertmanager for notification management
  - Grafana for metrics visualization
  - K6 for performance testing
  - Netlify deployment automation

## Prerequisites

- Node.js (v16+)
- npm or yarn
- Docker and Docker Compose (for containerized deployment)
- Jenkins (optional, for CI/CD)

## Running Locally

### Backend

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Run in development mode
npm run dev

# Run tests
npm test
```

The backend will be available at http://localhost:5000 (or http://localhost:9090 when running with Docker).

### Frontend

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Run in development mode
npm run dev

# Run tests
npm test
```

The frontend will be available at http://localhost:3000 (or http://localhost:80 when running with Docker).

## Running with Docker

The application can be easily run using Docker Compose:

### Build and Run with Docker Compose

```bash
# Navigate to the project root directory
cd devops-todo-app

# Build the Docker images
docker compose build

# Start the containers in detached mode
docker compose up -d

# Check the running containers
docker compose ps

# View logs from all containers
docker compose logs

# View logs from a specific container
docker compose logs frontend
docker compose logs backend

# Stop the containers
docker compose down

# Stop containers and remove volumes
docker compose down -v
```

### Container Services

The Docker Compose setup includes the following services:

| Service      | Description                      | Port Mapping   | Internal Port |
|--------------|----------------------------------|----------------|------------|
| frontend     | React application with Nginx     | 80:80          | 80           |
| backend-blue | Node.js Express API server (Blue)| 5001:5000      | 5000         |
| backend-green| Node.js Express API server (Green)| 5002:5000     | 5000         |
| nginx        | Reverse proxy for blue/green     | 9090:80        | 80           |
| prometheus   | Metrics collection and alerting  | 9091:9090      | 9090         |
| alertmanager | Alert handling and notifications | 9093:9093      | 9093         |
| grafana      | Metrics visualization            | 3000:3000      | 3000         |

### Access Points

Once Docker Compose is running:
- **Frontend**: http://localhost
- **Backend API**: http://localhost:9090/api (proxied to active blue/green environment)
- **Prometheus**: http://localhost:9091
- **Alertmanager**: http://localhost:9093
- **Grafana**: http://localhost:3000 (admin/supermotdepasse)
- **Metrics endpoint**: http://localhost:9090/metrics

## CI/CD with Jenkins

A Jenkins pipeline is included (`Jenkinsfile`) that automates the following steps:

1. Verifies Docker and Docker Compose installation
2. Removes any existing containers
3. Builds and runs all containers with Docker Compose
4. Tests the backend API (metrics endpoint)
5. Tests the frontend
6. Runs K6 performance tests

To use Jenkins:
1. Add this repository to your Jenkins instance
2. Create a new Pipeline job pointing to the Jenkinsfile
3. Run the job

## Blue/Green Deployment

The application supports blue/green deployment pattern for zero-downtime updates of the backend service.

```bash
# Navigate to the deploy directory
cd deploy

# Make the script executable if needed
chmod +x switch-bluegreen.sh

# Switch between blue and green environments
./switch-bluegreen.sh switch

# Get current active environment
./switch-bluegreen.sh status

# Roll back to previous environment in case of issues
./switch-bluegreen.sh rollback
```

The blue/green deployment uses Nginx as a reverse proxy to route traffic to the active environment. The configuration is in `nginx/backend-proxy.conf`.

## Frontend Deployment with Netlify

The frontend can be deployed to Netlify using one of two provided scripts:

### Interactive CLI Deployment

```bash
# Navigate to the deploy directory
cd deploy

# Make the script executable
chmod +x deploy.sh

# Run the deployment script
./deploy.sh
```

This script will build the frontend and guide you through the Netlify CLI deployment process interactively.

### Manual Drag-and-Drop Deployment

```bash
# Navigate to the deploy directory
cd deploy

# Make the script executable
chmod +x deploy-drag.sh

# Run the script
./deploy-drag.sh
```

This script will build the frontend and open the Netlify web interface for you to manually drag-and-drop the `dist` folder.

After deployment, update your backend URL in the frontend environment configuration if needed.

## Monitoring

### Prometheus

Prometheus is configured to scrape metrics from the backend service. Configuration files:
- `prometheus/prometheus.yml` - Main configuration
- `prometheus/alert-rules.yml` - Alert rules configuration

### Alertmanager

Alertmanager handles alerts sent by Prometheus and routes notifications to various channels. Configuration:
- `alertmanager/alertmanager.yml` - Email notification setup

To configure email notifications:
1. Update the `alertmanager.yml` file with your SMTP server settings
2. Set proper receiver email addresses
3. Restart the alertmanager service

### Grafana

Grafana is pre-configured with default credentials:
- Username: `admin`
- Password: `supermotdepasse`

To set up dashboards:
1. Log in to Grafana at http://localhost:3000
2. Add Prometheus as a data source (URL: http://prometheus:9090)
3. Import or create dashboards to visualize your metrics

## API Endpoints

- `GET /api/hello`: Returns a simple "Hello World" message
- `GET /health`: Health check endpoint that returns status
- `GET /metrics`: Prometheus metrics endpoint

## Performance Testing

K6 is used for performance testing. The test script is in `k6-test.js`.

To run performance tests manually:

```bash
# Install k6 (if not using Docker)
# See https://k6.io/docs/getting-started/installation/

# Run test with Docker
docker run --rm -i grafana/k6 run - < k6-test.js

# Or run locally if k6 is installed
k6 run k6-test.js
```

## DevOps Best Practices

This project implements the following DevOps best practices:

### Continuous Integration & Deployment
- Jenkins pipeline for automated testing and deployment
- Netlify deployment for frontend hosting
- Automated build and deployment scripts

### Zero Downtime Deployment
- Blue/Green deployment pattern for backend services
- Nginx reverse proxy for seamless traffic switching
- Rollback capability to previous environment

### Monitoring & Observability
- Prometheus metrics collection with custom alerting rules
- Alertmanager for notification management
- Grafana dashboards for visualization
- Health check endpoints

### Infrastructure as Code
- Docker Compose for service orchestration
- Reproducible environments through containerization
- Configuration files versioned in Git

### Security Considerations
- Environment variable management
- Separation of concerns between frontend and backend
- Proper network segmentation in Docker Compose

## Development

The project is set up for easy development:

- Frontend uses Vite with hot module replacement
- Backend uses nodemon for auto-reloading
- Tests use Jest, React Testing Library, and K6
- Prometheus and Grafana for real-time monitoring during development

## Conclusion

This DevOps Todo App demonstrates a comprehensive implementation of modern DevOps practices for a full-stack web application. By leveraging containerization, automated testing, continuous integration/deployment, blue/green deployment, and comprehensive monitoring, the application ensures reliability, scalability, and maintainability.
