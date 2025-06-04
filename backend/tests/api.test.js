const request = require('supertest');
const app = require('../src/server');

describe('API Routes', () => {
  describe('GET /api/hello', () => {
    it('should return a message "Hello World"', async () => {
      const res = await request(app)
        .get('/api/hello')
        .expect(200);
      
      expect(res.body).toHaveProperty('message');
      expect(res.body.message).toBe('Hello World');
    });
  });

  describe('GET /health', () => {
    it('should return status UP', async () => {
      const res = await request(app)
        .get('/health')
        .expect(200);
      
      expect(res.body).toHaveProperty('status');
      expect(res.body.status).toBe('UP');
    });
  });
});
