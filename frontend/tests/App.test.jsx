import { render, screen, waitFor } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import axios from 'axios';
import App from '../src/App';

// Mock axios
vi.mock('axios');

describe('App Component', () => {
  it('displays loading state initially', () => {
    axios.get.mockResolvedValueOnce({ data: { message: 'Hello World' } });
    
    render(<App />);
    
    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });

  it('displays message from API after loading', async () => {
    // Mock the API response
    axios.get.mockResolvedValueOnce({ data: { message: 'Hello World' } });
    
    render(<App />);
    
    // Wait for the API call to resolve
    await waitFor(() => {
      expect(screen.getByText('Hello World')).toBeInTheDocument();
    });
  });

  it('displays error when API call fails', async () => {
    // Mock the API error
    axios.get.mockRejectedValueOnce(new Error('API Error'));
    
    render(<App />);
    
    // Wait for the API call to reject
    await waitFor(() => {
      expect(screen.getByText('Failed to fetch data from the API')).toBeInTheDocument();
    });
  });
});
