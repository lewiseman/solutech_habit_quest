String? passwordValidation(String? password) {
  final isLengthOk = (password?.length ?? 0) >= 8;

  if (!isLengthOk) {
    return 'Password must have at least 8 characters';
  }
  return null;
}

String? emptyValidation(String? value, [String? fieldName]) {
  if (value == null || value.isEmpty) {
    return '${fieldName ?? 'Field'} cannot be empty';
  }
  return null;
}

String? emailValidation(String? value) {
  if (value!.isEmpty || !value.contains('@')) {
    return 'Please enter a valid email';
  }

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,9}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email address.';
  }

  return null;
}
