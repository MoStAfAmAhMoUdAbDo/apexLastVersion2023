import 'package:apex/home%20page%20screens/payment_option/sending_payment_toApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:apex/home%20page%20screens/cart_items.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../costants/color.dart';
import '../../model.dart';
import '../../models/invoice_data_object.dart';
import '../../models/login_data.dart';
import '../basic_printer.dart';
import '../home_screenpage.dart';
import '../main_screen.dart';
import '../massage_toast.dart';
import '../menu_provider.dart';
import '../round_number.dart';
import '../session_popup.dart';
import '../signalRProvider.dart';

class CreditCardPaymentMethod extends StatelessWidget {
  const CreditCardPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    var provider = Provider.of<Cart_Items>(context);

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: basicColor),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 29,
            ),
          ),
          title: Text(
            lang!.checkout,
            style: TextStyle(
                fontSize: 27.sp,
                fontWeight: FontWeight.bold,
                color: basicColor),
          ),
        ),
        body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height / 13,
              color: basicColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 13, left: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                     // fit: BoxFit.contain,
                      child: Text(
                        lang.netPaymentAmount,
                        //logo name
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Flexible(
                      //fit: BoxFit.contain,
                      child: Text(
                        provider.getTotals(false).net.toString(),
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(top: 8.0),
              child:  Center(child: ContainerWithAnimation()),
            )
          ],
        )
    );
  }
}
class ContainerWithAnimation extends StatefulWidget {
  const ContainerWithAnimation({super.key});

  @override
  State<ContainerWithAnimation> createState() => _ContainerWithAnimationState();
}

