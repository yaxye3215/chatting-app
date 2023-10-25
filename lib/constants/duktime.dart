import 'package:intl/intl.dart';

String duTimeLineFormat(DateTime dt) {
  var now = DateTime.now();
  var difference = now.difference(dt);

  if (difference.inMinutes < 60) {
    return "${difference.inMinutes} m ago";
  }

  if (difference.inHours < 24) {
    return "${difference.inHours} h ago";
  } else if (difference.inDays < 30) {
    return "${difference.inDays} d ago";
  } else if (difference.inDays < 365) {
    final dtFormat = DateFormat.yMd();

    return dtFormat.format(dt);
  } else {
    final dtFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var str = dtFormat.format(dt);
    return str;
  }
}
