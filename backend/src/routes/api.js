const express = require('express');
const router = express.Router();

// Simple hello world endpoint
router.get('/hello', (req, res) => {
  res.json({ message: 'Hello World' });
});

module.exports = router;
