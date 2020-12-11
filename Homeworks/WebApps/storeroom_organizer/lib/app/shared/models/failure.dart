class Failure<T> {
  ///Type of the failure
  final FailureType type;

  ///Customized message to be shown in Frontend, can be from the host response or from this lib
  final String message;

  ///Mostly an Exception the occurred in the process
  final dynamic error;

  ///Parsed response returned object
  final T data;

  Failure({this.type = FailureType.DEFAULT, this.message = 'Ocorreu um erro, tente novamente em alguns minutos', this.error, this.data});
}

enum FailureType {
  ///The default parser action of [Serializable] failed and it's not possible to create [Success]
  PARSER,

  ///Timeout of request or response happened, it was latter than the given in [RequestOptions]
  CONNECTION_TIMEOUT,

  ///Request was successful but the response was an error (ie: code 500, in the http case)
  RESPONSE,

  ///request was cancelled
  CANCEL,

  ///default error type when none of the customized ones is useful
  DEFAULT
}
