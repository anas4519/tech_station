class ServerException implements Exception {
  final String message;
  const ServerException([
    this.message = 'An unexpected server error occurred.',
  ]);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication failed.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error occurred.']);
}
