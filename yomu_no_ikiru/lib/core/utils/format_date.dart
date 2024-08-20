import 'package:intl/intl.dart';

String formatDateBydMMMYYYY(DateTime date) {
  return DateFormat("d/MM/yy").format(date);
}
