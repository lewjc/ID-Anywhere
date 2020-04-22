class ServiceResult{
  ServiceResult({List<String> errors}) : errors = errors ?? [];

  List<String> errors = [];

  bool valid () => this.errors.isEmpty;

  bool unauthorised = false;
}