class CulqiUnknownException implements Exception {
  
  String cause;
  String detail;

  CulqiUnknownException(this.cause, this.detail);

}