import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:provider/provider.dart';

import '../../models/finanial_model.dart';
//import 'customer_data_provider.dart';
import 'dialog_for_more_tabe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FinancialData extends StatefulWidget {
   FinancialData({super.key});

  @override
  State<FinancialData> createState() => _FinancialDataState();
}

class _FinancialDataState extends State<FinancialData> with TickerProviderStateMixin{
  TextEditingController creditLimit=TextEditingController();
  TextEditingController creditPeriod=TextEditingController();
  TextEditingController discountRatio=TextEditingController();
  FinancialModel financialModel=FinancialModel();
  FocusNode creditFocusNode=FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>FocusScope.of(context).requestFocus(creditFocusNode));
    //if(mounted){
      //setState(() {
        creditLimit.text=customerDataProvider.financialModel.creditLimit.toString();
        creditPeriod.text= customerDataProvider.financialModel.creditPeriod.toString();
        discountRatio.text=customerDataProvider.financialModel.discountRatio.toString();
      //});
   // }
  }
  //late CustomerDataProvider _customerDataProvider;
  @override
  Widget build(BuildContext context) {
    var lang =AppLocalizations.of(context);
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller:creditLimit ,
          decoration: textDecoration(lang!.creditLimit),
          focusNode: creditFocusNode,
          autofocus: true,
          onChanged: (ch){
            //financialModel.creditLimit=double.parse(creditLimit.text.isEmpty ? "0" : creditLimit.text);
            customerDataProvider.financialModel.creditLimit=int.parse(creditLimit.text.isEmpty ? "0" : creditLimit.text);
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: creditPeriod,
          decoration: textDecoration(lang.creditPeriod),
          onChanged: (ch){
           // financialModel.creditPeriod=double.parse(creditPeriod.text.isEmpty ? "0" : creditPeriod.text);
            customerDataProvider.financialModel.creditPeriod =int.parse(creditPeriod.text.isEmpty ? "0" : creditPeriod.text);
            //if(creditPeriod.text.isEmpty){

            //}
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: discountRatio,
          decoration: textDecoration(lang.discountRatio),
          onChanged: (ch){
            //financialModel.discountRatio=double.parse(ch == null ? "0" : ch);
            customerDataProvider.financialModel.discountRatio=int.parse(ch.isEmpty ? "0" : ch);
          },
        ),
      ],
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    // creditLimit.dispose();
    // creditPeriod.dispose();
    // discountRatio.dispose();
    super.dispose();
  }
}

InputDecoration textDecoration(String hint ,[bool asterisk=false , bool dropdown=false]) {
  return InputDecoration(
    label:asterisk==false? Text(hint) : Row(
      mainAxisSize: MainAxisSize.min,
        children: [
      Text(hint) ,
      Text("*" ,style: TextStyle(color: Colors.red),),
    ],),
      contentPadding: EdgeInsets.symmetric(vertical: 6.0.h ,horizontal: 7.w),
      //hintText: hint,
      filled: true,
      fillColor: Colors.white70,
      prefixIcon:dropdown ==true? Icon(Icons.arrow_drop_down) : null ,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black26),
        borderRadius: BorderRadius.circular(7.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.w),
        borderRadius: BorderRadius.circular(7.r),
      ));
}