import 'package:apex/home%20page%20screens/cart_items.dart';
import 'package:apex/home%20page%20screens/signalRProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/invoice_data_object.dart';
import '../screens/loginpagearabe.dart';
import 'home_screenpage.dart';

//ignore: must_be_immutable
class SessionPopUp extends StatelessWidget {
  String massage;
  BuildContext newContext ;
  SessionPopUp({super.key, required this.massage,required this.newContext });


  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title:const  WaringTitleSession(),
      content: WaringContentSession(massage: massage,),
      actions: [
        WaringActionSession(newContext: newContext),
      ],
    );
  }
}
class WaringTitleSession extends StatelessWidget {
  const WaringTitleSession({super.key});

  @override
  Widget build(BuildContext context) {
    var lang =AppLocalizations.of(context);
    //var provider=Provider.of<Cart_Items>(context ,listen: false);
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(lang!.warning.toString()),
        SizedBox(
          width: MediaQuery.of(context).size.width/19,
        ),
        const FittedBox(
            fit: BoxFit.contain,
            child: Icon(Icons.warning ,size: 33,color: Colors.amber,))
      ],);
  }
}
//ignore: must_be_immutable
class WaringContentSession extends StatelessWidget {
  String massage;
  WaringContentSession({super.key ,required this.massage});

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: Text(massage ,style: TextStyle(fontSize: 15.sp ,color: Colors.black ,fontWeight: FontWeight.bold),)),
      ],
    );
  }
}
//ignore: must_be_immutable
class WaringActionSession extends StatelessWidget {
  //int index;
  BuildContext newContext;
  WaringActionSession({super.key ,required this.newContext});

  @override
  Widget build(BuildContext context) {
    var lang =AppLocalizations.of(context);
    var provider=Provider.of<Cart_Items>(context ,listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        ElevatedButton(
          onPressed: ()async{
          //  getGeneralSetting();
             mainListForItems=[];
             mainListForCat=[];
            provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
            provider.counterDiscountCheek = 0 ;
            provider.isDiscountOnItem=false;
            provider.remove_all_items();
            provider.isEdite=false;
            provider.settingGeneral.editeInvoice=false;
            provider.settingGeneral.returnInvoice=false;
            provider.returnInvoice=false;
            provider.invoiceData=InvoiceData();
            provider.updat();
           await Provider.of<SignalRService>(context,listen: false).stopConnection();
            // Navigator.pushNamedAndRemoveUntil(context, Arab_login.rout, (route) => false);
            // Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);
             Navigator.pushNamedAndRemoveUntil(context,Arab_login.rout, (route) => false);
            //Navigator.of(newContext).pop();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
            fixedSize:Size(75.w, 53.h) , //Size.fromWidth(110.w),
            backgroundColor: Colors.blueAccent,
          ),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text(
              lang!.confirm,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class ToShowPopUpTest{
  toShowPopUpTest(BuildContext context , String massage){
      showDialog
        (context: context, builder: (context)=>SessionPopUp( newContext: context,massage: massage,) );
  }
}

