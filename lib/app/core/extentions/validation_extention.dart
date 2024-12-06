extension ValidationExt on String {
  String? get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (isEmpty) {
      return ("يرجى إدخال البريد الإلكتروني");
    } else if (!emailRegExp.hasMatch(this)) {
      return ("يرجى إدخال بريد إلكتروني صحيح");
    } else {
      return null;
    }
  }

  String? get isValidPassword {
    if (isEmpty) {
      return ("يرجى إدخال كلمة المرور");
    } else if (length < 8) {
      return ("كلمة المرور يجب ان تحتوي على أكثر من 8 حروف ");
    }else {
      return null;
    }
  }

  String? get isValidName {
    if (isEmpty) {
      return ("Name is required");
    } else {
      return null;
    }

  }




  String? get isValidPhone {
    final phoneRegExp = RegExp(r'^\+?\d{10,15}$');
    if (isEmpty) {
      return ("Phone number is required");
    } else if (!phoneRegExp.hasMatch(this)) {
      return ("Enter a valid phone number");
    } else {
      return null;
    }
  }
}