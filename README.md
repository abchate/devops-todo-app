# DevOps Todo App

A full-stack web application with React frontend and Node.js/Express backend, featuring comprehensive DevOps tooling.

## Project Structure

```
devops-todo-app/
├── frontend/               # React application built with Vite
│   ├── src/                # React source files
│   ├── tests/              # Frontend tests
│   ├── Dockerfile          # Frontend container definition
│   └── nginx.conf          # Nginx configuration for production
├── backend/                # Node.js + Express server
│   ├── src/                # Server source files
│   │   ├── controllers/    # API controllers
│   │   ├── routes/         # API routes
│   │   └── server.js       # Express server configuration
│   ├── tests/              # Backend tests
│   └── Dockerfile          # Backend container definition
├── prometheus/             # Prometheus configuration
│   └── prometheus.yml      # Prometheus config file
├── docker-compose.yml      # Docker Compose configuration
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
  - Jenkins CI/CD pipeline
  - Prometheus for metrics collection
  - Grafana for metrics visualization
  - K6 for performance testing

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

| Service     | Description                   | Port Mapping   | Internal Port |
|-------------|-------------------------------|----------------|------------|
| frontend    | React application with Nginx  | 80:80         | 80           |
| backend     | Node.js Express API server    | 9090:5000     | 5000         |
| prometheus  | Metrics collection            | 9091:9090     | 9090         |
| grafana     | Metrics visualization         | 3000:3000     | 3000         |

### Access Points

Once Docker Compose is running:
- **Frontend**: http://localhost
- **Backend API**: http://localhost:9090/api
- **Prometheus**: http://localhost:9091
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

## Monitoring

### Prometheus

Prometheus is configured to scrape metrics from the backend service. The configuration is in `prometheus/prometheus.yml`.

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

## Development

The project is set up for easy development:

- Frontend uses Vite with hot module replacement
- Backend uses nodemon for auto-reloading
- Tests use Jest, React Testing Library, and K6
- Prometheus and Grafana for real-time monitoring during development