class _ContainerWithAnimationState extends State<ContainerWithAnimation> {
  double height=0;
  double width=0;
  double remainPayment=0.0;
  bool focus =true;
  int count =0;
  TextEditingController creditPayment=TextEditingController();
  FToast fToast=FToast();
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }

  }
  @override
  void initState() {
    super.initState();
    fToast.init(context);
    signalRContext=context;
    // Rebuild the screen after 3s which will process the animation from green to blue
    Future.delayed(const Duration(milliseconds: 100)).then((value) => setState(() {
      //height=MediaQuery.of(context).size.height / 2;
      width=MediaQuery.of(context).size.width;
    }));
  }
  @override
  Widget build(BuildContext context) {


    var lang =AppLocalizations.of(context);
    var provider =Provider.of<Cart_Items>(context);
    var langType=Provider.of<modelprovider>(context).applocal;
    creditPayment.text =provider.getTotals(false).net.toString();
    creditPayment.selection =  TextSelection(
      baseOffset: 0,
      extentOffset: provider.getTotals(false).net.toString().length,
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: width,
      height:MediaQuery.of(context).size.height / 2.33,
      color: Colors.white,
      curve: Curves.decelerate,
      child: StatefulBuilder(
          builder: (context, myState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    height: 67.h,
                    decoration:BoxDecoration(
                        border: Border.all(width: 0.7,color: Colors.grey)
                    ) ,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0,left: 8),
                            child: Text(lang!.deserved,style: TextStyle(fontSize: 27.sp ,color: Colors.red,fontWeight: FontWeight.bold),),
                          ),
                        )),
                        Flexible(child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(provider.getTotals(false).net.toString(),style: TextStyle(fontSize: 22.sp ,fontWeight: FontWeight.bold),),
                          ),
                        )),

                      ],
                    ),
                    // ListTile(
                    //   leading: Text(lang.deserved,style: TextStyle(fontSize: 27.sp ,color: Colors.red,fontWeight: FontWeight.bold),),
                    //   trailing: Text(provider.getTotals(false).net.toString()),
                    // ),
                  ),
                ),

                Flexible(
                  child: Container(
                    height: 67.h,
                    decoration:const BoxDecoration(
                        border: Border.symmetric(horizontal: BorderSide(width: 0.7,color: Colors.grey))
                    ) ,
                    child: Row(
                      children: [
                        // SizedBox(
                        //   width: 13.w,
                        // ),
                        Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                  child: Text(lang.paid,style: TextStyle(fontSize: 27.sp ,color: Colors.green,fontWeight: FontWeight.bold),)),
                            )),
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: 28.w,
                          ),
                        ),
                        Flexible(
                          flex: 8,
                          child: SizedBox(
                            height :36.h,
                            child:GestureDetector(
                              onDoubleTap: (){
                                creditPayment.text=provider.getTotals(false).net.toString();
                                creditPayment.selection = TextSelection(baseOffset: 0, extentOffset:creditPayment.text.length);
                                String monetaryPayment =creditPayment.text.isEmpty ? "0" : creditPayment.text;
                                remainPayment =provider.getTotals(false).net! - double.parse(monetaryPayment) ;
                                myState((){});
                              },
                              child: TextFormField(
                                controller: creditPayment,
                                style: TextStyle(fontSize: 16.sp),

                                textAlign:Provider.of<modelprovider>(context,listen: false).applocal ==const Locale('en')? TextAlign.right : TextAlign.left,
                                textDirection:TextDirection.ltr ,
                                decoration: textFieldStyleDiscount(),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  // FilteringTextInputFormatter.allow(RegExp(r'^\-?\d+\.?\d*')),
                                  // //FilteringTextInputFormatter.digitsOnly,
                                  // LengthLimitingTextInputFormatter(6),
                                  DecimalTextInputFormatter(decimalRange: provider.settingGeneral.roundNumG!),
                                  FilteringTextInputFormatter.allow(RegExp(r'^[\d,.]*$')),
                                ],
                                //mouseCursor:MouseCursor.uncontrolled ,
                                autofocus: focus,
                                onChanged: (value){
                                  myState(() {
                                    //print("value is $value");
                                    if (value.startsWith('.') && !value.contains('0.')) {
                                      creditPayment.text = '0$value';
                                    }
                                    focus=false;
                                    String monetaryPayment =creditPayment.text.isEmpty ? "0" : creditPayment.text;
                                    remainPayment =provider.getTotals(false).net! -  double.parse(monetaryPayment) ;
                                  });
                                },

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 100.h,
                    decoration:BoxDecoration(
                        border: Border.all(width: 0.7,color: Colors.grey)
                    ) ,
                    child:    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                              fit:BoxFit.contain,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0 ,left: 8.0),
                                child: Text(lang.remain,style: TextStyle(fontSize: 27.sp ,color: Colors.black,fontWeight: FontWeight.bold),),
                              )),
                        ),
                        Flexible(
                          child: FittedBox(
                              fit:BoxFit.contain,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(provider.roundDouble(remainPayment, provider.settingGeneral.roundNumG!).toString(),style: TextStyle(fontSize: 16.sp ,fontWeight: FontWeight.bold),),
                              )),
                        ),

                      ],
                    ),

                    // ListTile(
                    //   leading: Text(lang.remain,style: TextStyle(fontSize: 27.sp ,color: Colors.black,fontWeight: FontWeight.bold),),
                    //   trailing: Text(remainPayment.toString()),
                    // ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child:  keyboard(myState),
                ),
                Flexible(
                  child: InkWell(
                    onTap: ()async{
                      double payment=creditPayment.text.isNotEmpty? double.parse(creditPayment.text) : 0.0;
                      PaymentsMethods paymentMethod=PaymentsMethods();
                      paymentMethod.paymentMethodId=home_screen.paymentMethodList[1].paymentMethodId;
                      paymentMethod.value =payment;
                      List<PaymentsMethods> paymentMethods = [];
                      paymentMethods.add(paymentMethod);
                      showDialog(
                          barrierDismissible: false,
                          context: context, builder: (context){
                        // ignore: deprecated_member_use
                        return WillPopScope(
                            onWillPop: ()async {return false;  },
                            child: const Center(child: CircularProgressIndicator(),));
                      });
                      LoginData res=await SendPaymentMethods().sendingInvoiceDataToApi(context, payment, false, paymentMethods);

                      if(res.result ==1){
                        if(res.isPrint !=null)
                        {
                          MassageForToast().massageForAlert(lang.invoiceSavedSuccessfully,true,fToast);
                          if(Navigator.canPop(context)){
                            Navigator.of(context).pop();
                          }

                        }
                        else if(res.resultForPrint != null && res.resultForPrint==1)
                        {
                          //bool isArabic = Provider.of<modelprovider>(context,listen: false).applocal ==Locale("ar")? true :false;
                         // PrintingInvoices().printingInvoice(provider.invoiceData.invoiceId!, provider.invoiceData.invoiceCode!, isArabic, fToast,context);
                          await PrintingInvoices().printingFun(res.fileUrl!);

                          if(Navigator.canPop(context)){
                            Navigator.of(context).pop();
                          }
                        }

                        else if(res.resultForPrint!=null && res.resultForPrint ==30)
                        {
                          MassageForToast().massageForAlert(lang.noPermissionPrint,false,fToast);
                          if(Navigator.canPop(context)){
                            Navigator.of(context).pop();
                          }
                        }

                        // MassageForToast().massageForAlert(lang.invoiceSavedSuccessfully,true,fToast);
                        provider.counterDiscountCheek = 0 ;
                        provider.isDiscountOnItem=false;
                        provider.isEdite=false;
                        provider.settingGeneral.editeInvoice=false;
                        provider.settingGeneral.returnInvoice=false;
                        provider.settingGeneral.returnInvoice=false;
                        provider.returnInvoice=false;
                        provider.invoiceData = InvoiceData();
                        //provider.invoiceData=InvoiceData();
                        provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
                        Provider.of<menuProviderOptions>(context,listen: false).setNotes("");
                        provider.remove_all_items();
                        provider.updat();
                        if(Navigator.canPop(context)){
                          // Navigator.of(context).popUntil(ModalRoute.withName(Main_Screen.rout));
                          Navigator.of(context).pushNamedAndRemoveUntil(Main_Screen.rout, (route) => false);
                        }

                      }
                      else if(res.result==0 &&res.statusCode !=null&& res.statusCode !=401){
                        String massage=langType==const Locale('en') ? res.errorMassageEn! :res.errorMassageAr!;
                        MassageForToast().massageForAlert(massage,false,fToast);

                        if(Navigator.canPop(context)){
                          Navigator.of(context).pop();
                        }
                      }
                      else if (res.statusCode ==401){
                        String massage=Provider.of<modelprovider>(context,listen: false).applocal == const Locale("ar") ? res.errorMassageAr! :res.errorMassageEn!;
                        showDialog(
                          barrierDismissible: false,
                            context: context, builder:(context)=> WillPopScope(onWillPop: ()async { return false; },
                        child: SessionPopUp(massage: massage,newContext: context,)));
                       // Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);
                      }
                      else if(res.socketError!=null){
                        MassageForToast().massageForAlert(res.socketError.toString(),false,fToast);
                        // MassageForToast().massageForAlert(lang.failedSaveInvoice,false,fToast);
                        if(Navigator.canPop(context)){
                          Navigator.of(context).pop();
                        }
                      }
                      else{
                        if(res.errorMassageEn == null || res.errorMassageAr==null || res.result== null){
                          MassageForToast().massageForAlert(lang.thereProblemInvoiceSaved,false,fToast);
                          if(Navigator.canPop(context)){
                            Navigator.of(context).pop();
                          }
                        }
                        else{
                          String massage=langType==const Locale('en') ? res.errorMassageEn! :res.errorMassageAr!;
                          MassageForToast().massageForAlert(massage,false,fToast);
                          // MassageForToast().massageForAlert(lang.failedSaveInvoice,false,fToast);
                          if(Navigator.canPop(context)){
                            Navigator.of(context).pop();
                          }
                        }
                        // String massage=langType==const Locale('en') ? res.errorMassageEn! :res.errorMassageAr!;
                        // MassageForToast().massageForAlert(massage,false,fToast);
                        // // MassageForToast().massageForAlert(lang.failedSaveInvoice,false,fToast);
                        // if(Navigator.canPop(context)){
                        //   Navigator.of(context).pop();
                        // }
                      }
                    },
                    child: Container(
                        color: const Color.fromARGB(255, 21, 138, 21),
                        //
                        width: double.infinity,
                        child:Center(
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(child: Image.asset("images/money.png")),
                                SizedBox(
                                  width: 18.w,
                                ),
                                Flexible(child: FittedBox(
                                  fit: BoxFit.contain,
                                    child: Text(lang.pay,style: TextStyle(fontSize: 27.sp ,color: Colors.white,fontWeight: FontWeight.bold)))),
                              ],
                            )) ),
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
  Widget keyboard(void Function(void Function()) myState){
    var provider =Provider.of<Cart_Items>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height:MediaQuery.of(context).size.height/20 ,
                width: MediaQuery.of(context).size.width/3.2,
                decoration:BoxDecoration(
                  border: Border.all(width: 0.7,color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ) ,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0
                    ),
                    onPressed: (){
                      if(focus==true){
                        creditPayment.clear();
                        focus=false;
                      }
                      creditPayment.text += "5";
                      creditPayment.selection = TextSelection.collapsed(offset: creditPayment.text.length);
                      remainPayment =provider.getTotals(false).net! - double.parse(creditPayment.text) ;
                      myState((){});
                    }, child: Text("5",style: TextStyle(fontSize:20.sp ,color: Colors.black),)),
              ),
            ),
            Flexible(
              child: Container(
                height:MediaQuery.of(context).size.height/20 ,
                width: MediaQuery.of(context).size.width/3.2,
                decoration:BoxDecoration(
                  border: Border.all(width: 0.7,color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ) ,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0
                    ),
                    onPressed: (){
                      if(focus==true){
                        creditPayment.clear();
                        focus=false;
                      }
                      creditPayment.text += "10";
                      creditPayment.selection = TextSelection.collapsed(offset: creditPayment.text.length);
                      remainPayment =provider.getTotals(false).net! - double.parse(creditPayment.text) ;
                      myState((){});
                    }, child: Text("10",style: TextStyle(fontSize:20.sp ,color: Colors.black),)),
              ),
            ),
            Flexible(
              child: Container(
                height:MediaQuery.of(context).size.height/20 ,
                width: MediaQuery.of(context).size.width/3.2,
                decoration:BoxDecoration(
                  border: Border.all(width: 0.7,color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ) ,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0
                    ),
                    onPressed: (){
                      if(focus==true){
                        creditPayment.clear();
                        focus=false;
                      }
                      creditPayment.text += "50";
                      creditPayment.selection = TextSelection.collapsed(offset: creditPayment.text.length);
                      remainPayment =provider.getTotals(false).net! - double.parse(creditPayment.text) ;
                      myState((){});
                    }, child: Text("50",style: TextStyle(fontSize:20.sp ,color: Colors.black),)),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(

              child: Container(
                height:MediaQuery.of(context).size.height/20 ,
                width: MediaQuery.of(context).size.width/3.2,
                decoration:BoxDecoration(
                  border: Border.all(width: 0.7,color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ) ,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0
                    ),
                    onPressed: (){
                      if(focus==true){
                        creditPayment.clear();
                        focus=false;
                      }
                      creditPayment.text += "100";
                      creditPayment.selection = TextSelection.collapsed(offset: creditPayment.text.length);
                      remainPayment =provider.getTotals(false).net! - double.parse(creditPayment.text) ;
                      myState((){});
                    }, child: Text("100",style: TextStyle(fontSize:20.sp ,color: Colors.black),)),
              ),
            ),
            Flexible(
              child: Container(
                height:MediaQuery.of(context).size.height/20 ,
                width: MediaQuery.of(context).size.width/3.2,
                decoration:BoxDecoration(
                  border: Border.all(width: 0.7,color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ) ,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0
                    ),
                    onPressed: (){
                      if(focus==true){
                        creditPayment.clear();
                        focus=false;
                      }
                      creditPayment.text += "200";
                      creditPayment.selection = TextSelection.collapsed(offset: creditPayment.text.length);
                      remainPayment =provider.getTotals(false).net! - double.parse(creditPayment.text) ;
                      myState((){});
                    }, child: Text("200",style: TextStyle(fontSize:20.sp ,color: Colors.black),)),
              ),
            ),
            Flexible(
              child: Container(
                height:MediaQuery.of(context).size.height/20 ,
                width: MediaQuery.of(context).size.width/3.2,
                decoration:BoxDecoration(
                  border: Border.all(width: 0.7,color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ) ,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0
                    ),
                    onPressed: (){
                      if(focus==true){
                        creditPayment.clear();
                        focus=false;
                      }
                      creditPayment.text += "300";
                      creditPayment.selection = TextSelection.collapsed(offset: creditPayment.text.length);
                      remainPayment =provider.getTotals(false).net! - double.parse(creditPayment.text) ;
                      myState((){});
                    }, child: Text("300",style: TextStyle(fontSize:20.sp ,color: Colors.black),)),
              ),
            ),
          ],
        ),
      ],
    );
  }


  InputDecoration textFieldStyleDiscount() {
    return InputDecoration(
        contentPadding:  EdgeInsets.symmetric(vertical: 6.0.h,horizontal: 15.w),
        //hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide:const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(7.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.w),
          borderRadius: BorderRadius.circular(7.r),
        ));
  }
  // void massageForAlert(String massage ,bool failedData ){
  //   fToast.showToast(
  //     child: ToastDesign(massage: massage,failedData:failedData ),
  //     gravity: ToastGravity.TOP,
  //     toastDuration: const Duration(seconds: 2),
  //   );
  // }
@override
  void dispose() {
    // TODO: implement dispose
  creditPayment.dispose();
    super.dispose();
  }

}