extension IntExt on int {
  String formatDuration() {
    final hours = this ~/ 3600;
    final minutes = (this % 3600) ~/ 60;
    final remainingSeconds = this % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String formatBytes() {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)} KB';
    if (this < 1024 * 1024 * 1024)
      return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

extension StringExt on String {
  String formatBytes() {
    final intValue = int.tryParse(this);
    if (intValue == null) return this;
    return intValue.formatBytes();
  }
}
