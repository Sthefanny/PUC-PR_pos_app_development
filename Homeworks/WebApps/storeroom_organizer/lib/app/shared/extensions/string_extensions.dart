extension StringExtension on String {
  bool isNotNullOrEmpty() {
    return this != null && this.isNotEmpty;
  }

  bool isNullOrEmpty() {
    return this == null || this.isEmpty;
  }
}
