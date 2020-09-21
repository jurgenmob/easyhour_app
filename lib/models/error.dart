class ErrorResponse {
  String entityName;
  String errorKey;
  String type;
  String title;
  int status;
  String message;
  String detail;
  String params;

  ErrorResponse(
      {this.entityName,
      this.errorKey,
      this.type,
      this.title,
      this.status,
      this.message,
      this.detail,
      this.params});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    entityName = json['entityName'];
    errorKey = json['errorKey'];
    type = json['type'];
    title = json['title'];
    status = json['status'];
    message = json['message'];
    detail = json['detail'];
    params = json['params'];
  }

  @override
  String toString() => title + (detail?.isNotEmpty ?? false ? ": $detail" : "");
}
