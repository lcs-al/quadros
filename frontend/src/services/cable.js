import { createConsumer } from '@rails/actioncable';

const getWebSocketURL = () => {
  // Determine WebSocket URL based on current environment
  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
  // Assuming backend is running on port 3000 by default for development
  // Adjust this based on your actual API_URL configuration
  const host = process.env.VITE_API_URL || 'localhost:3000';
  return `${protocol}//${host}/cable`;
};

const consumer = createConsumer(getWebSocketURL());

export default consumer;
