import 'package:apex/home%20page%20screens/cart_items.dart';
import 'package:apex/home%20page%20screens/signalRProvider.dart';
import 'package:apex/models/login_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_directory/get_activdis_vatPrice.dart';
import '../api_directory/get_general_setting_vat.dart';
import '../api_directory/get_other_setting.dart';
import '../models/invoice_data_object.dart';
import '../screens/loginpagearabe.dart';
import 'add_user/clint_data_view.dart';
import 'cart_screen.dart';
import 'home_screenpage.dart';
import 'main_screen.dart';

//ignore: must_be_immutable
class WarningMassage extends StatelessWidget {
  String massage;
  int? index;
  bool? insideNewButton=false;
   WarningMassage({super.key, required this.massage ,this.index,this.insideNewButton});
  
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title:const  WaringTitle(),
      content: WaringContent(massage: massage,),
      actions: [
        WaringAction(index: index!,insideNewButton: insideNewButton),
      ],
    );
  }
}
class WaringTitle extends StatelessWidget {
  const WaringTitle({super.key});

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
class WaringContent extends StatelessWidget {
  String massage;
   WaringContent({super.key ,required this.massage});

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
class WaringAction extends StatefulWidget {
  int index;
  bool? insideNewButton=false;
   WaringAction({super.key,required this.index,this.insideNewButton});

