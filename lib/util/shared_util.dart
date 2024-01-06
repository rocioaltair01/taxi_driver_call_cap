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
    print("kdjc;");
    totalCost =
        distanceInMeters / 1000 * perKmOfFare + timeInSeconds / 60.0 * distanceInMeters + extraFare + lowestFare;
  }

  if (totalCost <= lowestFare) {
    totalCost = lowestFare.toDouble();
  }

  return totalCost;
}