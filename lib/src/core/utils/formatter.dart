class Formatter {
  String formatIqd(double value) {
    final intValue = value.toInt();
    final str = intValue.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      final pos = str.length - i;
      buffer.write(str[i]);
      if (pos > 1 && pos % 3 == 1) buffer.write(',');
    }

    return '${buffer.toString()} IQD';
  }
}