  @override
  State<WaringAction> createState() => _WaringActionState();
}

class _WaringActionState extends State<WaringAction> {
  void getGeneralSetting() async{
    var cartProvider = Provider.of<Cart_Items>(context, listen: false);
    if(mounted){
      cartProvider.dataSetting=await getGeneralSettingVat().getGeneralVat();
      cartProvider.settingGeneral.dataSetting = cartProvider.dataSetting;
      if(mounted){
        setState(() {
         // cartProvider.dataSetting = value;
        });
      }
    }

    if(mounted){
      getActDiscountwithVatprice().GetVatActiveDiscount().then((value) {
        if(mounted){
          setState(() {
            cartProvider.dataDisVat = value;
            cartProvider.settingGeneral.dataDisVat=value;
          });
        }

      });
    }

    if(mounted){
      GetOtherSettingApi().getDataOfOtherSetting().then((value) {
        if(mounted){
          setState(() {
            cartProvider.otherSettingData = value;
            cartProvider.settingGeneral.otherSettingData=value;
          });
        }
      });
    }
  }// if any thing happen remove it again
  FToast fToast=FToast();
  @override
  Widget build(BuildContext context) {
    var lang =AppLocalizations.of(context);
    var provider=Provider.of<Cart_Items>(context ,listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // ElevatedButton(
        //   onPressed: ()
        //   style: ElevatedButton.styleFrom(
        //     shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(20.r)),
        //     fixedSize:Provider.of<modelprovider>(context).applocal== Locale('ar')?Size(75.w, 53.h):Size(90.w, 53.h) , //Size.fromWidth(110.w),
        //
        //     backgroundColor: Colors.greenAccent,
        //   ),
        //   child: FittedBox(
        //     fit: BoxFit.cover,
        //     child: Text(
        //       lang!.confirm,
        //       style: TextStyle(
        //           fontSize: 18.sp,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white),
        //     ),
        //   ),
        // ),
        InkWell(
          onTap: () async{
            if(widget.index ==-1){// when the index = -1 that meaning i will delete tha all item of the cart
              getGeneralSetting();
              provider.counterDiscountCheek = 0 ;
              provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
              provider.isDiscountOnItem=false;
              provider.remove_all_items();
              provider.isEdite=false;
              provider.settingGeneral.editeInvoice=false;
              provider.settingGeneral.returnInvoice=false;
              provider.invoiceData=InvoiceData();
              provider.updat();
              if(widget.insideNewButton==false){
                Navigator.of(context).pop();
              }
              else{
                //insideNewButton=false;
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)), (route) => false);
              }

            }
            else if(widget.index >= 0){// the index bigger than 0 mean i deleting item from the cart
              provider.bascet_item[widget.index].itemDisccount=0;
              provider.isEdite=false;
              provider.bascet_item[widget.index].selectedSerialItems.clear();
              provider.remove_item(provider.bascet_item[widget.index]);
              if(provider.counterDiscountCheek >0){
                provider.counterDiscountCheek -- ;
              }
              discountCheck( widget.index, context, fToast);
              if(provider.bascet_item.isEmpty){
                provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
                provider.counterDiscountCheek = 0 ;
                provider.isDiscountOnItem=false;
                provider.settingGeneral.editeInvoice=false;
                provider.settingGeneral.returnInvoice=false;
                provider.returnInvoice=false;
                provider.discount=0.0;
                provider.invoiceData=InvoiceData();
              }

              provider.updat();
              Navigator.of(context).pop();
              //print("the check counter is ${provider.counterDiscountCheek}");
            }
            else if(widget.index == -2){// when index == -2 that meaning i will logging out to login page
              //provider.isEdite=false;
              provider.counterDiscountCheek = 0 ;
              provider.isDiscountOnItem=false;
              provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
              provider.remove_all_items();
              provider.isEdite=false;
              provider.settingGeneral.editeInvoice=false;
              provider.settingGeneral.returnInvoice=false;
              provider.invoiceData=InvoiceData();
              salesManData=LoginData();
              financialTextCheck=LoginData();
              financialAccount=LoginData();
              branchDataDropDown=LoginData();
             mainListForItems=[];
             mainListForCat=[];
               mainListForItems.clear();// make the two glob list empty to did not make the the still save and the new request will happen
              mainListForCat.clear();// make the two glob list empty to did not make the the still save and the new request will happen
              provider.updat();
              var signal= Provider.of<SignalRService>(context,listen: false);
              signal.massage=LoginData();

              SharedPreferences pref = await SharedPreferences.getInstance();// some thing should i do to set the return value in shared preference
              pref.setBool( "isLogin" , false );// in date is 18/10
              await Provider.of<SignalRService>(context,listen: false).stopConnection();
              Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);
            }
          },
          child: Container(
            width: 80.w,
            height: 53.h,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius:  BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                lang!.confirm,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
          child: Container(
            width: 80.w,
            height: 53.h,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius:  BorderRadius.circular(20.r),
            ),
                child: Center(
                  child: Text(
                    lang.cancel,
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}




///         ElevatedButton(
//           onPressed: () async{
//             if(widget.index ==-1){// when the index = -1 that meaning i will delete tha all item of the cart
//               getGeneralSetting();
//               provider.counterDiscountCheek = 0 ;
//               provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
//               provider.isDiscountOnItem=false;
//               provider.remove_all_items();
//               provider.isEdite=false;
//               provider.settingGeneral.editeInvoice=false;
//               provider.invoiceData=InvoiceData();
//               provider.updat();
//               if(widget.insideNewButton==false){
//                 Navigator.of(context).pop();
//               }
//               else{
//                 //insideNewButton=false;
//                 Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)), (route) => false);
//               }
//
//             }
//             else if(widget.index >= 0){// the index bigger than 0 mean i deleting item from the cart
//               provider.bascet_item[widget.index].itemDisccount=0;
//               provider.isEdite=false;
//               provider.bascet_item[widget.index].selectedSerialItems.clear();
//               provider.remove_item(provider.bascet_item[widget.index]);
//               provider.counterDiscountCheek -- ;
//               if(provider.bascet_item.isEmpty){
//                 provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
//                 provider.counterDiscountCheek = 0 ;
//                 provider.isDiscountOnItem=false;
//                 provider.settingGeneral.editeInvoice=false;
//                 provider.discount=0.0;
//                 provider.invoiceData=InvoiceData();
//               }
//               provider.updat();
//               Navigator.of(context).pop();
//               //print("the check counter is ${provider.counterDiscountCheek}");
//             }
//             else if(widget.index == -2){// when index == -2 that meaning i will logging out to login page
//               //provider.isEdite=false;
//               provider.counterDiscountCheek = 0 ;
//               provider.isDiscountOnItem=false;
//               provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
//               provider.remove_all_items();
//               provider.isEdite=false;
//               provider.settingGeneral.editeInvoice=false;
//               provider.invoiceData=InvoiceData();
//               provider.updat();
//              var signal= Provider.of<SignalRService>(context,listen: false);
//               signal.massage=LoginData();
//
//               SharedPreferences pref = await SharedPreferences.getInstance();// some thing should i do to set the return value in shared preference
//               pref.setBool( "isLogin" , false );// in date is 18/10
//               Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.r)),
//             fixedSize:Provider.of<modelprovider>(context).applocal== Locale('ar')?Size(75.w, 53.h):Size(90.w, 53.h) , //Size.fromWidth(110.w),
//
//             backgroundColor: Colors.greenAccent,
//           ),
//           child: FittedBox(
//             fit: BoxFit.cover,
//             child: Text(
//               lang!.confirm,
//               style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//           ),
//         ),

///ElevatedButton(
//           onPressed: (){
//             Navigator.of(context).pop();
//           },
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.r)),
//             fixedSize:Provider.of<modelprovider>(context).applocal== Locale('ar')?Size(75.w, 53.h):Size(90.w, 53.h) , //Size.fromWidth(110.w),
//             backgroundColor: Colors.redAccent,
//           ),
//           child: FittedBox(
//             fit: BoxFit.cover,
//             child: Text(
//               lang.cancel,
//               style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//           ),
//         ),