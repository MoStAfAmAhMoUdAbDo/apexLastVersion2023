import 'package:apex/home%20page%20screens/home_screenpage.dart';
import 'package:apex/home%20page%20screens/payment_option/sending_payment_toApi.dart';
import 'package:apex/models/login_data.dart';
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
import '../../models/other_payment_method.dart';
import '../basic_printer.dart';
import '../main_screen.dart';
import '../massage_toast.dart';
import '../menu_provider.dart';
import '../round_number.dart';
import '../session_popup.dart';
import '../signalRProvider.dart';

class OtherOptionsPayment extends StatelessWidget {
  const OtherOptionsPayment({super.key});

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
                      //fit: BoxFit.contain,
                      flex: 2,
                      child: Text(
                        lang.netPaymentAmount,
                        style: TextStyle(
                            fontSize: 23.sp,
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
              padding: EdgeInsets.only(top: 4.0),
              child: Center(child: ContainerWithAnimation()),
            )
          ],
        ));
  }
}

class ContainerWithAnimation extends StatefulWidget {
  const ContainerWithAnimation({super.key});

  @override
  State<ContainerWithAnimation> createState() => _ContainerWithAnimationState();
}

class _ContainerWithAnimationState extends State<ContainerWithAnimation> {
  double height = 0;
  double width = 0;
  double remainPayment = 0.0;
  bool focus = false;
  int count = 0;
  List<TextEditingController> paymentController = [];
  TextEditingController focusController = TextEditingController();
  List<PaymentMethods> methods = [];
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
    fToast.init(context);
    super.initState();
    signalRContext=context;
    methods.addAll(home_screen.paymentMethodList);
    for (int i = 0; i < methods.length; i++) {
      TextEditingController textEditingController = TextEditingController();
      paymentController.add(textEditingController);
    }
    focusController = paymentController[0];
    // Rebuild the screen after 3s which will process the animation from green to blue
    focus = true;
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => setState(() {
      height = MediaQuery.of(context).size.height / 2;
      width = MediaQuery.of(context).size.width;
    }));
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    var provider = Provider.of<Cart_Items>(context);
    var langType=Provider.of<modelprovider>(context).applocal;
    var itemLang = Provider.of<modelprovider>(context,listen: false).applocal;

    paymentController[0].text = provider.getTotals(false).net.toString();
    paymentController[0].selection = TextSelection(
      baseOffset: 0,
      extentOffset: provider.getTotals(false).net.toString().length,
    );
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: width,
      height: MediaQuery.of(context).size.height / 2,
      color: Colors.white,
      curve: Curves.decelerate,
      child: StatefulBuilder(builder: (context, myState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height /
                    13, //MediaQuery.of(context).size.height/13,
                decoration: BoxDecoration(
                    border: Border.all(width: 0.7, color: Colors.grey)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0 ,left: 8),
                            child: Text(
                              lang!.deserved,
                              style: TextStyle(
                                  fontSize: 23.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                    Flexible(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              provider.getTotals(false).net.toString(),
                              style: TextStyle(
                                  fontSize: 23.sp, fontWeight: FontWeight.bold),
                            ),
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
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height / 6,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 6,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  //shrinkWrap: true,
                  itemCount: methods.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 13,
                      decoration: BoxDecoration(
                          border: Border.symmetric(
                              horizontal: BorderSide(
                                  width: 0.7.w, color: Colors.grey))),
                      child: Row(
                        children: [
                          // SizedBox(
                          //   width: 13.w,
                          // ),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Padding(
                              padding:itemLang == const Locale("ar")? const EdgeInsets.only(right: 8.0) :const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width/6,
                                child: Text(
                                  itemLang == const Locale('en')
                                      ? methods[index].latinName
                                      : methods[index].arabicName,
                                  style: TextStyle(
                                      fontSize: 23.sp,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              width: 28.w,
                            ),
                          ),
                          Flexible(
                            flex: 8,
                            child: SizedBox(
                              height: 36.h,
                              child: GestureDetector(
                                onDoubleTap: () {
                                  double result = 0;
                                  for (int i = 0;
                                  i < paymentController.length;
                                  i++) {
                                    if (paymentController[i].text.isEmpty ||
                                        i == index) {
                                      continue;
                                    }
                                    result +=
                                        double.parse(paymentController[i].text);
                                  }
                                  paymentController[index].text =
                                      (provider.getTotals(false).net! - result)
                                          .toString();
                                  remainPayment =
                                      provider.getTotals(false).net! -
                                          result -
                                          double.parse(
                                              paymentController[index].text);
                                  focus = true;
                                  myState(() {});
                                },
                                child: TextFormField(
                                  controller: paymentController[index],
                                  style: TextStyle(fontSize: 16.sp),
                                  textAlign:itemLang ==const Locale('en')? TextAlign.right : TextAlign.left,
                                  textDirection:TextDirection.ltr ,
                                  decoration: textFieldStyleDiscount(),
                                  inputFormatters: [
                                    DecimalTextInputFormatter(decimalRange: provider.settingGeneral.roundNumG!),
                                    FilteringTextInputFormatter.allow(RegExp(r'^[\d,.]*$')),
                                    // FilteringTextInputFormatter.allow(RegExp(r'^\-?\d+\.?\d*')),
                                    //FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$')),
                                    //FilteringTextInputFormatter.allow(RegExp(r'^\-?\d+\.?\d*')),
                                    //  to make the number start with - and make it unsigned number and write the . only once
                                    //r'^\-?\d+\.?\d*' that to make the number decimal and did not repeat the . char
                                  ],
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  //mouseCursor:MouseCursor.uncontrolled ,
                                  autofocus: focus,
                                  onTap: () {
                                    focusController = paymentController[index];
                                    paymentController[index].selection = TextSelection.collapsed(offset: paymentController[index].text.length);
                                  },
                                  onChanged: (value) {
                                    myState(() {
                                      if (value.startsWith('.') && !value.contains('0.')) {
                                        paymentController[index].text = '0$value';
                                      }
                                      focus = false;

                                      double result = 0;
                                      for (var control in paymentController) {
                                        if (control.text.isNotEmpty) {
                                          result += double.parse(control.text);
                                        }
                                      }
                                      remainPayment =
                                          provider.getTotals(false).net! -
                                              result;
                                      paymentController[index].selection = TextSelection.collapsed(offset: paymentController[index].text.length);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.7, color: Colors.grey)),
                 child:Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Flexible(
                       child: FittedBox(
                           fit:BoxFit.contain,
                           child: Padding(
                             padding: const EdgeInsets.only(right: 8.0 ,left: 8.0,bottom: 6),
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
                //
                // ListTile(
                //   leading: Text(
                //     lang.remain,
                //     style: TextStyle(
                //         fontSize: 27.sp,
                //         color: Colors.black,
                //         fontWeight: FontWeight.bold),
                //   ),
                //   trailing: Text(remainPayment.toString()),
                // ),
              ),
            ),
            Flexible(
              flex: 2,
              child: keyboard(myState),
            ),
            Flexible(
              child: InkWell(
                onTap: ()async {
                  double payment=0.0; //double.parse(.text);
                  //PaymentsMethods paymentMethod=PaymentsMethods();
                  bool notEmptyPayment=false;
                  List<PaymentsMethods> paymentMethods = [];
                  for(int i =0 ; i< methods.length;i++){
                    if(paymentController[i].text.isNotEmpty){
                      notEmptyPayment=true;
                      PaymentsMethods paymentMethod=PaymentsMethods();
                      payment +=double.parse(paymentController[i].text);
                      //print("the pay ment method id is ${methods[i].paymentMethodId}");
                      paymentMethod.paymentMethodId = methods[i].paymentMethodId;
                      paymentMethod.value =double.parse(paymentController[i].text);
                      paymentMethod.paymentNameEn=methods[i].latinName;
                      paymentMethod.paymentNameAr=methods[i].arabicName;
                      paymentMethods.add(paymentMethod);
                    }

                  }
                  if(notEmptyPayment==false){
                    PaymentsMethods paymentMethod=PaymentsMethods();
                    payment = 0.0;
                    //print("the pay ment method id is ${methods[i].paymentMethodId}");
                    paymentMethod.paymentMethodId = methods[0].paymentMethodId;
                    paymentMethod.value =0.0;
                    paymentMethod.paymentNameEn=methods[0].latinName;
                    paymentMethod.paymentNameAr=methods[0].arabicName;
                    paymentMethods.add(paymentMethod);
                    notEmptyPayment=false;
                  }
                  // print("the payment methods after add in list${paymentMethods[0].paymentMethodId} ");
                  // print("the payment methods after add in list${paymentMethods[1].paymentMethodId} ");
                  if(provider.getTotals(false).net! < payment ){
                    MassageForToast().massageForAlert(lang.paymentAmountExceeded,false,fToast);
                  }
                  // else if(payment < 0){
                  //   MassageForToast().massageForAlert("",false,fToast);
                  // }
                  else{
                    showDialog(
                        barrierDismissible: false,
                        context: context, builder: (context){
                      // ignore: deprecated_member_use
                      return WillPopScope(
                          onWillPop: ()async {return false;  },
                          child: const Center(child: CircularProgressIndicator(),));
                    });
                    LoginData res=await SendPaymentMethods().sendingInvoiceDataToApi(context, payment, true, paymentMethods);

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
                        await PrintingInvoices().printingFun(res.fileUrl!);
                        if(Navigator.canPop(context)){
                          Navigator.of(context).pop();
                        }
                        // PrintingInvoices().printingInvoice(provider.invoiceData.invoiceId!, provider.invoiceData.invoiceCode!, isArabic, fToast,context);

                      }
                      else if(res.resultForPrint!=null && res.resultForPrint ==30)
                      {
                        MassageForToast().massageForAlert(lang.noPermissionPrint,false,fToast);
                        if(Navigator.canPop(context)){
                          Navigator.of(context).pop();
                        }
                      }

                      //MassageForToast().massageForAlert(lang.invoiceSavedSuccessfully,true,fToast);
                      provider.counterDiscountCheek = 0 ;
                      provider.isDiscountOnItem=false;
                      provider.isEdite=false;
                      provider.settingGeneral.editeInvoice=false;
                      provider.settingGeneral.returnInvoice=false;
                      provider.returnInvoice=false;
                      provider.settingGeneral.returnInvoice=false;
                      provider.returnInvoice=false;
                      provider.invoiceData = InvoiceData();
                      provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
                      provider.invoiceData=InvoiceData();
                      Provider.of<menuProviderOptions>(context,listen: false).setNotes("");
                      provider.remove_all_items();
                      provider.updat();
                      if(Navigator.canPop(context)){
                        // Navigator.of(context).pop();
                        Navigator.of(context).pushNamedAndRemoveUntil(Main_Screen.rout, (route) => false);
                      }
                      // Navigator.of(context).popUntil(ModalRoute.withName(Main_Screen.rout));
                    }
                    else if(res.result==0 &&res.statusCode !=null &&res.statusCode !=401){
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
                          context: context, builder:(context)=> WillPopScope(onWillPop: () async{ return false; },
                          child: SessionPopUp(massage: massage,newContext: context,)));
                      //Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);
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
                  }
                },
                child: Container(
                    color: const Color.fromARGB(255, 21, 138, 21),
                    //
                    width: double.infinity,
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(child: Image.asset("images/money.png")),
                            SizedBox(
                              width: 18.w,
                            ),
                            Flexible(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(lang.pay,
                                      style: TextStyle(
                                          fontSize: 27.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ],
                        ))),
              ),
            ),
          ],
        );
      }),
    );
  }
  // void massageForAlert(String massage ,bool failedData ){
  //   fToast.showToast(
  //     child: ToastDesign(massage: massage,failedData:failedData ),
  //     gravity: ToastGravity.TOP,
  //     toastDuration: const Duration(seconds: 2),
  //   );
  // }

  Widget keyboard(void Function(void Function()) myState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height / 20,
                width: MediaQuery.of(context).size.width / 3.2,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.7, color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    onPressed: () {
                      if(focus==true){
                        focusController.clear();
                        focus=false;
                      }
                      focusController.text += "5";
                      focusController.selection = TextSelection.collapsed(
                          offset: focusController.text.length);
                      double result = 0;
                      for (var control in paymentController) {
                        if (control.text.isNotEmpty &&
                            control != focusController) {
                          result += double.parse(control.text);
                        }
                      }
                      remainPayment =
                          Provider.of<Cart_Items>(context, listen: false)
                              .getTotals(false)
                              .net! -
                              result -
                              double.parse(focusController.text);
                      myState(() {});
                    },
                    child: Text(
                      "5",
                      style: TextStyle(fontSize: 20.sp, color: Colors.black),
                    )),
              ),
            ),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height / 20,
                width: MediaQuery.of(context).size.width / 3.2,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.7, color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    onPressed: () {
                      if(focus==true){
                        focusController.clear();
                        focus=false;
                      }
                      focusController.text += "10";
                      focusController.selection = TextSelection.collapsed(
                          offset: focusController.text.length);
                      double result = 0;
                      for (var control in paymentController) {
                        if (control.text.isNotEmpty &&
                            control != focusController) {
                          result += double.parse(control.text);
                        }
                      }
                      remainPayment =
                          Provider.of<Cart_Items>(context, listen: false)
                              .getTotals(false)
                              .net! -
                              result -
                              double.parse(focusController.text);
                      myState(() {});
                    },
                    child: Text(
                      "10",
                      style: TextStyle(fontSize: 20.sp, color: Colors.black),
                    )),
              ),
            ),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height / 20,
                width: MediaQuery.of(context).size.width / 3.2,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.7, color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    onPressed: () {
                      if(focus==true){
                        focusController.clear();
                        focus=false;
                      }
                      focusController.text += "50";
                      focusController.selection = TextSelection.collapsed(
                          offset: focusController.text.length);
                      double result = 0;
                      for (var control in paymentController) {
                        if (control.text.isNotEmpty &&
                            control != focusController) {
                          result += double.parse(control.text);
                        }
                      }
                      remainPayment =
                          Provider.of<Cart_Items>(context, listen: false)
                              .getTotals(false)
                              .net! -
                              result -
                              double.parse(focusController.text);
                      myState(() {});
                    },
                    child: Text(
                      "50",
                      style: TextStyle(fontSize: 20.sp, color: Colors.black),
                    )),
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
                height: MediaQuery.of(context).size.height / 20,
                width: MediaQuery.of(context).size.width / 3.2,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.7, color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    onPressed: () {
                      if(focus==true){
                        focusController.clear();
                        focus=false;
                      }
                      focusController.text += "100";
                      focusController.selection = TextSelection.collapsed(
                          offset: focusController.text.length);
                      double result = 0;
                      for (var control in paymentController) {
                        if (control.text.isNotEmpty &&
                            control != focusController) {
                          result += double.parse(control.text);
                        }
                      }
                      remainPayment =
                          Provider.of<Cart_Items>(context, listen: false)
                              .getTotals(false)
                              .net! -
                              result -
                              double.parse(focusController.text);
                      myState(() {});
                    },
                    child: Text(
                      "100",
                      style: TextStyle(fontSize: 20.sp, color: Colors.black),
                    )),
              ),
            ),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height / 20,
                width: MediaQuery.of(context).size.width / 3.2,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.7, color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    onPressed: () {
                      if(focus==true){
                        focusController.clear();
                        focus=false;
                      }
                      focusController.text += "200";
                      focusController.selection = TextSelection.collapsed(
                          offset: focusController.text.length);
                      double result = 0;
                      for (var control in paymentController) {
                        if (control.text.isNotEmpty &&
                            control != focusController) {
                          result += double.parse(control.text);
                        }
                      }
                      remainPayment =
                          Provider.of<Cart_Items>(context, listen: false)
                              .getTotals(false)
                              .net! -
                              result -
                              double.parse(focusController.text);
                      myState(() {});
                    },
                    child: Text(
                      "200",
                      style: TextStyle(fontSize: 20.sp, color: Colors.black),
                    )),
              ),
            ),
            Flexible(
              child: Container(
                height: MediaQuery.of(context).size.height / 20,
                width: MediaQuery.of(context).size.width / 3.2,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.7, color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.r),
                  color: Colors.white,
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    onPressed: () {
                      if(focus==true){
                        focusController.clear();
                        focus=false;
                      }
                      focusController.text += "300";
                      focusController.selection = TextSelection.collapsed(
                          offset: focusController.text.length);
                      double result = 0;
                      for (var control in paymentController) {
                        if (control.text.isNotEmpty &&
                            control != focusController) {
                          result += double.parse(control.text);
                        }
                      }
                      remainPayment =
                          Provider.of<Cart_Items>(context, listen: false)
                              .getTotals(false)
                              .net! -
                              result -
                              double.parse(focusController.text);
                      myState(() {});
                    },
                    child: Text(
                      "300",
                      style: TextStyle(fontSize: 20.sp, color: Colors.black),
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration textFieldStyleDiscount() {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 15.w),
        //hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(7.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.w),
          borderRadius: BorderRadius.circular(7.r),
        ));
  }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   focusController.dispose();
  //   for(var con in paymentController ){
  //     con.dispose();
  //   }
  //   super.dispose();
  // }
}