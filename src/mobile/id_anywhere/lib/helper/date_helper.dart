class DateHelper {
  static int parseMonth(String month) {
    switch (month.toLowerCase()) {
      case "jan":
        return 1;
      case "feb":
        return 2;
      case "mar":
        return 3;
      case "apr":
        return 4;
      case "may":
        return 5;
      case "jun":
        return 6;
      case "jul":
        return 7;
      case "aug":
        return 8;
      case "sep":
        return 9;
      case "oct":
        return 10;
      case "nov":
        return 11;
      case "dec":
        return 12;
      default:
        return 0;
    }
  }

  static DateTime parseLicenseDate(String dateString){
    List<int> dateInfo = dateString
        .split(".")
        .map((x) => int.parse(x))
        .toList();
    // Format the date of birth
    if (dateInfo.length == 3) {
      return DateTime(dateInfo[2], dateInfo[1], dateInfo[0]).add(Duration(hours: 6));
    } else {
      return null;
    }
  }
}
