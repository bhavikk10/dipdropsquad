/// Compact counts for likes / comments (e.g. 1200 → 1.2k).
String formatEngagementCount(int n) {
  if (n >= 1000000) {
    final m = n / 1000000;
    final t = m == m.roundToDouble() ? m.toInt().toString() : m.toStringAsFixed(1);
    return '${t}m';
  }
  if (n >= 1000) {
    final k = n / 1000;
    final t = (k * 10).round() / 10;
    final s = t == t.roundToDouble() ? t.toInt().toString() : t.toStringAsFixed(1);
    return '${s}k';
  }
  return '$n';
}

String captionUserHandle(String caption) {
  final i = caption.indexOf(' ');
  if (i <= 0) return caption;
  return caption.substring(0, i);
}

String captionBodyAfterUser(String caption) {
  final i = caption.indexOf(' ');
  if (i <= 0) return '';
  return caption.substring(i + 1);
}

String timeAgoUpper(String timeAgo) => timeAgo.toUpperCase();
