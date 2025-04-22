class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  ApiException(this.message, [this.statusCode, this.details]);

  @override
  String toString() => 'ApiException: $message'
      '${statusCode != null ? ' (Status $statusCode)' : ''}'
      '${details != null ? '\nDetails: $details' : ''}';
}