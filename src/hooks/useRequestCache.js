import { useState, useEffect } from 'react';
import { requestCacheService } from '../requestCacheService';

function useRequestCache(url) {
  const [cachedData, setCachedData] = useState(null);
  const [networkData, setNetworkData] = useState(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    let isSubscribed = true;
    setLoading(true);
    requestCacheService(url).then(([cached, network]) => {
      if (isSubscribed) {
        if (cached) setCachedData(cached.data);
        if (network) setNetworkData(network.data);
        setLoading(false);
      }
    }).catch((error) => {
      console.error('Cache service error:', error);
      if (isSubscribed) setLoading(false);
    });
    return () => (isSubscribed = false);
  }, [url]);

  return { cachedData, networkData, loading };
}

export default useRequestCache;