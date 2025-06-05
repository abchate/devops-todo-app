const express = require('express');
const cors = require('cors');
const path = require('path');

// Import routes
const apiRoutes = require('./routes/api');

const app = express();
const PORT = process.env.PORT || 5000; // ✅ Port corrigé pour correspondre au Dockerfile

// Middleware
app.use(cors());
app.use(express.json());

// Prometheus setup
const client = require('prom-client');
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics(); // ✅ collecte automatique des métriques système

// Endpoint /metrics pour Prometheus
app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', client.register.contentType);
    res.end(await client.register.metrics());
  } catch (ex) {
    res.status(500).end(ex);
  }
});

// API Routes
app.use('/api', apiRoutes);

// Health check (utile aussi pour les probes ou monitoring)
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

// Start server
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

module.exports = app;
