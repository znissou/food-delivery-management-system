class ApiResponse<T> {
  T? data;
  String? error;
  bool get hasError => error != null;

  ApiResponse.success(this.data) : error = null;
  ApiResponse.error(this.error) : data = null;
}
