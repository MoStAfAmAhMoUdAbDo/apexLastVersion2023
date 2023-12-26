import 'package:apex/costants/color.dart';
import 'package:apex/home%20page%20screens/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../signalRProvider.dart';
import 'cash_payment_method.dart';
import 'credit_payment.dart';
import 'other_option_payment.dart';


class ConfirmPayment extends StatefulWidget {
  static String rout = "/confirmation";
  const ConfirmPayment({super.key});

  @override
  State<ConfirmPayment> createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  bool isVisible = false;
  void refresh(bool visible) {
    setState(() {
      isVisible = visible;
    });
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signalRContext=context;
  }
  //bool isVisible =false;
  @override
  Widget build(BuildContext context) {
    //print("visable $isVisible");
    var lang = AppLocalizations.of(context);
    var provider = Provider.of<Cart_Items>(context);

    return Scaffold(
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
              fontSize: 27.sp, fontWeight: FontWeight.bold, color: basicColor),
        ),
      ),
      body: Container(
        color: Colors.grey,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        flex: 1,
                        child: Text(
                          lang.grandtotal,
                          style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          provider.getTotals(false).net.toString(),
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //isVisible== false ?
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height / 14,
                    child: Padding(
                      padding:
                          const EdgeInsets.only( right: 8, left: 8,bottom: 3),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Center(
                          child: Text(lang.choosePaymentMethod.toString(),
                              style: TextStyle(
                                  fontSize: 20.sp),
                              textAlign: TextAlign.start),
                        ),
                      ),
                    ),
                  ),
                  CashStyle(getFunction: refresh, visible: isVisible),
                ],
              )
              //    : Container(),
              // ContainerWithAnimation(visible:isVisible ,)
            ],
          ),
        ),
      ),
    );
  }
}


class CashStyle extends StatelessWidget {
  CashStyle({super.key, this.getFunction, required this.visible});
  final dynamic getFunction;
  bool visible;
  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                // visible = true;
                // getFunction(visible);
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CreditCardPaymentMethod()));
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const CreditCardPaymentMethod(),
                  reverseTransitionDuration: Duration.zero,
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                ),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  height: MediaQuery.sizeOf(context).height / 6,
                  width: MediaQuery.sizeOf(context).height / 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Image.asset(
                          "images/credit-card-2.png",
                          height: 60,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          lang!.credit.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CashPaymentMethod()));
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const CashPaymentMethod(),
                  transitionDuration: const Duration(seconds: 0),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  height: MediaQuery.sizeOf(context).height / 6,
                  width: MediaQuery.sizeOf(context).height / 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: Image.asset(
                          "images/cash-2.png",
                          height: 60,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          lang.cash.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const OtherOptionsPayment()));
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => const OtherOptionsPayment(),
              transitionDuration: const Duration(seconds: 0),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              padding: const EdgeInsets.all(18),
              height: MediaQuery.sizeOf(context).height / 6,
              width: MediaQuery.sizeOf(context).height / 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Image.asset(
                      "images/credit-cards.png",
                      height: 60,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      lang.other.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ContainerWithAnimation extends StatelessWidget {
  ContainerWithAnimation({super.key, required this.visible});
//double height;
  bool visible;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: visible == true ? MediaQuery.of(context).size.width : 0,
      height: visible == true ? MediaQuery.of(context).size.height / 3 : 0,
      color: Colors.blue,
    );
  }
}
