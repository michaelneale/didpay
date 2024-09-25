import 'package:flutter_hooks/flutter_hooks.dart';
import 'request_caching_service.dart';

Map<String, dynamic> useRequestCache(String url) {
  final service = useMemoized(() => RequestCachingService(), []);
  final snapshot = useStream(service.dataStream);

  useEffect(() {
    service.fetchData(url);
    return null;
  }, [url]);

  return snapshot.data ?? {};
}