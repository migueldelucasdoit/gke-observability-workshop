import http from 'k6/http';
import { sleep } from 'k6';
import { randomIntBetween } from 'https://jslib.k6.io/k6-utils/1.4.0/index.js';

export const options = {
  vus: 20,
  duration: '60s',
};

export default function () {
  // send custom payload/post data
  const date = new Date();
  const payload = JSON.stringify({
    timestamp: date.toISOString(), //RFC 3339 format
    device_id: "device01",
    memory_usage: 0.45,
    cpu_usage: 0.23
  });

 // send post request with custom header and payload
  http.post('http://34.110.142.233/telemetry', payload, {
    headers: {
      'Content-Type': 'application/json',
    },
  });
  sleep(randomIntBetween(1, 20)) // Sleep between 1 and 20 seconds
}