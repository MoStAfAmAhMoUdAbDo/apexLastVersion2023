import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordText extends StatefulWidget {
final String hint ;
final bool obsecur;
final TextEditingController control;
  const PasswordText({super.key, required this.hint,required this.obsecur ,required this.control});
  @override
  State<PasswordText> createState() => _PasswordTextState();
}
class _PasswordTextState extends State<PasswordText> {

  var jhint ;
  var obsecured=true ;
  //_PasswordTextState(this.hint);
  @override
  void initState(){
    super.initState();
    setState(() {
      jhint = widget.hint;
      obsecured =widget.obsecur;
    });
  }

  //_PasswordTextState({this.obsecured});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.control,
      obscureText: obsecured,
      decoration: InputDecoration(
        //hintText: 'Password' ,
        hintText: widget.hint,
        hintStyle: TextStyle(
          fontSize: 10.sp,
        ),
        enabledBorder:const  OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue ,width:  0.6.w),

        ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red ,width:  0.6.w),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade300 ,width:  0.6.w),
          ),
          errorStyle: TextStyle(fontSize: 15.sp),
        suffixIcon: IconButton(
          icon: obsecured ? const Icon(Icons.visibility): const Icon(Icons.visibility_off),
          onPressed: (){
            setState(() {
              obsecured=! obsecured;
            });
          },
        )
      ),

      // this male validation and i will add string variable and replace it with ''
      //and add the global key in the main form
      validator: (val){
        if(val!.isEmpty){
          return "\u26A0 ${AppLocalizations.of(context)?.pleaseenter} ${AppLocalizations.of(context)?.password}";
        }
        else{
          return null ;
        }
      },
    );
  }
}
