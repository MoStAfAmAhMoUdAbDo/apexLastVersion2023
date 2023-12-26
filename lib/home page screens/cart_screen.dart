import 'package:apex/home%20page%20screens/basic_printer.dart';
import 'package:apex/home%20page%20screens/payment_option/confirmation_payment.dart';
import 'package:apex/home%20page%20screens/round_number.dart';
import 'package:apex/home%20page%20screens/serial_item.dart';
import 'package:apex/home%20page%20screens/signalRProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../api_directory/get_persons_dropdown_data.dart';
import '../api_directory/search_barcode.dart';
import '../costants/color.dart';
import '../model.dart';
import '../models/get_invoice_api.dart';
import '../models/invoice_data_object.dart';
import 'add_user/dialog_for_more_tabe.dart';
import 'alert_massage.dart';
import 'cart_items.dart';
import '../models/items.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'expiry_item.dart';
import 'main_screen.dart';
import 'massage_toast.dart';

class My_basket extends StatefulWidget {
  static const root = '/myBasket';
  const My_basket({super.key});

  @override
  State<My_basket> createState() => _My_basketState();
}

class _My_basketState extends State<My_basket> {
  TextEditingController textPriceControler = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String radioValue = "fixed";

  TextEditingController itemDiscountTXT = TextEditingController();
  String itemDisccountRadio = "fixed";
  bool itemDiscountBtn = false;
  bool disccountBtn = false;
  //late List<String> dropDowenItems;
  //late String selectedItem;
  //int counterDiscountCheek =0;
  TextEditingController discountTxT = TextEditingController();
  late String result;
  var barCodeResult;
  FToast fToast = FToast();
  late totalResult totaltest;
  List<PersonInvoiceDropDown> tempList = [];
  List<PersonInvoiceDropDown> tempList2 = [];
  int pageNumber = 1;
  int pageSize = 20;
  late OverlayEntry overlayEntry;
  DataFromApi personDropDownList = DataFromApi();
  bool isLoading = false;
  bool tryLoading = false;
  ScrollController scrollController = ScrollController();
  FocusNode clientFocus = FocusNode();
  TextEditingController clientController = TextEditingController();
  ScrollController clintTextFieldScrollController = ScrollController();
  //final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    signalRContext = context;
    //svar itemlang =
    var pro = Provider.of<Cart_Items>(context, listen: false);
    //print("the person id is ${pro.personId.arabicName==null ? "return null value" :pro.personId.arabicName}");
    String personName =
        Provider.of<modelprovider>(context, listen: false).applocal ==
                const Locale('ar')
            ? pro.personId.arabicName!
            : pro.personId.latinName!;
    clientController.text = personName;
    // TODO: implement initState
    fToast.init(context);
    scrollController.addListener(_scrollListener);
    focusListener(clientFocus);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textPriceControler.dispose();
    discountTxT.dispose();
    itemDiscountTXT.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itemlang = Provider.of<modelprovider>(context).applocal;
    var pro = Provider.of<Cart_Items>(context, listen: false);
    //print("the person id is ${pro.personId.arabicName==null ? "return null value" :pro.personId.arabicName}");
    // String personName=itemlang==Locale('ar') ? pro.personId.arabicName! :pro.personId.latinName!;
    // clientController.text=personName;
    var lang = AppLocalizations.of(context);
    totaltest = pro.getTotals(false);
    // var isEdite=ModalRoute.of(context)!.settings.arguments;
    // print("the value of is edite is ${isEdite}");
    // print("the general setting is apply vat ${Provider.of<Cart_Items>(context).settingGeneral.applyvatG!}");
    // print("the general setting is round number  ${Provider.of<Cart_Items>(context).settingGeneral.roundNumG!}");
    // print("the general setting is active discount ${Provider.of<Cart_Items>(context).settingGeneral.activeDiscountG!}");
    // print("the general setting is modify price  ${Provider.of<Cart_Items>(context).settingGeneral.dataDisVat!.popModifyPrice}");
    // //print("the value of is deleted ${Provider.of<Cart_Items>(context).invoiceData.isDeleted} ");
    // print("the value of is accredite ${Provider.of<Cart_Items>(context).invoiceData.isAccredited} ");
   // print("the value of is is edite ${isEdite} ");
    //provid.invoiceData.edit==true){
    //                         if (provid.invoiceData
    //                             .isAccredited!
    return Consumer<Cart_Items>(
      builder: (context, provid, child) {
        //print("the text value is ${double.parse(discountTxT.text)}");

        if (provid.discount > 0) {
          disccountBtn = true;
          discountTxT.text = provid.discount.toString();
          radioValue= provid.radioDiscount;
        }
        if (provid.isDiscountOnItem == false) {
          discountTxT.clear();
        }
        if (provid.bascet_item.isEmpty) {
          // ignore: deprecated_member_use
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: basicColor),
              backgroundColor: Colors.white,
              title: SizedBox(
                child: clientNameText(setState),
              ),
              leading: IconButton(
                onPressed: () {
                  //Navigator.of(context).pushReplacementNamed(Main_Screen.rout);
                  if (provid.settingGeneral.editeInvoice == true) {
                    // Navigator.of(context).popUntil((route) => );
                    // Navigator.popUntil(context, ModalRoute.withName());
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => Main_Screen(
                                  index: 0,
                                  setIndex: true,
                                )),
                        (route) => false);
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)));
                  }
                  //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)), (route) => false);
                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Main_Screen()));
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)));
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description_sharp),
                  Text(
                    lang!.emptycart.toString(),
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        } else {
          // ignore: deprecated_member_use
          if(provid.settingGeneral.roundNumG !=null && provid.settingGeneral.priceIncludVat !=null
              && provid.settingGeneral.activeDiscountG !=null && provid.settingGeneral.applyvatG !=null){
            ///
            //     provid.settingGeneral.dataDisVat!.popModifyPrice

            // ignore: deprecated_member_use
            return WillPopScope(
              onWillPop: () async {
                if (provid.settingGeneral.editeInvoice == true) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => Main_Screen(
                            index: 0,
                            setIndex: true,
                          )),
                          (route) => false);
                }  else if(provid.returnInvoice==true){
                  provid.counterDiscountCheek = 0;
                  provid.isDiscountOnItem = false;

                  //provid.isEdite = false;
                  provid.isEdite = false;
                  //provid.bascet_item[index].isEdite=false;
                  provid.settingGeneral.editeInvoice = false;
                  provid.settingGeneral.returnInvoice=false;
                  provid.returnInvoice=false;
                  provid.invoiceData = InvoiceData();
                  provid.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );

                  provid.remove_all_items();

                  provid.updat();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => Main_Screen(
                            index: 0,
                            setIndex: true,
                          )),
                          (route) => false);
                }
                else {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => Main_Screen(
                            index: 0,
                            setIndex: true,
                          )),
                          (route) => false);
                }
                return false;
              },
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: SafeArea(
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(
                        color: basicColor,
                      ),
                      backgroundColor: Colors.white,
                        flexibleSpace:Row(
                            children: [
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                  onPressed: () {
                                    if (provid.settingGeneral.editeInvoice == true) {
                                      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)));
                                      //home_screen.reloadHomepage=false;
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => Main_Screen(
                                                index: 0,
                                                setIndex: true,
                                              )),
                                              (route) => false);
                                      //home_screen.reloadHomepage=true;
                                    } else if(provid.returnInvoice==true){
                                      provid.counterDiscountCheek = 0;
                                      provid.isDiscountOnItem = false;
                                                  
                                      //provid.isEdite = false;
                                      provid.isEdite = false;
                                      //provid.bascet_item[index].isEdite=false;
                                      provid.settingGeneral.editeInvoice = false;
                                      provid.settingGeneral.returnInvoice=false;
                                      provid.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
                                      provid.invoiceData = InvoiceData();
                                      provid.remove_all_items();
                                      provid.returnInvoice=false;
                                      provid.updat();
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => Main_Screen(
                                                index: 0,
                                                setIndex: true,
                                              )),
                                              (route) => false);
                                                  
                                                  
                                                  
                                    }
                                    else  {
                                      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)));
                                      //Navigator.of(context).pop();
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => Main_Screen(
                                                index: 0,
                                                setIndex: true,
                                              )),
                                              (route) => false);
                                                  
                                                  
                                      ///
                                      // Navigator.of(context).pop();
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
                            ),
                            Flexible(
                              flex: 3,
                              child: SizedBox(
                                width: 130.w,
                              child: clientNameText(setState),),
                            ),
                              Flexible(
                                flex: 1,
                                child: StatefulBuilder(
                                  builder: (context, myState) {
                                    return  IconButton(
                                      onPressed: ()async {
                                        //provid.remove_all_items();

                                        bool reloadPage= await showDialog(
                                            context: context,
                                            builder: (context) => PersonAddPopUp());
                                        if (reloadPage == true) {
                                          myState(() {
                                            String personName =
                                            Provider.of<modelprovider>(context, listen: false).applocal ==
                                                const Locale('ar')
                                                ? pro.personId.arabicName!
                                                : pro.personId.latinName!;
                                            clientController.text = personName;
                                          });
                                          //print('Reload the page');
                                        }

                                      },
                                      icon: const Icon(Icons.person_add_alt_1_outlined),
                                    );
                                  },
                                ),
                              ),
                    
                              Flexible(
                                flex: 1,
                                child: IconButton(
                                    onPressed: () async {
                                      if (provid.invoiceData.edit == true) {
                                        if (provid.invoiceData.isAccredited! == true) {
                                          MassageForToast().massageForAlert(
                                              lang!.isAccredited, false, fToast);
                                        } else if (provid.invoiceData.isDeleted == true) {
                                          MassageForToast().massageForAlert(
                                              lang!.isDeleted, false, fToast);
                                        } else if (provid.invoiceData.isCollectionReceipt ==
                                            true) {
                                          MassageForToast().massageForAlert(
                                              lang!.isCollectionReceipt, false, fToast);
                                        }
                                        else if (provid.invoiceData.isReturn ==
                                            true) {
                                          MassageForToast().massageForAlert(
                                              lang!.isReturn, false, fToast);
                                        }
                                      } else if (provid.returnInvoice ==
                                          true) {
                                        MassageForToast().massageForAlert(
                                            lang!.isReturn, false, fToast);
                                      }else {
                                        var res = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              const SimpleBarcodeScannerPage(),
                                            ));
                                        if (res is String) {
                                          result = res;
                                        }
                                        if (result != "-1") {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return const Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              });

                                          barCodeResult =
                                          await getBarcodeData().searchBarcode(result);
                                          Navigator.of(context).pop();
                                          fToast.init(context);
                                          if (barCodeResult.result == 1) {
                                            provid.isEdite = false;
                                            int index = provid.bascet_item.indexWhere(
                                                    (item) => item.id == barCodeResult.item!.id);
                                            if (index != -1 &&
                                                provid.bascet_item.isNotEmpty) {
                                              provid.bascet_item[index].qty++;
                                              provid.isEdite = false;
                                              provid.bascet_item[index].isEdite = false;
                                              provid.updat();
                                            } else {
                                              //provid.isEdite = false;
                                              provid.isEdite = false;
                                              provid.bascet_item[index].isEdite = false;
                                              provid.add_item(barCodeResult.item!);
                                            }
                                            // provider
                                            //     .add_item(barCodeResult.item!);
                                            MassageForToast().massageForAlert(
                                                lang!.itemAddedSuccessfully, true, fToast);
                                          } else {
                                            // FlutterRingtonePlayer.playNotification();
                                            FlutterRingtonePlayer().play(
                                                asAlarm: true,
                                                // fromAsset: "sound/mixkit-classic-short-alarm-993.wav", // will be the sound on Android

                                                fromAsset:
                                                "sound/mixkit-interface-option-select-2573.wav",
                                                ios: IosSounds
                                                    .alarm // will be the sound on iOS

                                            );
                                            String msg = Provider.of<modelprovider>(context,
                                                listen: false)
                                                .applocal ==
                                                const Locale("en")
                                                ? barCodeResult.errorMassageEn!
                                                : barCodeResult.errorMassageAr!;
                                            MassageForToast()
                                                .massageForAlert(msg, false, fToast);
                                          }
                                        } else {
                                          MassageForToast()
                                              .massageForAlert(lang!.codeScan, false, fToast);
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.qr_code_scanner)),
                              ),
                    
                              Flexible(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                    //provid.remove_all_items();
                                    if (provid.isEdite == false &&
                                        provid.bascet_item.isNotEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => WarningMassage(
                                            index: -1,
                                            massage:
                                            AppLocalizations.of(context)!.newInvoice,
                                            insideNewButton: true,
                                          ));
                                    } else {
                                      provid.counterDiscountCheek = 0;
                                      provid.isDiscountOnItem = false;

                                      //provid.isEdite = false;
                                      provid.isEdite = false;
                                      //provid.bascet_item[index].isEdite=false;
                                      provid.settingGeneral.editeInvoice = false;
                                      provid.settingGeneral.returnInvoice=false;
                                      provid.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
                                      provid.invoiceData = InvoiceData();
                                      provid.remove_all_items();
                                      provid.returnInvoice=false;
                                      provid.updat();
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => Main_Screen(
                                                index: 0,
                                                setIndex: true,
                                              )),
                                              (route) => false);
                                    }

                                    // showDialog(
                                    //     context: context,
                                    //     builder: (context) => WarningMassage(
                                    //         index: -1,
                                    //         massage: lang.warningmassegeallitem.toString()));
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    size: 33,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () async {
                                    if (provid.settingGeneral.editeInvoice == true) {
                                      //provid.invoiceData.invoiceId
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            // ignore: deprecated_member_use
                                            return WillPopScope(
                                                onWillPop: () async {
                                                  return false;
                                                },
                                                child: const Center(
                                                  child: CircularProgressIndicator(),
                                                ));
                                          });
                                      bool isArabic =
                                      Provider.of<modelprovider>(context, listen: false)
                                          .applocal ==
                                          const Locale("ar")
                                          ? true
                                          : false;
                                      await PrintingInvoices().printingInvoice(
                                          provid.invoiceData.invoiceId!,
                                          provid.invoiceData.invoiceCode!,
                                          isArabic,
                                          fToast,
                                          this.context);
                                      if (Navigator.canPop(context)) {
                                        Navigator.of(context).pop();
                                      }
                                    } else if(provid.settingGeneral.returnInvoice==true) {
                                      MassageForToast().massageForAlert(
                                          lang!.canNotPrintReturnInvoice, false, fToast);
                                    }
                                    else{
                                      {
                                        MassageForToast().massageForAlert(
                                            lang!.toPrintSaveInvoice, false, fToast);
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.print_sharp),
                                ),
                              ),
                        ],),
                      // title: SizedBox(
                      //   child: clientNameText(setState),
                      // ),
                      // leading: IconButton(
                      //   onPressed: () {
                      //     if (provid.settingGeneral.editeInvoice == true) {
                      //       //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)));
                      //       //home_screen.reloadHomepage=false;
                      //       Navigator.of(context).pushAndRemoveUntil(
                      //           MaterialPageRoute(
                      //               builder: (context) => Main_Screen(
                      //                 index: 0,
                      //                 setIndex: true,
                      //               )),
                      //               (route) => false);
                      //       //home_screen.reloadHomepage=true;
                      //     } else if(provid.returnInvoice==true){
                      //       provid.counterDiscountCheek = 0;
                      //       provid.isDiscountOnItem = false;
                      //
                      //       //provid.isEdite = false;
                      //       provid.isEdite = false;
                      //       //provid.bascet_item[index].isEdite=false;
                      //       provid.settingGeneral.editeInvoice = false;
                      //       provid.settingGeneral.returnInvoice=false;
                      //       provid.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
                      //       provid.invoiceData = InvoiceData();
                      //       provid.remove_all_items();
                      //       provid.returnInvoice=false;
                      //       provid.updat();
                      //       Navigator.of(context).pushAndRemoveUntil(
                      //           MaterialPageRoute(
                      //               builder: (context) => Main_Screen(
                      //                 index: 0,
                      //                 setIndex: true,
                      //               )),
                      //               (route) => false);
                      //
                      //
                      //
                      //     }
                      //     else  {
                      //       //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)));
                      //       //Navigator.of(context).pop();
                      //       Navigator.of(context).pushAndRemoveUntil(
                      //           MaterialPageRoute(
                      //               builder: (context) => Main_Screen(
                      //                 index: 0,
                      //                 setIndex: true,
                      //               )),
                      //               (route) => false);
                      //
                      //
                      //       ///
                      //       // Navigator.of(context).pop();
                      //     }
                      //   },
                      //   icon: const Icon(Icons.arrow_back),
                      // ),
                     // actions: [
                        // IconButton(
                        //   onPressed: () {
                        //     //provid.remove_all_items();
                        //
                        //     showDialog(
                        //         context: context,
                        //         builder: (context) => PersonAddPopUp());
                        //   },
                        //   icon: const Icon(Icons.person_add_alt_1_outlined),
                        // ),
                        //
                        // IconButton(
                        //     onPressed: () async {
                        //       if (provid.invoiceData.edit == true) {
                        //         if (provid.invoiceData.isAccredited! == true) {
                        //           MassageForToast().massageForAlert(
                        //               lang!.isAccredited, false, fToast);
                        //         } else if (provid.invoiceData.isDeleted == true) {
                        //           MassageForToast().massageForAlert(
                        //               lang!.isDeleted, false, fToast);
                        //         } else if (provid.invoiceData.isCollectionReceipt ==
                        //             true) {
                        //           MassageForToast().massageForAlert(
                        //               lang!.isCollectionReceipt, false, fToast);
                        //         }
                        //         else if (provid.invoiceData.isReturn ==
                        //             true) {
                        //           MassageForToast().massageForAlert(
                        //               lang!.isReturn, false, fToast);
                        //         }
                        //       } else if (provid.returnInvoice ==
                        //           true) {
                        //         MassageForToast().massageForAlert(
                        //             lang!.isReturn, false, fToast);
                        //       }else {
                        //         var res = await Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) =>
                        //               const SimpleBarcodeScannerPage(),
                        //             ));
                        //         if (res is String) {
                        //           result = res;
                        //         }
                        //         if (result != "-1") {
                        //           showDialog(
                        //               barrierDismissible: false,
                        //               context: context,
                        //               builder: (context) {
                        //                 return Center(
                        //                   child: CircularProgressIndicator(),
                        //                 );
                        //               });
                        //
                        //           barCodeResult =
                        //           await getBarcodeData().searchBarcode(result);
                        //           Navigator.of(context).pop();
                        //           fToast.init(context);
                        //           if (barCodeResult.result == 1) {
                        //             provid.isEdite = false;
                        //             int index = provid.bascet_item.indexWhere(
                        //                     (item) => item.id == barCodeResult.item!.id);
                        //             if (index != -1 &&
                        //                 provid.bascet_item.isNotEmpty) {
                        //               provid.bascet_item[index].qty++;
                        //               provid.isEdite = false;
                        //               provid.bascet_item[index].isEdite = false;
                        //               provid.updat();
                        //             } else {
                        //               //provid.isEdite = false;
                        //               provid.isEdite = false;
                        //               provid.bascet_item[index].isEdite = false;
                        //               provid.add_item(barCodeResult.item!);
                        //             }
                        //             // provider
                        //             //     .add_item(barCodeResult.item!);
                        //             MassageForToast().massageForAlert(
                        //                 lang!.itemAddedSuccessfully, true, fToast);
                        //           } else {
                        //             // FlutterRingtonePlayer.playNotification();
                        //             FlutterRingtonePlayer.play(
                        //                 asAlarm: true,
                        //                 // fromAsset: "sound/mixkit-classic-short-alarm-993.wav", // will be the sound on Android
                        //
                        //                 fromAsset:
                        //                 "sound/mixkit-interface-option-select-2573.wav",
                        //                 ios: IosSounds
                        //                     .alarm // will be the sound on iOS
                        //
                        //             );
                        //             String msg = Provider.of<modelprovider>(context,
                        //                 listen: false)
                        //                 .applocal ==
                        //                 const Locale("en")
                        //                 ? barCodeResult.errorMassageEn!
                        //                 : barCodeResult.errorMassageAr!;
                        //             MassageForToast()
                        //                 .massageForAlert(msg, false, fToast);
                        //           }
                        //         } else {
                        //           MassageForToast()
                        //               .massageForAlert(lang!.codeScan, false, fToast);
                        //         }
                        //       }
                        //     },
                        //     icon: Icon(Icons.qr_code_scanner)),
                        //
                        // IconButton(
                        //   onPressed: () {
                        //     //provid.remove_all_items();
                        //     if (provid.isEdite == false &&
                        //         provid.bascet_item.isNotEmpty) {
                        //       showDialog(
                        //           context: context,
                        //           builder: (context) => WarningMassage(
                        //             index: -1,
                        //             massage:
                        //             AppLocalizations.of(context)!.newInvoice,
                        //             insideNewButton: true,
                        //           ));
                        //     } else {
                        //       provid.counterDiscountCheek = 0;
                        //       provid.isDiscountOnItem = false;
                        //
                        //       //provid.isEdite = false;
                        //       provid.isEdite = false;
                        //       //provid.bascet_item[index].isEdite=false;
                        //       provid.settingGeneral.editeInvoice = false;
                        //       provid.settingGeneral.returnInvoice=false;
                        //       provid.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
                        //       provid.invoiceData = InvoiceData();
                        //       provid.remove_all_items();
                        //       provid.returnInvoice=false;
                        //       provid.updat();
                        //       Navigator.of(context).pushAndRemoveUntil(
                        //           MaterialPageRoute(
                        //               builder: (context) => Main_Screen(
                        //                 index: 0,
                        //                 setIndex: true,
                        //               )),
                        //               (route) => false);
                        //     }
                        //
                        //     // showDialog(
                        //     //     context: context,
                        //     //     builder: (context) => WarningMassage(
                        //     //         index: -1,
                        //     //         massage: lang.warningmassegeallitem.toString()));
                        //   },
                        //   icon: const Icon(
                        //     Icons.add,
                        //     size: 33,
                        //   ),
                        // ),
                        // IconButton(
                        //   onPressed: () async {
                        //     if (provid.settingGeneral.editeInvoice == true) {
                        //       //provid.invoiceData.invoiceId
                        //       showDialog(
                        //           context: context,
                        //           builder: (context) {
                        //             // ignore: deprecated_member_use
                        //             return WillPopScope(
                        //                 onWillPop: () async {
                        //                   return false;
                        //                 },
                        //                 child: Center(
                        //                   child: CircularProgressIndicator(),
                        //                 ));
                        //           });
                        //       bool isArabic =
                        //       Provider.of<modelprovider>(context, listen: false)
                        //           .applocal ==
                        //           Locale("ar")
                        //           ? true
                        //           : false;
                        //       await PrintingInvoices().printingInvoice(
                        //           provid.invoiceData.invoiceId!,
                        //           provid.invoiceData.invoiceCode!,
                        //           isArabic,
                        //           fToast,
                        //           this.context);
                        //       if (Navigator.canPop(context)) {
                        //         Navigator.of(context).pop();
                        //       }
                        //     } else if(provid.settingGeneral.returnInvoice==true) {
                        //       MassageForToast().massageForAlert(
                        //           lang!.canNotPrintReturnInvoice, false, fToast);
                        //     }
                        //     else{
                        //       {
                        //         MassageForToast().massageForAlert(
                        //             lang!.toPrintSaveInvoice, false, fToast);
                        //       }
                        //     }
                        //   },
                        //   icon: const Icon(Icons.print_sharp),
                        // ),
                    
                        //if(Provider.of<Cart_Items>(context).bascet_item.isNotEmpty)
                      //],
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: provid.bascet_item.length,
                                    itemBuilder: (context, index) {
                                      if (provid.bascet_item[index]
                                          .dropDownValue ==
                                          null &&
                                          provid.isEdite == false) {
                                        provid.bascet_item[index].dropDownValue =
                                        provid.bascet_item[index].units[0];
                                      }
                                      if (provid
                                          .bascet_item[index].itemDisccount >
                                          0) {
                                        itemDiscountBtn = true;
                                        itemDiscountTXT.text = provid
                                            .bascet_item[index].itemDisccount
                                            .toString();
                                      }

                                      return Card(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex:1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    provid.returnInvoice==true &&
                                                        provid.bascet_item[index].qty == provid.invoiceData.invoiceDetails![index].oldQuantity!  ?
                                                    const SizedBox()
                                                        :
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(8.0),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          if (provid.invoiceData
                                                              .edit ==
                                                              true) {
                                                            if (provid.invoiceData
                                                                .isAccredited! ==
                                                                true) {
                                                              MassageForToast().massageForAlert(lang!.isAccredited,
                                                                  false,
                                                                  fToast);
                                                            } else if (provid.invoiceData.isDeleted ==
                                                                true) {
                                                              MassageForToast()
                                                                  .massageForAlert(
                                                                  lang!
                                                                      .isDeleted,
                                                                  false,
                                                                  fToast);
                                                            } else if (provid.invoiceData.isCollectionReceipt ==true) {
                                                              MassageForToast().massageForAlert(
                                                                  lang!.isCollectionReceipt, false, fToast);
                                                            }else if (provid.invoiceData.isReturn ==
                                                                true) {
                                                              MassageForToast().massageForAlert(
                                                                  lang!.isReturn, false, fToast);
                                                            }
                                                            else {
                                                              //provid.isEdite = false;

                                                              if (provid.bascet_item[index].itemTypeId == 3) {
                                                                expirySheet(provid.bascet_item[index].itemCode!);
                                                              } else if (provid.bascet_item[index].itemTypeId == 2) {
                                                                serialSheet(provid
                                                                    .bascet_item[
                                                                index]
                                                                    .itemCode!);
                                                              }

                                                              else {

                                                                provid.isEdite = false;
                                                                provid.bascet_item[index].isEdite = false;
                                                                ++provid.bascet_item[index].qty;
                                                                provid.updat();
                                                              }
                                                            }
                                                          } else {
                                                            provid.isEdite = false;
                                                            if (provid.bascet_item[index].itemTypeId == 3) {
                                                              expirySheet(provid.bascet_item[index].itemCode!);
                                                            } else if (provid.bascet_item[index].itemTypeId == 2) {
                                                              serialSheet(provid.bascet_item[index].itemCode!);
                                                            }else if(provid.returnInvoice==true){
                                                              if(provid.bascet_item[index].qty <provid.invoiceData.invoiceDetails![index].oldQuantity!){
                                                                provid.isEdite = false;
                                                                provid.bascet_item[index].isEdite = false;
                                                                ++provid.bascet_item[index].qty;
                                                                provid.updat();
                                                              }
                                                              else{
                                                                MassageForToast().massageForAlert(
                                                                    lang!.quantityNotAvailableInvoice, false, fToast);
                                                              }
                                                            }
                                                            else {
                                                              ++provid.bascet_item[index].qty;
                                                              provid.updat();
                                                            }
                                                          }
                                                        },
                                                        icon:  Icon(
                                                          Icons.add_circle_outline,
                                                          size: 45,
                                                          color: basicColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                        top: 15,
                                                        bottom: 5,
                                                      ),
                                                      child: FittedBox(
                                                        fit: BoxFit.fill,
                                                        child: Text(
                                                            provid.bascet_item[index].isBalanceBarcode == false?
                                                            provid.roundDouble(provid.bascet_item[index].qty, provid.settingGeneral.roundNumG!).toString() :
                                                            provid.bascet_item[index].qty.toString() ,
                                                          style: TextStyle(
                                                              fontSize: 24.sp),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        if (provid
                                                            .invoiceData.edit ==
                                                            true) {
                                                          if (provid.invoiceData
                                                              .isAccredited! ==
                                                              true) {
                                                            MassageForToast()
                                                                .massageForAlert(
                                                                lang!
                                                                    .isAccredited,
                                                                false,
                                                                fToast);
                                                          } else if (provid
                                                              .invoiceData
                                                              .isDeleted ==
                                                              true) {
                                                            MassageForToast()
                                                                .massageForAlert(
                                                                lang!.isDeleted,
                                                                false,
                                                                fToast);
                                                          } else if (provid
                                                              .invoiceData
                                                              .isCollectionReceipt ==
                                                              true) {
                                                            MassageForToast()
                                                                .massageForAlert(
                                                                lang!
                                                                    .isCollectionReceipt,
                                                                false,
                                                                fToast);
                                                          }else if (provid.invoiceData.isReturn ==
                                                              true) {
                                                            MassageForToast().massageForAlert(
                                                                lang!.isReturn, false, fToast);
                                                          } else {
                                                            if (provid
                                                                .bascet_item[
                                                            index]
                                                                .itemTypeId ==
                                                                3) {
                                                              expirySheet(provid
                                                                  .bascet_item[
                                                              index]
                                                                  .itemCode!);
                                                            } else if (provid
                                                                .bascet_item[
                                                            index]
                                                                .itemTypeId ==
                                                                2) {
                                                              serialSheet(provid
                                                                  .bascet_item[
                                                              index]
                                                                  .itemCode!);
                                                            } else {
                                                              provid.isEdite =
                                                              false;
                                                              provid
                                                                  .bascet_item[
                                                              index]
                                                                  .isEdite = false;
                                                              provid
                                                                  .bascet_item[
                                                              index]
                                                                  .qty = provid
                                                                  .bascet_item[
                                                              index]
                                                                  .qty <=
                                                                  1
                                                                  ? provid
                                                                  .bascet_item[
                                                              index]
                                                                  .qty
                                                                  : --provid
                                                                  .bascet_item[
                                                              index]
                                                                  .qty;

                                                              provid.updat();
                                                            }
                                                          }
                                                        } else {
                                                          if (provid
                                                              .bascet_item[
                                                          index]
                                                              .itemTypeId ==
                                                              3) {
                                                            expirySheet(provid
                                                                .bascet_item[index]
                                                                .itemCode!);
                                                          } else if (provid
                                                              .bascet_item[
                                                          index]
                                                              .itemTypeId ==
                                                              2) {
                                                            serialSheet(provid
                                                                .bascet_item[index]
                                                                .itemCode!);
                                                          } else {
                                                            provid.isEdite = false;
                                                            provid
                                                                .bascet_item[index]
                                                                .isEdite = false;
                                                            provid.bascet_item[index].qty = provid.bascet_item[index].qty <= 1 ?
                                                            provid.bascet_item[index].qty :
                                                            --provid.bascet_item[index].qty;
                                                            double tempResult = provid.get_total_price() - provid.discount;
                                                            if (provid.isDiscountOnItem == true) {
                                                              if (tempResult < 0) {provid.discountTotalPrice(provid.radioDiscount, 0.0, true);
                                                              provid.isDiscountOnItem = false;
                                                              provid.discount = 0.0;
                                                              fToast.init(context);
                                                              MassageForToast()
                                                                  .massageForAlert(lang!.customDiscountCanNotSubtotal, false, fToast);
                                                              }
                                                            } else if (provid.counterDiscountCheek >= 1) {
                                                              double tempResultItem = provid.getItemTotalPrice(pro.bascet_item[index]) -
                                                                  provid.bascet_item[index].discountValue;
                                                              //print(tempResultItem);
                                                              if (tempResultItem < 0) {
                                                                provid.bascet_item[index]
                                                                    .itemDisccount = 0.0;
                                                                provid
                                                                    .bascet_item[
                                                                  index]
                                                                    .itemDisccountType =
                                                                "fixed";
                                                                provid
                                                                    .counterDiscountCheek--;
                                                                fToast
                                                                    .init(context);
                                                                MassageForToast()
                                                                    .massageForAlert(
                                                                    lang!
                                                                        .customDiscountCanNotSubtotal,
                                                                    false,
                                                                    fToast);
                                                              }
                                                            }
                                                            provid.updat();
                                                          }
                                                        }
                                                      },
                                                      icon:  Icon(
                                                        Icons
                                                            .do_not_disturb_on_outlined,
                                                        size: 45,
                                                        color: basicColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          child: itemlang ==
                                                              const Locale("en")
                                                              ? arbicNameTxT(
                                                              provid
                                                                  .bascet_item[
                                                              index]
                                                                  .latinName
                                                                  .toString(),
                                                              20)
                                                              :
                                                          //Text(provid.bascet_item[index].arabName!,maxLines: 2,),
                                                          arbicNameTxT(
                                                              provid
                                                                  .bascet_item[
                                                              index]
                                                                  .arabName
                                                                  .toString(),
                                                              15),
                                                        ),
                                                        provid.bascet_item[index]
                                                            .expiryItemDate ==
                                                            null? const SizedBox()
                                                        : Text(
                                                          provid.bascet_item[index]
                                                              .expiryItemDate ==
                                                              null
                                                              ? ""
                                                              : provid
                                                              .bascet_item[
                                                          index]
                                                              .expiryItemDate!,
                                                          style: const TextStyle(
                                                              color:
                                                              Colors.redAccent),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (provid.invoiceData
                                                                .edit ==
                                                                true) {
                                                              if (provid.invoiceData
                                                                  .isAccredited! ==
                                                                  true) {
                                                                MassageForToast()
                                                                    .massageForAlert(
                                                                    lang.isAccredited,
                                                                    false,
                                                                    fToast);
                                                              } else if (provid
                                                                  .invoiceData
                                                                  .isDeleted ==
                                                                  true) {
                                                                MassageForToast()
                                                                    .massageForAlert(
                                                                    lang.isDeleted,
                                                                    false,
                                                                    fToast);
                                                              } else if (provid
                                                                  .invoiceData
                                                                  .isCollectionReceipt ==
                                                                  true) {
                                                                MassageForToast()
                                                                    .massageForAlert(
                                                                    lang.isCollectionReceipt,
                                                                    false,
                                                                    fToast);
                                                              } else if (provid.invoiceData.isReturn ==
                                                                  true) {
                                                                MassageForToast().massageForAlert(
                                                                    lang.isReturn, false, fToast);
                                                              }else {
                                                                if (provid
                                                                    .settingGeneral
                                                                    .dataDisVat!
                                                                    .popModifyPrice) {
                                                                  showDialog(
                                                                      context:
                                                                      context,
                                                                      builder: (context) =>
                                                                      // editPriceDialog(
                                                                      //     index));
                                                                      EditPriceDialog(
                                                                        index:
                                                                        index,
                                                                      ));
                                                                }
                                                              }
                                                            } else {
                                                              if (provid
                                                                  .settingGeneral
                                                                  .dataDisVat!
                                                                  .popModifyPrice) {
                                                                showDialog(
                                                                    context:
                                                                    context,
                                                                    builder:
                                                                        (context) =>
                                                                        EditPriceDialog(
                                                                          index:
                                                                          index,
                                                                        ));
                                                              }
                                                            }
                                                          },
                                                          child: provid
                                                              .bascet_item[
                                                          index]
                                                              .oldPrice ==
                                                              0
                                                              ? Text(
                                                              "${lang!.price} : ${provid.bascet_item[index].priceGenrel} ")
                                                              : Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                  "${lang!.price} :  ${provid.bascet_item[index].updatePrice} "),
                                                              Text(
                                                                "${provid.bascet_item[index].oldPrice}",
                                                                style: const TextStyle(
                                                                    decoration:
                                                                    TextDecoration
                                                                        .lineThrough),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        // dropDownWidget(context,index),
                                                        DropDownTest(
                                                          index: index,
                                                        ),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: isDiscount(1)
                                                          ? null
                                                          : () {
                                                        if (provid.invoiceData
                                                            .edit ==
                                                            true) {
                                                          if (provid
                                                              .invoiceData
                                                              .isAccredited! ==
                                                              true) {
                                                            MassageForToast()
                                                                .massageForAlert(
                                                                lang.isAccredited,
                                                                false,
                                                                fToast);
                                                          } else if (provid
                                                              .invoiceData
                                                              .isDeleted ==
                                                              true) {
                                                            MassageForToast()
                                                                .massageForAlert(
                                                                lang.isDeleted,
                                                                false,
                                                                fToast);
                                                          } else if (provid
                                                              .invoiceData
                                                              .isCollectionReceipt ==
                                                              true) {
                                                            MassageForToast()
                                                                .massageForAlert(
                                                                lang.isCollectionReceipt,
                                                                false,
                                                                fToast);
                                                          }else if (provid.invoiceData.isReturn ==
                                                              true) {
                                                            MassageForToast().massageForAlert(
                                                                lang.isReturn, false, fToast);
                                                          } else {
                                                            showDialog(
                                                                context:
                                                                context,
                                                                builder: (context) =>
                                                                    discountDialog(
                                                                        index:
                                                                        index));
                                                          }
                                                        } else {
                                                          showDialog(
                                                              context:
                                                              context,
                                                              builder: (context) =>
                                                                  discountDialog(
                                                                      index:
                                                                      index));
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: isDiscount(1)
                                                              ? Colors.grey
                                                              : basicColor,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              7.r),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                          //i will design dialog for item discount and put its value in text discount
                                                          //provid.bascet_item[index].itemDisccount.toString()
                                                          child: Text(
                                                            "${lang.discount} : ${provid.bascet_item[index].itemDisccountType == "fixed" ? provid.bascet_item[index].itemDisccount.toString() : "${provid.bascet_item[index].itemDisccount.toString()} %"}",
                                                            style: const TextStyle(
                                                                color: Colors.white,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      //there is condition lost
                                                      " ${lang.subtotal.toString()}  :   ${provid.bascet_item[index].itemDisccount == 0 ? provid.getItemTotalPrice(provid.bascet_item[index]) : provid.itemDiscountFn(provid.bascet_item[index].itemDisccountType, provid.bascet_item[index].itemDisccount, provid.bascet_item[index])}",
                                                      textAlign: TextAlign.start,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if (provid
                                                            .invoiceData.edit ==
                                                            true) {
                                                          if (provid.invoiceData
                                                              .isAccredited! ==
                                                              true) {
                                                            MassageForToast()
                                                                .massageForAlert(
                                                                lang.isAccredited,
                                                                false,
                                                                fToast);
                                                          } else if (provid
                                                              .invoiceData
                                                              .isDeleted ==
                                                              true) {
                                                            MassageForToast()
                                                                .massageForAlert(
                                                                lang.isDeleted,
                                                                false,
                                                                fToast);
                                                          } else if (provid
                                                              .invoiceData
                                                              .isCollectionReceipt ==
                                                              true) {
                                                            MassageForToast()
                                                                .massageForAlert(
                                                                lang.isCollectionReceipt,
                                                                false,
                                                                fToast);
                                                          }else if (provid.invoiceData.isReturn ==
                                                              true) {
                                                            MassageForToast().massageForAlert(
                                                                lang.isReturn, false, fToast);
                                                          } else {
                                                            showDialog(
                                                                context: context,
                                                                builder: (context) =>
                                                                    WarningMassage(
                                                                        index:
                                                                        index,
                                                                        massage: lang
                                                                            .warningmassegeitem
                                                                            .toString()));
                                                          }
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  WarningMassage(
                                                                      index: index,
                                                                      massage: lang
                                                                          .warningmassegeitem
                                                                          .toString()));
                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            lang.delete.toString(),
                                                            style: const TextStyle(
                                                                color: Colors.red),
                                                          ),
                                                          const Icon(
                                                            Icons.delete_sweep,
                                                            color: Colors.red,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  provid.settingGeneral.activeDiscountG == true
                                      ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.0, bottom: 3.0),
                                    child: discountPersintage(),
                                  )
                                      : const Text(
                                    "",
                                    style: TextStyle(fontSize: 0),
                                  ),
                                  const Padding(
                                    padding:  EdgeInsets.only(
                                        bottom: 2.0, left: 3.0, right: 3.0),
                                    child:
                                    //receiptDesign(),
                                    ReceiptDesign(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 15,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: basicColor,
                        ),
                        onPressed: () {
                          if (provid.invoiceData.edit == true) {
                            if (provid.invoiceData.isAccredited! == true) {
                              MassageForToast().massageForAlert(
                                  lang.isAccredited, false, fToast);
                            } else if (provid.invoiceData.isDeleted == true) {
                              MassageForToast()
                                  .massageForAlert(lang.isDeleted, false, fToast);
                            } else if (provid.invoiceData.isCollectionReceipt ==
                                true) {
                              MassageForToast().massageForAlert(
                                  lang.isCollectionReceipt, false, fToast);
                            }
                            else if (provid.invoiceData.isReturn ==
                                true) {
                              MassageForToast().massageForAlert(
                                  lang.isReturn, false, fToast);
                            }
                            else {
                              Navigator.pushNamed(context, ConfirmPayment.rout);
                            }
                          } else {
                            Navigator.pushNamed(context, ConfirmPayment.rout);
                          }
                        },
                        child: Text(
                          lang!.confirmPayment,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else {
            return const Center( child:CircularProgressIndicator(),);
          }
        }
      },
    );
  }

  dynamic expirySheet(String itemCode) {
    // print("the item code is ${itemCode}");

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ExpiryItemSheet(itemCode: itemCode),
          );
        });
  }

  dynamic serialSheet(String itemCode) {
    //print("item code is ${itemCode}");
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SerialItem(
              itemCode: itemCode,
            ),
          );
        });
  }

  Widget arbicNameTxT(String name, int length) {
    //if (name.length > length) {
      return Text(
        name,maxLines: 2,
        style: TextStyle(fontSize: 16.sp),
      );
    // } else {
    //   return FittedBox(
    //     fit: BoxFit.contain,
    //     child: Text(
    //       name,
    //       style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
    //     ),
    //   );
    // }
  }

  // Widget receiptDesign() {
  //   var lang = AppLocalizations.of(context);
  //   var receiptProvvider = Provider.of<Cart_Items>(context);
  //   double fontSize = 15.sp;
  //   return Card(
  //     elevation: 7,
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding:  EdgeInsets.symmetric(horizontal: 15.w),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Flexible(
  //                 child: Text(lang!.subtotal.toString(),
  //                     style: TextStyle(fontSize: fontSize)),
  //               ),
  //               Flexible(
  //                 child: Text(
  //                     "${receiptProvvider.getTotalwitoutDiscount().toString()}  ${lang.sr}", //get total price with out vat and discount
  //                     style: TextStyle(fontSize: fontSize)),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding:  EdgeInsets.symmetric(horizontal: 15.w),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Flexible(
  //                 child: Text("${lang.tax.toString()} : ",
  //                     style: TextStyle(fontSize: fontSize)),
  //               ),
  //               Flexible(
  //                 child: Text(
  //                     " ${receiptProvvider.getTotals(false).totalVat}   ${lang.sr}"),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding:  EdgeInsets.symmetric(horizontal: 15.w),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Flexible(
  //                 child: Text(lang.discount.toString(),
  //                     style: TextStyle(fontSize: fontSize)),
  //               ),
  //               Flexible(
  //                 child: Text(
  //                     "${receiptProvvider.getTotalDiscountValue().toString()}   ${lang.sr}", // get discount value
  //                     style: TextStyle(fontSize: fontSize)),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding:  EdgeInsets.symmetric(horizontal: 11.w),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Flexible(
  //                 child: Text(
  //                   "${lang.grandtotal.toString()} : ",
  //                   style:
  //                       TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //               Flexible(
  //                 flex: 2,
  //                 child: Text(
  //                   " ${receiptProvvider.getTotals(false).net.toString()}  ${lang.sr}",
  //                   style: TextStyle(
  //                       fontSize: 16.sp,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.red),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void getClientPopUpData([int scrol = 0]) {
    GetPersonDropDown().getPersonDropDown(pageNumber, pageSize).then((value) {
      //setState(() {
      personDropDownList = value;
      if (personDropDownList.data != null ||
          personDropDownList.data!.length < pageSize) {
        tempList.addAll(value.data);
        tempList2.addAll(value.data);
        if (scrol == 1) {
          overlayEntry.markNeedsBuild();
        } else {
          overlayEntry.markNeedsBuild();
        }

        //isLoading = true;
      } else if (value.result == 1 || value.data == null) {
        if (scrol == 1) {
          overlayEntry.markNeedsBuild();
        }
        isLoading = false;
      }
    });
  }

  Widget clientNameText(Function(void Function()) myBasicState) {
    // var lang = AppLocalizations.of(context);
    var provid =Provider.of<Cart_Items>(context,listen: false);
    //print("the focus node is equal ${clientFocus}");
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 40.h,
          //maxWidth: 30.w,
        ),
        //height:
        child: TextFormField(
          style:TextStyle(fontSize:13.sp),
          focusNode: clientFocus,
          enabled:provid.returnInvoice == true? false : true ,
          controller: clientController,
          scrollController: clintTextFieldScrollController,
          decoration: InputDecoration(
            //: TextStyle(fontSize: 10.sp),
            //labelStyle: TextStyle(fontSize: 5.0),
            //style
            contentPadding:
                EdgeInsets.symmetric(vertical: -14.h, horizontal: 6.w),
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue),
            ),
          ),
          onTap:(){
            tempList2.clear();
            tempList.clear();
            getClientPopUpData();

          },
          onChanged: (val) {
            //visible = true;
            filterSearchResults(val);
            // overlayEntry.remove();
            // overlayEntry=createDropdownDesign(myBasicState);
            // Overlay.of(context).insert(overlayEntry);
            overlayEntry.markNeedsBuild();
            // print("the value $val");
            //myBasicState(() {});
          },
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    //setState(() {
    tempList2 = tempList
        .where((item) =>
            item.arabicName!.toLowerCase().contains(query.toLowerCase()) ||
            item.latinName!.contains(query.toString()))
        .toList();
    //});
  }

  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        personDropDownList.data!.length >= pageSize) {
      isLoading = true;
      //setState(() {});
      pageNumber++;
      //print("page number is in scroll listener $pageNumber");
      getClientPopUpData(1);
    }
  }

  void  focusListener(FocusNode focusNode) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        overlayEntry = createDropdownDesign(setState);
        Overlay.of(context).insert(overlayEntry);
      } else {
        if (clientController.text.isEmpty) {
          var pro = Provider.of<Cart_Items>(context, listen: false);
          String personMassege =
              Provider.of<modelprovider>(context, listen: false).applocal ==
                      const Locale("ar")
                  ? pro.personId.arabicName!
                  : pro.personId.latinName!;
          clientController.text = personMassege;
          overlayEntry.remove();
        }
        else if(Provider.of<Cart_Items>(context,listen: false).returnInvoice == false){
          overlayEntry.remove();
        }
      }
    });
  }

  OverlayEntry createDropdownDesign(Function(void Function()) myBasicState) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        width: MediaQuery.of(context).size.width / 1.56,
        top: 79.h,
        left: 60.w,
        child: Material(
          color: Colors.transparent,
          elevation: 4.0,
          child: listViewDesign(myBasicState),
        ),
      );
    });
  }

  Widget listViewDesign(Function(void Function()) myBasicState) {
    var provider = Provider.of<Cart_Items>(context, listen: false);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height / 4.5,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.grey,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: tempList2.isNotEmpty
          ? RawScrollbar(
              controller: scrollController,
              radius: const Radius.circular(4),
              thumbColor: Colors.blue,
              thumbVisibility: true,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: tempList2.length,
                  itemBuilder: (context, index) {
                    if (index < tempList2.length) {
                      String? massage =
                          Provider.of<modelprovider>(context).applocal ==
                                  const Locale('ar')
                              ? tempList2[index].arabicName
                              : tempList2[index].latinName;
                      //print("the index $index the massage $massage");
                      //print("massage $massage");
                      return Card(
                        margin: const EdgeInsets.all(0.20),
                        color: Colors.white,
                        child: ListTile(
                            onTap: () {
                              if (mounted) {
                                myBasicState(() {
                                  provider.personId = tempList2[index];
                                  clientController.text = massage.length > 20
                                      ? massage.substring(0, 20)
                                      : massage;
                                  clintTextFieldScrollController.jumpTo(0);
                                  //visible = false;
                                  clientFocus.unfocus();
                                  //overlayEntry.remove();
                                });
                              }
                            },
                            // tileColor: Colors,
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -1),
                            title: Text(
                              massage!,
                              style: const TextStyle(color: Colors.black54),
                            )),
                      );
                    } else {
                      overlayEntry.markNeedsBuild();
                      return const  Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          :const  Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  bool isDiscount(int val) {

    var value = Provider.of<Cart_Items>(context);
    if (value.settingGeneral.activeDiscountG == false ) {
      return true;
    } else {
      if (val == 1) {
        if (value.isDiscountOnItem == true ) {
          return true;
        }
        // else if(){
        //   return true;
        // }
        else {
          return false;
        }
      } else {
        if (value.counterDiscountCheek != 0) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (context.mounted) {
      super.setState(fn);
    }
  }

  Widget discountPersintage() {
    // bool isSetState=false;
    var lang = AppLocalizations.of(context);
    var provid = Provider.of<Cart_Items>(context, listen: false);

    bool deleteAndAccredited = false;
    if (provid.invoiceData.edit == true) {
      if (provid.invoiceData.isAccredited == true ||
          provid.invoiceData.isDeleted == true ||
          provid.invoiceData.isCollectionReceipt == true || provid.invoiceData.isReturn==true) {
        deleteAndAccredited = true;
      }
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0, left: 10.0, right: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio(
                    activeColor: Colors.indigo,
                    value: "fixed",
                    groupValue: radioValue,
                    onChanged: (val) {
                      if (provid.invoiceData.edit == true) {
                        if (provid.invoiceData.isAccredited! == true) {
                          MassageForToast().massageForAlert(
                              lang!.isAccredited, false, fToast);
                        } else if (provid.invoiceData.isDeleted == true) {
                          MassageForToast()
                              .massageForAlert(lang!.isDeleted, false, fToast);
                        } else if (provid.invoiceData.isCollectionReceipt ==
                            true) {
                          MassageForToast().massageForAlert(
                              lang!.isCollectionReceipt, false, fToast);
                        } else if (provid.invoiceData.isReturn ==
                            true) {
                          MassageForToast().massageForAlert(
                              lang!.isReturn, false, fToast);
                        }else {
                          radioValue = val!;
                        }
                      } else {
                        radioValue = val!;
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                Text(
                  lang!.fixed.toString(),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Radio(
                    activeColor: Colors.indigo,
                    value: "percentage",
                    groupValue: radioValue,
                    onChanged: (val) {
                      if (provid.invoiceData.edit == true) {
                        if (provid.invoiceData.isAccredited! == true) {
                          MassageForToast().massageForAlert(
                              lang.isAccredited, false, fToast);
                        } else if (provid.invoiceData.isDeleted == true) {
                          MassageForToast()
                              .massageForAlert(lang.isDeleted, false, fToast);
                        } else if (provid.invoiceData.isCollectionReceipt ==
                            true) {
                          MassageForToast().massageForAlert(
                              lang.isCollectionReceipt, false, fToast);
                        } else if (provid.invoiceData.isReturn ==
                            true) {
                          MassageForToast().massageForAlert(
                              lang.isReturn, false, fToast);
                        }else {
                          radioValue = val!;
                        }
                      } else {
                        radioValue = val!;
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                Text(
                  lang.percentage.toString(),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // SizedBox(
            //   width: 10.w,
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                lang.discount.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: SizedBox(
                    height: 36.h,
                    child: TextFormField(
                      controller: discountTxT,
                      //style: TextStyle(),
                      enabled: provid.counterDiscountCheek == 0 &&
                              provid.settingGeneral.activeDiscountG == true &&
                              deleteAndAccredited == false
                          ? true
                          : false,
                      textAlign: TextAlign.center,
                      decoration: text_field_styleDiscount("0.0"),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        //FilteringTextInputFormatter.digitsOnly,
                         DecimalTextInputFormatter(
                             decimalRange: provid.settingGeneral.roundNumG!),
                        FilteringTextInputFormatter.allow(RegExp(r'^[\d,.]*$')),
                      ],
                      //textAlign:Provider.of<modelprovider>(context,listen: false).applocal ==const Locale('en')? TextAlign.right : TextAlign.left,
                      textDirection: TextDirection.ltr,
                      // onChanged: (ch){
                      //   // if(ch.isEmpty || ch=="" || double.parse(ch)== 0 ){
                      //   //   if(isSetState ==true ){
                      //   //     setState(() { });
                      //   //     isSetState =false;
                      //   //   }
                      //   // }
                      //   // else if( isSetState==false){
                      //   //   isSetState = true;
                      //   //   setState(() {});
                      //   // }
                      //   //setState(() { });
                      // },
                      onTap: () {
                        if (provid.invoiceData.edit == true) {
                          if (provid.invoiceData.isAccredited! == true) {
                            MassageForToast().massageForAlert(
                                lang.isAccredited, false, fToast);
                          } else if (provid.invoiceData.isDeleted == true) {
                            MassageForToast()
                                .massageForAlert(lang.isDeleted, false, fToast);
                          } else if (provid.invoiceData.isCollectionReceipt ==
                              true) {
                            MassageForToast().massageForAlert(
                                lang.isReturn, false, fToast);
                          }
                          else if (provid.invoiceData.isReturn ==
                              true) {
                            MassageForToast().massageForAlert(
                                lang.isReturn, false, fToast);
                          }
                        }
                      },
                    ),
                  ),
                ),
                IconButton(
                    onPressed: provid.counterDiscountCheek != 0
                        ? null
                        :  () {
                      if(discountTxT.text.isEmpty || discountTxT.text=="" || double.parse(discountTxT.text)==0) {

                      }
                      else{
                        if (provid.invoiceData.edit == true) {
                          if (provid.invoiceData.isAccredited! == true) {
                            MassageForToast().massageForAlert(
                                lang.isAccredited, false, fToast);
                          } else if (provid.invoiceData.isDeleted == true) {
                            MassageForToast().massageForAlert(
                                lang.isDeleted, false, fToast);
                          } else if (provid
                              .invoiceData.isCollectionReceipt ==
                              true) {
                            MassageForToast().massageForAlert(
                                lang.isCollectionReceipt, false, fToast);
                          } else if (provid.invoiceData.isReturn ==
                              true) {
                            MassageForToast().massageForAlert(
                                lang.isReturn, false, fToast);
                          }else {
                            provid.isEdite = false;
                            //provid.bascet_item[]
                            double tempResult = provid.get_total_price() -
                                double.parse(discountTxT.text.isEmpty
                                    ? "0"
                                    : discountTxT.text);
                            if (provid.isDiscountOnItem == false &&
                                provid.settingGeneral.activeDiscountG ==
                                    true) {
                              if (radioValue == "percentage") {
                                disccountBtn = true;
                                if (discountTxT.text.isNotEmpty) {
                                  provid.discount = double.parse(
                                      discountTxT.text.isEmpty
                                          ? "0"
                                          : discountTxT.text);
                                  provid.radioDiscount = radioValue;
                                  provid.discountTotalPrice(
                                      radioValue,
                                      double.parse(discountTxT.text.isEmpty
                                          ? "0"
                                          : discountTxT.text),
                                      true);
                                } else {
                                  provid.discountTotalPrice(
                                      radioValue, 0.0, true);
                                  provid.discount = 0.0;
                                  //pro.radioDiscount = "";
                                }
                                provid.isDiscountOnItem = true;
                              } else {
                                if (tempResult >= 0 &&
                                    double.parse(discountTxT.text) > 0.0) {
                                  disccountBtn = true;
                                  if (discountTxT.text.isNotEmpty) {
                                    provid.discount =
                                        double.parse(discountTxT.text);
                                    provid.radioDiscount = radioValue;
                                    provid.discountTotalPrice(
                                        radioValue,
                                        double.parse(
                                            discountTxT.text.toString()),
                                        true);
                                  } else {
                                    provid.discountTotalPrice(
                                        radioValue, 0.0, true);
                                    provid.discount = 0.0;
                                    //pro.radioDiscount = "";
                                  }
                                  provid.isDiscountOnItem = true;
                                } else {
                                  discountTxT.clear();
                                  // const snackBar = SnackBar(
                                  //   content: Text(
                                  //       'Custom Discount can not be more than subtotal '),
                                  //   duration: Duration(seconds: 2),
                                  // );
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(snackBar);
                                  fToast.init(context);
                                  MassageForToast().massageForAlert(
                                      lang.customDiscountCanNotSubtotal,
                                      false,
                                      fToast);
                                }
                              }
                              //pro.updat();
                            } else {
                              provid.discountTotalPrice(
                                  radioValue, 0.0, true);
                              provid.discount = 0.0;
                              discountTxT.clear();
                              provid.isDiscountOnItem = false;

                              //pro.updat();
                            }
                          }
                        } else {
                          provid.isEdite = false;
                          double tempResult = provid.get_total_price() -
                              double.parse(discountTxT.text.isEmpty
                                  ? "0"
                                  : discountTxT.text);
                          if (provid.isDiscountOnItem == false &&
                              provid.settingGeneral.activeDiscountG ==
                                  true) {
                            if (radioValue == "percentage") {
                              if (double.parse(discountTxT.text.isEmpty
                                  ? "0"
                                  : discountTxT.text) <=
                                  100) {
                                disccountBtn = true;
                                if (discountTxT.text.isNotEmpty) {
                                  provid.discount =
                                      double.parse(discountTxT.text);
                                  provid.radioDiscount = radioValue;
                                  provid.discountTotalPrice(
                                      radioValue,
                                      double.parse(discountTxT.text.isEmpty
                                          ? "0"
                                          : discountTxT.text),
                                      true);
                                } else {
                                  provid.discountTotalPrice(
                                      radioValue, 0.0, true);
                                  provid.discount = 0.0;
                                  //pro.radioDiscount = "";
                                }
                                provid.isDiscountOnItem = true;
                              } else {
                                discountTxT.clear();
                                fToast.init(context);
                                MassageForToast().massageForAlert(
                                    lang.customDiscountCanNotMorePercent,
                                    false,
                                    fToast);
                              }
                            } else {
                              if (tempResult >= 0 &&
                                  double.parse(discountTxT.text.isEmpty
                                      ? "0"
                                      : discountTxT.text) >
                                      0.0) {
                                // if(radioValue == "percentage" && double.parse(discountTxT.text )<=100){
                                //
                                //
                                // }
                                disccountBtn = true;
                                if (discountTxT.text.isNotEmpty) {
                                  provid.discount = double.parse(
                                      discountTxT.text.isEmpty
                                          ? "0"
                                          : discountTxT.text);
                                  provid.radioDiscount = radioValue;
                                  provid.discountTotalPrice(
                                      radioValue,
                                      double.parse(discountTxT.text.isEmpty
                                          ? "0"
                                          : discountTxT.text),
                                      true);
                                } else {
                                  provid.discountTotalPrice(
                                      radioValue, 0.0, true);
                                  provid.discount = 0.0;
                                  //pro.radioDiscount = "";
                                }
                                provid.isDiscountOnItem = true;
                              } else {
                                discountTxT.clear();
                                // const snackBar = SnackBar(
                                //   content: Text(
                                //       'Custom Discount can not be more than subtotal !!'),
                                //   duration: Duration(seconds: 3),
                                // );
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(snackBar);
                                fToast.init(context);
                                MassageForToast().massageForAlert(
                                    lang.customDiscountCanNotSubtotal,
                                    false,
                                    fToast);
                              }
                            }
                            //pro.updat();
                          } else {
                            provid.discountTotalPrice(
                                radioValue, 0.0, true);
                            provid.discount = 0.0;
                            discountTxT.clear();
                            provid.isDiscountOnItem = false;

                            //pro.updat();
                          }
                        }
                      }
                          },
                    icon: Provider.of<Cart_Items>(context).isDiscountOnItem
                        ? const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.save,
                            color: isDiscount(2) ? Colors.grey : basicColor,
                          ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget editPriceDialog(int index) {
  //   var lang = AppLocalizations.of(context);
  //   return Consumer<Cart_Items>(builder: (context, pro, child) {
  //     return Dialog(
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
  //       child: Form(
  //         key: formkey,
  //         child: SizedBox(
  //           height: 260.h,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Container(
  //                 height: 50.h,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(5.r),
  //                     topRight: Radius.circular(5.r),
  //                   ),
  //                   color: Colors.indigo,
  //                 ),
  //                 alignment: Alignment.center,
  //                 child: Center(
  //                   child: Text(
  //                     "${lang!.edit.toString()} ${lang.price.toString()}",
  //                     style: TextStyle(
  //                         fontSize: 25.sp, fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 padding: const EdgeInsets.only(top: 30, bottom: 30),
  //                 width: 130.w,
  //                 child: TextFormField(
  //                   controller: textPriceControler,
  //                   textAlign: TextAlign.center,
  //                   autofocus: true,
  //                   decoration: text_field_style(lang.price.toString()),
  //                   keyboardType: TextInputType.number,
  //                   inputFormatters: [
  //                     FilteringTextInputFormatter.digitsOnly,
  //                     LengthLimitingTextInputFormatter(4),
  //                   ],
  //                   textDirection: TextDirection.ltr,
  //                   validator: (val) {
  //                     if (val!.isEmpty) {
  //                       return "please fill the text";
  //                     } else {
  //                       return null;
  //                     }
  //                   },
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(13.0),
  //                 child: SizedBox(
  //                   height: 50.h,
  //                   width: 110.w,
  //                   child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.indigo,
  //                       ),
  //                       onPressed: () {
  //                         // pro.editPrice(pro.bascet_item[index],
  //                         //     double.parse(textPriceControler.text.toString()));
  //                         pro.isEdite=false;
  //                         if (formkey.currentState!.validate()) {
  //                           pro.bascet_item[index].oldPrice = pro
  //                                   .bascet_item[index].units.isEmpty
  //                               ? 0.0
  //                               : pro.bascet_item[index].units[0].salePrice1!;
  //                           pro.bascet_item[index].updatePrice =
  //                               textPriceControler.text.isEmpty
  //                                   ? 0.0
  //                                   : double.parse(
  //                                       textPriceControler.text.toString());
  //                           pro.updat();
  //                           textPriceControler.clear();
  //
  //                           Navigator.of(context).pop();
  //                         }
  //                       },
  //                       child: Text(lang.confirm.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }

  // InputDecoration text_field_style(String hint) {
  //   return InputDecoration(
  //       hintText: hint,
  //       filled: true,
  //       fillColor: Colors.white70,
  //       enabledBorder: OutlineInputBorder(
  //         borderSide: const BorderSide(color: Colors.black26),
  //         borderRadius: BorderRadius.circular(7.r),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: Colors.black, width: 1.w),
  //         borderRadius: BorderRadius.circular(7.r),
  //       ));
  // }

  InputDecoration text_field_styleDiscount(String hint) {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 6.0.h),
        hintText: hint,
        filled: true,
        fillColor: Colors.white70,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(7.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.w),
          borderRadius: BorderRadius.circular(7.r),
        ));
  }
}

//ignore: must_be_immutable
class discountDialog extends StatefulWidget {
  int index;
  discountDialog({super.key, required this.index});

  @override
  State<discountDialog> createState() => _discountDialogState();
}

class _discountDialogState extends State<discountDialog> {
  final formkey = GlobalKey<FormState>();
  FToast fToast = FToast();
  TextEditingController itemDiscountTXT = TextEditingController();
  String itemDisccountRadio = "fixed";
  bool itemDiscountBtn = false;
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fToast.init(context);
    itemDisccountRadio = Provider.of<Cart_Items>(context, listen: false)
        .bascet_item[widget.index]
        .itemDisccountType;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    itemDiscountTXT.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var temp = Provider.of<Cart_Items>(context, listen: false);

    var lang = AppLocalizations.of(context);
    if (temp.bascet_item[widget.index].itemDisccount > 0.0) {
      itemDiscountTXT.text =
          temp.bascet_item[widget.index].itemDisccount.toString();
      // itemDisccountRadio=temp.bascet_item[widget.index].itemDisccountType;
      itemDiscountBtn = true;
    }
    itemDiscountTXT.selection = TextSelection(
      baseOffset: 0,
      extentOffset: itemDiscountTXT.text.length,
    );
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child:
            // StatefulBuilder(builder: (context, setState) {
            // return
            Form(
          key: formkey,
          child: SizedBox(
            height: 250.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.r),
                      topRight: Radius.circular(5.r),
                    ),
                    color: Colors.indigo,
                  ),
                  // alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      lang!.itemdiscount.toString(),
                      style: TextStyle(
                          fontSize: 26.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                        value: "fixed",
                        groupValue: itemDisccountRadio,
                        activeColor: Colors.black,
                        onChanged: (val) {
                          if (mounted) {
                            setState(() {
                              itemDisccountRadio = val!;
                            });
                          }
                        }),
                    Text(
                      lang.fixed.toString(),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Radio(
                        value: "percentage",
                        groupValue: itemDisccountRadio,
                        activeColor: Colors.black,
                        onChanged: (val) {
                          if (mounted) {
                            setState(() {
                              itemDisccountRadio = val!;
                            });
                          }
                        }),
                    Text(
                      lang.percentage.toString(),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                //}),
                Container(
                  padding: const EdgeInsets.only(top: 12, bottom: 25),
                  width: 130.w,
                  child: TextFormField(
                    controller: itemDiscountTXT,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    inputFormatters: [
                      //FilteringTextInputFormatter.digitsOnly,
                      //
                      // LengthLimitingTextInputFormatter(4),
                      DecimalTextInputFormatter(
                          decimalRange: temp.settingGeneral.roundNumG!),
                      FilteringTextInputFormatter.allow(RegExp(r'^[\d,.]*$')),
                    ],
                    decoration:
                        text_field_style("${lang.discount.toString()}:"),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textDirection: TextDirection.ltr,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return lang.pleaseFillText;
                      } else if (val == "0") {
                        return lang.discount;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                disccountButtonforItem(widget.index),
              ],
            ),
          ),
        ));
  }

  Widget disccountButtonforItem(int index) {
    var lang = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: itemDiscountBtn
          ? MainAxisAlignment.spaceAround
          : MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.,
      children: [
        itemDiscountBtn == true
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40.h,
                  width: 110.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                    ),
                    onPressed: () {
                      var discountProvider =
                          Provider.of<Cart_Items>(context, listen: false);
                      discountProvider.isEdite = false;
                      discountProvider.isEdite = false;
                      discountProvider.bascet_item[index].itemDisccount = 0.0;
                      discountProvider.counterDiscountCheek--;
                      discountProvider.updat();
                      itemDiscountBtn = false;

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      lang!.remove.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 0.00000001.h,
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 40.h,
            width: 110.w,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                onPressed: () {
                  var discountProvider =
                      Provider.of<Cart_Items>(context, listen: false);
                  discountProvider.isEdite = false;
                  if (formkey.currentState!.validate()) {
                    //itemDiscountBtn = true;
                    if (double.parse(itemDiscountTXT.text.toString()) > 0) {
                      if (itemDisccountRadio.toString() == "percentage") {
                        if (double.parse(itemDiscountTXT.text.isEmpty
                                ? "0"
                                : itemDiscountTXT.text) <=
                            100) {
                          discountProvider.bascet_item[index].itemDisccount =
                              double.parse(itemDiscountTXT.text.toString());
                          discountProvider
                                  .bascet_item[index].itemDisccountType =
                              itemDisccountRadio.toString();
                          discountProvider.counterDiscountCheek++;
                          discountProvider.bascet_item[index].isEdite = false;
                          discountProvider.updat();

                          itemDiscountBtn = true;
                          Navigator.of(context).pop(true);
                        } else {
                          discountProvider.bascet_item[index].isEdite = false;
                          itemDiscountTXT.clear();
                          fToast.init(context);
                          MassageForToast().massageForAlert(
                              lang.customDiscountCanNotMorePercent,
                              false,
                              fToast);
                        }
                      } else {
                        discountProvider.bascet_item[index].isEdite = false;
                        if (double.parse(itemDiscountTXT.text.toString()) <=
                            discountProvider.getItemTotalPrice(
                                discountProvider.bascet_item[index])) {
                          discountProvider.bascet_item[index].itemDisccount =
                              double.parse(itemDiscountTXT.text.toString());
                          discountProvider
                                  .bascet_item[index].itemDisccountType =
                              itemDisccountRadio.toString();
                          discountProvider.counterDiscountCheek++;
                          discountProvider.updat();

                          itemDiscountBtn = true;
                          Navigator.of(context).pop(true);
                        } else {
                          itemDiscountTXT.clear();
                          fToast.init(context);
                          MassageForToast().massageForAlert(
                              lang.customDiscountCanNotSubtotal, false, fToast);
                        }
                      }
                    } else {
                      discountProvider.bascet_item[index].isEdite = false;
                      itemDiscountTXT.clear();
                      fToast.init(context);
                      MassageForToast().massageForAlert(
                          lang.discountShouldBiger, false, fToast);
                    }
                  }
                },
                child: Text(lang!.confirm.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
          ),
        ),
      ],
    );
  }
}

InputDecoration text_field_style(String hint) {
  return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white60,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black26),
        borderRadius: BorderRadius.circular(7.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.w),
        borderRadius: BorderRadius.circular(7.r),
      ));
}

class DropDownTest extends StatelessWidget {
  int? index;
  DropDownTest({super.key, this.index});

  FToast fToast=FToast();
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, myState) {
      return dropDownWidget(context, index!, myState);
    });
  }

  Widget dropDownWidget(
      BuildContext context, int index, Function(void Function()) myState) {
    var provid = Provider.of<Cart_Items>(context, listen: false);
    String unitName = "";

    if (provid.bascet_item[index].units.isNotEmpty &&
        provid.bascet_item[index].units.length == 1) {
      provid.bascet_item[index].dropDownValue =
          provid.bascet_item[index].units[0];
      unitName = Provider.of<modelprovider>(context, listen: false).applocal ==
              const Locale("ar")
          ? provid.bascet_item[index].units[0].arabName!
          : provid.bascet_item[index].units[0].latinName!;
      // provid.updat();
    } else if (provid.bascet_item[index].units.isEmpty) {
      unitName = Provider.of<modelprovider>(context, listen: false).applocal ==
              const Locale("ar")
          ? provid.bascet_item[index].dropDownValue!.arabName!
          : provid.bascet_item[index].dropDownValue!.latinName!;
      //provid.updat();
    }
    int inn = provid.bascet_item[index].dropDownIndex;

    return provid.bascet_item[index].units.length > 1
        ? DropdownButton(
            value: provid.bascet_item[index].dropDownValue == null
                ? provid.bascet_item[index].units[inn]
                : provid.bascet_item[index].dropDownValue,
            icon:  Icon(
              Icons.keyboard_arrow_down,
              size: 30,
              color: basicColor,
            ),
            items: provid.bascet_item[index].units.isEmpty
                ? null
                : provid.bascet_item[index].units.map((item) {
                    return DropdownMenuItem<Unit>(
                      value: item,
                      child: Text(
                        item.arabName.toString(),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
            onChanged: (item) {
              myState(() {
                // if(provid.settingGeneral.editeInvoice==true){
                //   provid.invoiceData.invoiceDetails![index].unitId = item!.unitId;
                // }

                provid.bascet_item[index].dropDownValue = item;
                provid.bascet_item[index].qty =
                    1; //to reset the counter with click on the units type
                provid.bascet_item[index].oldPrice = 0 ;
                provid.bascet_item[index].updatePrice=0;
                provid.isEdite = false;
                provid.bascet_item[index].isEdite = false;
                discountCheck( index, context, fToast);
                provid.updat();
              });
            },
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              unitName,
              style: TextStyle(fontSize: 20.sp),
            ),
          );
  }
}

class ReceiptDesign extends StatelessWidget {
  const ReceiptDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return receiptDesign(context);
  }

  Widget receiptDesign(BuildContext context) {
    var lang = AppLocalizations.of(context);
    var receiptProvvider = Provider.of<Cart_Items>(context);
    double fontSize = 15.sp;
    return Card(
      elevation: 7,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(lang!.subtotal.toString(),
                      style: TextStyle(fontSize: fontSize)),
                ),
                Flexible(
                  child: Text(
                      "${receiptProvvider.getTotalwitoutDiscount().toString()}  ${lang.sr}", //get total price with out vat and discount
                      style: TextStyle(fontSize: fontSize)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(lang.discount.toString(),
                      style: TextStyle(fontSize: fontSize)),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                      "${receiptProvvider.getTotalDiscountValue().toString()}   ${lang.sr}", // get discount value
                      style: TextStyle(fontSize: fontSize)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text("${lang.tax.toString()} : ",
                      style: TextStyle(fontSize: fontSize)),
                ),
                Flexible(
                  child: Text(
                      " ${receiptProvvider.getTotals(false).totalVatShowing}   ${lang.sr}"),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "${lang.grandtotal.toString()} : ",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    " ${receiptProvvider.getTotals(false).net.toString()}  ${lang.sr}",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditPriceDialog extends StatefulWidget {
  int? index;
  EditPriceDialog({super.key, this.index});

  @override
  State<EditPriceDialog> createState() => _EditPriceDialogState();
}

class _EditPriceDialogState extends State<EditPriceDialog> {
  TextEditingController textPriceControler = TextEditingController();
  FToast fToast = FToast();

  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return editPriceDialog(widget.index!, context);
  }

  Widget editPriceDialog(int index, BuildContext context) {
    var lang = AppLocalizations.of(context);
    return Consumer<Cart_Items>(builder: (context, pro, child) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: Form(
          key: formkey,
          child: SizedBox(
            height: 260.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.r),
                      topRight: Radius.circular(5.r),
                    ),
                    color: Colors.indigo,
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      "${lang!.edit.toString()} ${lang.price.toString()}",
                      style: TextStyle(
                          fontSize: 25.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  width: 130.w,
                  child: TextFormField(
                    controller: textPriceControler,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    decoration: text_field_style(lang.price.toString()),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                     // FilteringTextInputFormatter.digitsOnly,
                      DecimalTextInputFormatter(decimalRange: pro.settingGeneral.roundNumG!),
                      FilteringTextInputFormatter.allow(RegExp(r'^[\d,.]*$')),
                     // LengthLimitingTextInputFormatter(7),
                    ],
                    textDirection: TextDirection.ltr,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return lang.pleaseFillText;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: SizedBox(
                    height: 50.h,
                    width: 110.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      onPressed: () {
                        // pro.editPrice(pro.bascet_item[index],
                        //     double.parse(textPriceControler.text.toString()));
                        pro.isEdite = false;
                        if (formkey.currentState!.validate()) {
                          pro.bascet_item[index].isEdite = false;

                          pro.bascet_item[index].oldPrice =
                              pro.bascet_item[index].units.isEmpty
                                  ? 0.0
                                  : pro.bascet_item[index].units[0].salePrice1!;
                          pro.bascet_item[index].updatePrice =
                              textPriceControler.text.isEmpty
                                  ? 0.0
                                  : double.parse(
                                      textPriceControler.text.toString());
                          discountCheck( index, context, fToast);
                          // double tempResult =
                          //     pro.get_total_price() - pro.discount;
                          // if (pro.isDiscountOnItem == true) {
                          //   if (tempResult < 0) {
                          //     pro.discountTotalPrice(
                          //         pro.radioDiscount, 0.0, true);
                          //     pro.isDiscountOnItem = false;
                          //     pro.discount = 0.0;
                          //     fToast.init(context);
                          //     MassageForToast().massageForAlert(
                          //         lang.customDiscountCanNotSubtotal,
                          //         false,
                          //         fToast);
                          //   }
                          // } else if (pro.counterDiscountCheek >= 1) {
                          //   double tempResultItem =
                          //       pro.getItemTotalPrice(pro.bascet_item[index]) -
                          //           pro.bascet_item[index].discountValue;
                          //   //print(tempResultItem);
                          //   if (tempResultItem < 0) {
                          //     pro.bascet_item[index].itemDisccount = 0.0;
                          //     pro.bascet_item[index].itemDisccountType =
                          //         "fixed";
                          //     pro.counterDiscountCheek--;
                          //     fToast.init(context);
                          //     MassageForToast().massageForAlert(
                          //         lang.customDiscountCanNotSubtotal,
                          //         false,
                          //         fToast);
                          //   }
                          // }
                          pro.updat();
                          textPriceControler.clear();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        lang.confirm.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}


bool discountCheck(int index ,BuildContext context, FToast fToast){

  var pro=Provider.of<Cart_Items>(context,listen: false);
  var lang =AppLocalizations.of(context);
  double tempResult =
      pro.get_total_price() - pro.discount;
  if (pro.isDiscountOnItem == true) {
    if (tempResult < 0) {
      pro.discountTotalPrice(
          pro.radioDiscount, 0.0, true);
      pro.isDiscountOnItem = false;
      pro.discount = 0.0;
      fToast.init(context);
      MassageForToast().massageForAlert(
          lang!.customDiscountCanNotSubtotal,
          false,
          fToast);
      return true;
    }
    else{
      return false;
    }
  } else if (pro.counterDiscountCheek >= 1) {
    double tempResultItem =
        pro.getItemTotalPrice(pro.bascet_item[index]) -
            pro.bascet_item[index].discountValue;
    //print(tempResultItem);
    if (tempResultItem < 0) {
      pro.bascet_item[index].itemDisccount = 0.0;
      pro.bascet_item[index].itemDisccountType =
      "fixed";
      if(pro.counterDiscountCheek >0){
        pro.counterDiscountCheek--;
      }

      fToast.init(context);
      MassageForToast().massageForAlert(
          lang!.customDiscountCanNotSubtotal,
          false,
          fToast);
      return true;
    }
    else{
      return false;
    }
  }
  else{
    return false;
  }
}

bool canEditOnInvoice(BuildContext context, FToast fToast){
  var provid= Provider.of<Cart_Items>(context,listen: false);
  var lang =AppLocalizations.of(context);
    if (provid.invoiceData.isAccredited! == true) {
      MassageForToast().massageForAlert(
          lang!.isAccredited, false, fToast);
      return true;
    } else if (provid.invoiceData.isDeleted == true) {
      MassageForToast().massageForAlert(
          lang!.isDeleted, false, fToast);
      return true;
    } else if (provid.invoiceData.isCollectionReceipt ==
        true) {
      MassageForToast().massageForAlert(
          lang!.isCollectionReceipt, false, fToast);
      return true;
    }
    else if (provid.invoiceData.isReturn ==
        true) {
      MassageForToast().massageForAlert(
          lang!.isReturn, false, fToast);
      return true;
    }
    else{
      return false;
    }
  //return true;
}