# DevOps Todo App

A full-stack web application boilerplate with React frontend and Node.js/Express backend.

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
│   ├── tests/              # Backend tests
│   └── Dockerfile          # Backend container definition
└── docker-compose.yml      # Docker Compose configuration
```

## Features

- **Frontend**: React application with Vite
- **Backend**: Node.js and Express REST API
- **Testing**: Unit tests for both frontend and backend
- **Docker**: Containerized application with Docker Compose

## Prerequisites

- Node.js (v16+)
- npm or yarn
- Docker and Docker Compose (for containerized deployment)

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

The backend will be available at http://localhost:9090.

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

The frontend will be available at http://localhost:3000.

## Running with Docker

The application can be easily run using Docker Compose. Here are the detailed steps:

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

### Individual Container Management

```bash
# Restart a specific container
docker compose restart frontend
docker compose restart backend

# Scale the backend service (creates multiple instances)
docker compose up -d --scale backend=3
```

Once Docker Compose is running:
- Frontend will be available at: http://localhost
- Backend API will be available at: http://localhost:9090/api

### Docker Build Process

The Docker setup uses:
- Multi-stage build for the frontend (build with Node.js, serve with Nginx)
- Node.js Alpine image for the backend
- Docker Compose networking for service communication

## API Endpoints

- `GET /api/hello`: Returns a simple "Hello World" message
- `GET /health`: Health check endpoint that returns status

## Testing

### Backend Tests

```bash
cd backend
npm test
```

### Frontend Tests

```bash
cd frontend
npm test
```

## Development

The project is set up for easy development:

- Frontend uses Vite with hot module replacement
- Backend uses nodemon for auto-reloading
- Tests use Jest and React Testing Library
