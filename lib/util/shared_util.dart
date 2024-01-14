import 'package:intl/intl.dart';

class PriceUtil {
  double calculateTotalCost(
      int perKmOfFare,
      int perMinOfFare,
      int initialFare,
      int upPerKmOfFare,
      int extraFare,
      int lowestFare,
      double distanceInMeters,
      int timeInSeconds) {

    double totalCost;
    if (distanceInMeters / 1000 >= upPerKmOfFare) {
      totalCost = (distanceInMeters / 1000 - upPerKmOfFare) * distanceInMeters +
          upPerKmOfFare * perKmOfFare +
          timeInSeconds / 60.0 * perKmOfFare +
          initialFare + extraFare;
    } else {
      totalCost =
          distanceInMeters / 1000 * perKmOfFare + timeInSeconds / 60.0 * distanceInMeters + extraFare + lowestFare;
    }

    if (totalCost <= lowestFare) {
      totalCost = lowestFare.toDouble();
    }

    return totalCost;
  }
}

class DateUtil {
  List<String> generateYearList() {
    int currentYear = DateTime.now().year;
    List<String> years = [];

    for (int i = currentYear; i >= currentYear - 23; i--) {
      years.insert(0,'$i年');
    }

    return years;
  }

  String getDate(String dateString)
  {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('M-d HH:mm(E)', 'zh').format(dateTime.toLocal());
    formattedDate = formattedDate.replaceAll("周", "週");
    return formattedDate;
  }

  String getDateYear(String dateString)
  {
    DateTime dateTime = DateTime.parse(dateString);

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    print(formattedDate); // Output: 12-11 13:33 (Mon)
    return formattedDate;
  }
}