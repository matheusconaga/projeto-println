String formatTime(DateTime createdAt) {

  final now = DateTime.now();
  final diff = now.difference(createdAt);

  if (diff.inSeconds < 60) {
    return "agora";
  }

  if (diff.inMinutes < 60) {
    return "${diff.inMinutes}m";
  }

  if (diff.inHours < 24) {

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (minutes == 0) {
      return "${hours}h";
    }

    return "${hours}h ${minutes}m";
  }

  if (diff.inDays == 1) {
    return "ontem";
  }

  if (diff.inDays < 7) {
    return "${diff.inDays}d";
  }

  return "${createdAt.day}/${createdAt.month}";
}