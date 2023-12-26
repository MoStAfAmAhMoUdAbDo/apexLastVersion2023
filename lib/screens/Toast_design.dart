import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastDesign extends StatelessWidget {
  String massage;
  bool failedData;
  String backPress;
  ToastDesign({super.key, required this.massage, required this.failedData , required this.backPress});

  @override
  Widget build(BuildContext context) {
    if (failedData == true) { // when data is succeed
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.greenAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: const Icon(Icons.check)),
            Flexible(
              child:  SizedBox(
                width: 12.0.w,
              ),
            ),
            Flexible(
              flex: 3,
                child: Text(massage)),
          ],
        ),
      );
    } else if (backPress!="" && backPress=="back"){ // when want log out the app when press back button
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.grey,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                flex: 8,
                child: Text(massage ,style: TextStyle(color:  Colors.black),)),
          ],
        ),
      );
    }
    else {
      return Container( // when want to show waring massage
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.redAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: const Icon(
                Icons.dangerous_outlined,
              ),
            ),
            Flexible(
              child:  SizedBox(
                width: 12.0.w,
              ),
            ),
            Flexible(
              flex: 8,
                child: Text(massage ,)),
          ],
        ),
      );
    }
  }
}
