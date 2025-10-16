
/// Simple API response cache to reduce redundant network calls
/// Automatically expires cached data after TTL period
class ApiCache {
  static final Map<String, CacheEntry> _cache = {};
  static const Duration _defaultTTL = Duration(minutes: 5);

  /// Get cached data if available and not expired
  static T? get<T>(String key) {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired) {
      if (T == String) {
        return entry.data as T;
      } else {
        // For complex objects, you might need to deserialize
        return entry.data as T;
      }
    }
    return null;
  }

  /// Cache data with optional TTL
  static void set<T>(String key, T data, {Duration? ttl}) {
    _cache[key] = CacheEntry(
      data: data,
      expiry: DateTime.now().add(ttl ?? _defaultTTL),
    );
  }

  /// Check if key exists and is not expired
  static bool has(String key) {
    final entry = _cache[key];
    return entry != null && !entry.isExpired;
  }

  /// Clear specific cache entry
  static void remove(String key) {
    _cache.remove(key);
  }

  /// Clear all cache entries
  static void clear() {
    _cache.clear();
  }

  /// Get cache statistics
  static Map<String, dynamic> getStats() {
    final now = DateTime.now();
    final expired = _cache.values.where((e) => e.isExpired).length;
    final active = _cache.length - expired;
    
    return {
      'total_entries': _cache.length,
      'active_entries': active,
      'expired_entries': expired,
      'cache_hit_potential': active > 0 ? '${(active / _cache.length * 100).toStringAsFixed(1)}%' : '0%',
    };
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime expiry;

  CacheEntry({required this.data, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
  
  Duration get timeToExpiry => expiry.difference(DateTime.now());
}