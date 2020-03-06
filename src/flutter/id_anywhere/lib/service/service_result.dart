class ServiceResult{
  ServiceResult({this.errors=const[]});

  List<dynamic> errors = [];

  bool valid () => this.errors.isEmpty;

  bool unauthorised = false;
}