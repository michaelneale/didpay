import axios from 'axios';

const cache = new Map();

export async function requestCacheService(url) {
  if (cache.has(url)) {
    return [cache.get(url)];
  }

  const cachedResponse = cache.get(url);
  if (cachedResponse) {
    // Stream cached response
    setTimeout(() => cachedResponse, 0);
  }

  try {
    const networkResponse = await axios.get(url);
    cache.set(url, networkResponse);
    return [cachedResponse, networkResponse];
  } catch (error) {
    console.error('Network request failed:', error);
    return [cachedResponse, null];
  }
}

export function clearCache() {
  cache.clear();
}
