import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String msg, Toast toastLength = Toast.LENGTH_SHORT, int timeInSec = 2}) {
  Fluttertoast.showToast(
      msg: msg, toastLength: toastLength, timeInSecForIosWeb: timeInSec, gravity: ToastGravity.CENTER);
}
