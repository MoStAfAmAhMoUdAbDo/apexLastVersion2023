
import 'package:fluttertoast/fluttertoast.dart';
import '../screens/Toast_design.dart';
class MassageForToast{

  void massageForAlert(String massage ,bool failedData ,FToast fToast ,[String backPress =""]){

    fToast.showToast(
      child: ToastDesign(massage: massage,failedData:failedData , backPress: backPress, ),
      gravity:backPress=="back" ?ToastGravity.BOTTOM: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
    //fToast.removeCustomToast();
  }

}


