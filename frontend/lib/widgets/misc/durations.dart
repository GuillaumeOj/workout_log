String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final remainingSeconds = duration.inSeconds % 60;

  if (minutes == 0) {
    return "In $remainingSeconds seconds";
  } else {
    var minutesLabel = minutes > 1 ? "minutes" : "minute";
    var remainingSecondsLabel =
        remainingSeconds > 0 ? " and $remainingSeconds seconds" : "";
    return "In $minutes $minutesLabel$remainingSecondsLabel";
  }
}
