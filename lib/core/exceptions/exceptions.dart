/// CustomException to passing a custom error message in Exception

class CustomException implements Exception {
  String errorMessage = "Please check your Internet connection.";

  CustomException(this.errorMessage);
}
