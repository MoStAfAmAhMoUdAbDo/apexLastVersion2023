import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MyTextForm extends StatelessWidget {
  final String hint;
  final String excep;

  final TextEditingController control ;
  const MyTextForm({super.key, required this.hint ,required this.excep ,required this.control});


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: control,
      decoration: InputDecoration(
        hintText: hint ,
        hintStyle: TextStyle(
          fontSize: 10.sp,
        ),
        enabledBorder:const  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue ,width:  0.6.w),
        ),
        errorBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red ,width:  0.6.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade300 ,width: 0.6.w),
        ),
        errorStyle:  TextStyle(fontSize: 15.sp),

      ),
      validator: (val){
        if(val!.isEmpty){
          return "\u26A0 ${AppLocalizations.of(context)?.pleaseenter} $excep";
        }
        else{
          return null ;
        }

      },


    );
  }
}
