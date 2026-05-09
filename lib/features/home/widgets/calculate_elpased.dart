Duration calculateElapsed({
  required DateTime startTime,
  required String? selectedType,
  required Duration totalDuration,
}) {
  final diff = DateTime.now().difference(startTime);

  if (selectedType == "open") {
    return diff;
  } else {
    final remaining = totalDuration - diff;
    return remaining.isNegative ? Duration.zero : remaining;
  }
}