class DefaultResponse<T> {
  ///Parsed response returned object
  final T failure;
  final T success;

  DefaultResponse({this.failure, this.success});
}
