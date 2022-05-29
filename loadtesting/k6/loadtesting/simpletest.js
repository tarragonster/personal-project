import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  insecureSkipTLSVerify: true,
  noConnectionReuse: true,
  vus: 10,
  duration: '10s'
};

export default function () {
  http.get('http://docker.for.mac.localhost:83/');
  sleep(1);
}
