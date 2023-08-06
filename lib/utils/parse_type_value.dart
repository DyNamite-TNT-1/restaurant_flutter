class ParseTypeData {
  ParseTypeData._();

  static String ensureString(dynamic input) {
    if (input is String) {
      return input;
    }
    return "${input ?? ""}";
  }

  static String ensureStringDef(dynamic input, String def) {
    if (input is String) {
      return input;
    }
    return "${input ?? def}";
  }

  static int ensureInt(dynamic input) {
    if (input is int) {
      return input;
    }

    if (input is double) {
      return input.toInt();
    }

    if (input == null || input == "") {
      return 0;
    }

    return int.tryParse(input) ?? 0;
  }

  static double ensureDouble(dynamic input) {
    if (input is double) {
      return input;
    }
    if (input is int) {
      return input.toDouble();
    }
    if (input == null || input == "") {
      return 0;
    }

    return double.tryParse(input) ?? 0;
  }

  static double ensureDoubleDef(dynamic input, double def) {
    if (input is double) {
      return input;
    }

    if (input is int) {
      return input.toDouble();
    }

    if (input == null || input == "") {
      return def;
    }

    return double.tryParse(input) ?? 0;
  }

  static int ensureIntDef(dynamic input, int def) {
    if (input is int) {
      return input;
    }

    if (input is double) {
      return input.toInt();
    }

    if (input == null || input == "") {
      return def;
    }

    return int.tryParse(input) ?? def;
  }

  static bool ensureBool(dynamic input) {
    if (input is bool) {
      return input;
    }

    if (input is int || input is double) {
      return input > 0;
    }

    return input == "true" || input == "y";
  }

  static bool ensureBoolDef(dynamic input, bool def) {
    if (input is bool) {
      return input;
    }

    if (input == null || input == "") {
      return def;
    }

    if (input is int || input is double) {
      return input > 0;
    }

    return input == "true" || input == "y";
  }

  static DateTime ensureDateTime(String? input) {
    return input != null ? DateTime.parse(input) : DateTime.now();
  }

  static DateTime ensureDateTimeUTC(String? input) {
    if (input != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(input) * 1000,
          isUtc: true);
    }
    return DateTime.now();
  }

  static DateTime ensureDateTimeUTCDef(String? input, DateTime def) {
    if (input != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(input) * 1000,
          isUtc: true);
    }
    return def;
  }
}
