import 'package:apex/model.dart';
import 'package:apex/models/login_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../api_directory/get_all_invoice.dart';
import '../../api_directory/get_pos invoice by id.dart';
import '../../api_directory/partial_return_api.dart';
import '../../api_directory/total_return_api.dart';
import '../../costants/color.dart';
import '../../models/all_invoice_data.dart';
import '../../models/get_invoice_api.dart';
import '../../models/invoice_data_object.dart';
import '../../models/items.dart';
import '../../screens/loginpagearabe.dart';
import '../basic_printer.dart';
import '../cart_items.dart';
import '../cart_screen.dart';
import '../main_screen.dart';
import '../massage_toast.dart';
import '../menu_provider.dart';
import '../signalRProvider.dart';
class ReturnPOS extends StatefulWidget {
   ReturnPOS({super.key});

  @override
  State<ReturnPOS> createState() => _ReturnPOSState();
}

class _ReturnPOSState extends State<ReturnPOS> {
  //var dateText;

  List<AllInvoiceData> invoices = [];
  TextEditingController calenderText =TextEditingController();
  TextEditingController invoiceNumberText =TextEditingController();
  ScrollController invoiceScroll =ScrollController();
  DataFromApi allInvoicesData = DataFromApi();
  var invoiceDate;
  int pageNumber = 1;
  int pageSize = 20;
  bool invoiceLoading=false;
  var invoiceId;
  var invoiceCode;
  bool loadingData=false;
  bool totalLoad=false;
  FToast fToast=FToast();
  ScrollController returnScroll=ScrollController();
  FocusNode invoiceNumberFocus = FocusNode();
  var invoiceSubTypesIdForTotal;
  List<String>calenderDate=DateTime.now().toString().split(" ");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signalRContext=context;
    fToast.init(context);
    calenderText.text= calenderDate[0];
    invoiceDate=DateTime.now();
    invoiceScroll.addListener(scrollTableListener);
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(invoiceNumberFocus.hasFocus){
      returnScroll.jumpTo(returnScroll.position.maxScrollExtent);
    }
  }
  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return     AlertDialog(
      title: Center(
        child: FittedBox(
          fit: BoxFit.fill,
          child: Text(lang!.search,
              style: TextStyle(
                  fontSize: 30.sp, fontWeight: FontWeight.w200)),
        ),
      ),
      content:ReturnPOS() //contentInvoicePopup(),
    );

  }

  Widget ReturnPOS (){
    var lang = AppLocalizations.of(context);
    return StatefulBuilder(builder: (context,MyBaseState){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              height: 190.h,//so
              width: double.maxFinite,
              child: ListView(
                controller: returnScroll,
                shrinkWrap: true,
                children: [
                  calenderTextField( MyBaseState),
                  invoiceNumberTextField(MyBaseState),
                  searchButton(lang!.search,MyBaseState),
                  Container(
                    child: Text(lang.invoices,style: TextStyle(fontSize: 20.sp),),
                  ),

                ],
              ),
            ),
          ),
          Flexible(
              child: Container(
                height: 170.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey),
                  color: Colors.white10,
                ),
                  child:checkReturn(MyBaseState),),),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Flexible(
                  child: partialReturn(),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Flexible(
                  child: totalReturn(),
                ),
              ],
            ),
          ),

        ],
      );
    });
  }
  Widget checkReturn( Function(void Function()) myBasicState){
    //loadingData == true && allInvoicesData.result != null && allInvoicesData.result != 1  ?
    if(totalLoad ==false){
      if(loadingData == true && allInvoicesData.result != null && allInvoicesData.result != 1){
        return Center(
          child: Text(AppLocalizations.of(context)!.thereSearchResults,textAlign: TextAlign.center ,style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold ,
              color: Colors.black
          ),),
        );
      }
      else{
        if(invoices.length > 0){
          return invoiceListview(myBasicState);
        }
        else{
          return Container();
        }

      }
    }
    else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    //return Container();
  }

  Widget calenderTextField(
      Function(void Function()) myBasicState) {
    var lang = AppLocalizations.of(context);
    return StatefulBuilder(builder: (context, myState) {
      return Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox(
          height: 40.h,
          child: TextFormField(
              //focusNode: toFocus,
              controller: calenderText,
              style: TextStyle(fontSize: 15.sp),
              decoration: textDecoration(lang!.date),
              readOnly: true,
              onTap: () async {
                //visible = false;
                var date = await calenderOnTap();
                if(mounted){
                  myBasicState(() {
                    calenderText.clear();
                    calenderText.text = date;
                    //set output date to TextField value.
                  });
                }
                //}
              }),
        ),
      );
    });
  }

  Widget invoiceNumberTextField(
      Function(void Function()) myBasicState) {
    var lang = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        height: 40.h,
        child: TextFormField(
          controller: invoiceNumberText,
          focusNode: invoiceNumberFocus,
          decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(
                  vertical:-14.h,
                  horizontal: 6.w),
              label: Text(lang!.searchInvoiceNumber,style: TextStyle(color: Colors.grey),),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue))),
        ),
      ),
    );
  }



  Widget searchButton(String search,Function(void Function()) myBasicState) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 15),
      child: InkWell(
        onTap: () {
          // invoices.clear();
          //getAllInvoices(1);

          if(mounted){
            myBasicState(() {
              allInvoicesData=DataFromApi();
              loadingData=false;
              //totalLoad=true;
              getAllInvoicesOther(1,myBasicState);
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r), color: basicColor),
          height: 40.h,
          width: double.infinity,
          child: Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                search,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration textDecoration(String label) {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 3.h,
        ),
        prefixIcon: Icon(
          Icons.calendar_today,
          size: 20,
        ),
        label: Text(label,style: TextStyle(color: Colors.grey)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue)));
  }

  Future<String> calenderOnTap() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    String formattedDate = "";
    if (pickedDate != null) {
      invoiceDate = pickedDate;
      calenderDate=pickedDate.toString().split(" ");
      return calenderDate[0];
    }
    calenderDate=DateTime.now().toString().split(" ");
    return calenderDate[0];
  }
  var selectedIndex;
  Widget invoiceListview( Function(void Function()) myBasicState){
    return  Column(
      children: [
        Expanded(
          child: SizedBox(
            height: 165.h,
            width: MediaQuery.of(context).size.width,
            child: RawScrollbar(
              controller: invoiceScroll,
                trackVisibility: true,
                thumbVisibility: true,
                radius: Radius.circular(4),
                thumbColor: Colors.blue,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: invoiceScroll,
                    shrinkWrap: true,
                    itemCount: invoices.length >= pageSize && invoiceLoading == false  ?  invoices.length + 1 : invoices.length,
                    itemBuilder: (context,index){
          
                      if(index<invoices.length){
                        invoiceLoading=false;
                        return InkWell(
                          onTap: (){
                           if(mounted){
                             myBasicState((){
                               selectedIndex = index;
                               invoiceId=invoices[index].invoiceId;
                               invoiceCode=invoices[index].invoiceType;
                               invoiceSubTypesIdForTotal=invoices[index].invoiceSubTypesId;
                               //print("hftttthht $selectedIndex");
                             });
                           }
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                              color: selectedIndex == index ? Colors.blueAccent : Color(0x9091908E),//B0B4B18E
                            ),
                            child: Center(
                                child: Text(invoices[index].invoiceType!,textDirection: TextDirection.ltr,style: TextStyle(
                                  fontSize: 20.sp,
                                  color: invoices[index].invoiceSubTypesId == 0 ? Colors.black :Colors.red
                                ),)
                            ),
                          ),
                        );
                      }
                      else{
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
            ),
          ),
        ),
      ],
    );
  }
  Future<void> scrollTableListener() async {
    // print(personDropDownList.data!.length);
    if (invoiceScroll.position.pixels >=
        invoiceScroll.position.maxScrollExtent &&
        allInvoicesData.data!.length >= pageSize) {
      if(mounted){
        setState(() {
          invoiceLoading=true;
        });
      }
      // flagScroll = invoiceScrollTable.position.maxScrollExtent ;
      pageNumber++;
      //print("page number is in scroll listener $tableLoadingData");
      getAllInvoicesOther(2,setState);
    }
  }
  void getAllInvoicesOther(int typeCall ,Function(void Function()) myBasicState) async{
    if(invoiceNumberText.text.isNotEmpty){
      invoiceDate="";
    }
    if(invoices.isEmpty){
      totalLoad=true;
    }
    invoiceDate= invoiceDate == null ? "" : invoiceDate;
    //  ,var invoiceDate
    allInvoicesData = await  GetAllPosInvoice().getAllPosInvoice(pageNumber, pageSize,invoiceNumberText.text ,"" ,"" , "",invoiceDate ,true);//
    totalLoad=false;
   // invoiceLoading=true;
    if(typeCall == 1){
      invoices.clear();
      if(allInvoicesData.data != null){
        invoices =allInvoicesData.data!.cast<AllInvoiceData>();
        //loadingData=true;
        if(mounted){
          myBasicState(() {

          });
        }
      }
      else {
        loadingData=true;
        if(mounted){
          myBasicState(() {

          });
        }
      }
    }
    else{
      if(allInvoicesData.data != null){
        invoices.addAll(allInvoicesData.data!.cast<AllInvoiceData>());
        if(mounted){
          myBasicState(() {
            //tableLoadingData=false;
          });
        }
      }
    }
  }

  Widget partialReturn(){
    var lang =AppLocalizations.of(context);
    return InkWell(
      onTap: () async{
        InvoiceDataEditeApi invoiceDataEditeApi=InvoiceDataEditeApi();
        //PartialReturn
        if(invoiceId ==null){
          MassageForToast().massageForAlert(lang!.pleaseSelectInvoice,false,fToast);
        }
        else{
         // bool isArabic= Provider.of<modelprovider>(context,listen: false).applocal==Locale("ar")? true :false;
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                // ignore: deprecated_member_use
                return WillPopScope(
                  onWillPop: () async{ return false; },
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              });
          invoiceDataEditeApi=await PartialReturn().partialReturn(invoiceCode);
          Navigator.of(context).pop();
          if(invoiceDataEditeApi.result==1){
            editeCart(invoiceDataEditeApi,context);
            Navigator.of(context)
                .pushReplacementNamed(My_basket.root);
          }
          else{
            String massage=Provider.of<modelprovider>(context,listen: false).applocal==Locale("ar")?invoiceDataEditeApi.errorMessageAr! : invoiceDataEditeApi.errorMessageEn!;
            MassageForToast().massageForAlert(massage,false,fToast);
          }
        }

      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r), color: basicColor),
        height: 40.h,
        width: MediaQuery.of(context).size.width/2,
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              AppLocalizations.of(context)!.partialReturn,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget totalReturn(){
    var lang =AppLocalizations.of(context);
    return InkWell(
      onTap:() async{

        if(invoiceId ==null){
          MassageForToast().massageForAlert(lang!.pleaseSelectInvoice,false,fToast);
        }
        else if(invoiceSubTypesIdForTotal!=null && invoiceSubTypesIdForTotal ==1){
          MassageForToast().massageForAlert(lang!.notPossibleReturnEntireInvoicePartReturned,false,fToast);
        }
        else{
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                // ignore: deprecated_member_use
                return WillPopScope(
                  onWillPop: () async{ return false; },
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              });
          bool isArabic= Provider.of<modelprovider>(context,listen: false).applocal==Locale("ar")? true :false;
          LoginData returnData =await TotalReturn().totalReturn(invoiceId, isArabic);
          //Navigator.of(context).pop();
          // if(returnDara.result==1){
          //   Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(
          //           builder: (context) => Main_Screen(
          //             index: 0,
          //             setIndex: true,
          //           )),
          //           (route) => false);
          // }
          if(returnData.result ==1){
            if(returnData.isPrint !=null)
            {
              MassageForToast().massageForAlert(lang!.invoiceCompletelyRefunded,true,fToast);
              //Navigator.of(context).pop();
              if(Navigator.canPop(context)){
                Navigator.of(context).pop();
              }
            }
            // else if(returnData.resultForPrint != null && returnData.resultForPrint==1)
            // {
            //   // bool isArabic = Provider.of<modelprovider>(context,listen: false).applocal ==Locale("ar")? true :false;
            //   // PrintingInvoices().printingInvoice(provider.invoiceData.invoiceId!, provider.invoiceData.invoiceCode!, isArabic, fToast,context);
            //   await PrintingInvoices().printingFun(returnData.fileUrl!);
            //   if(Navigator.canPop(context)){
            //     Navigator.of(context).pop();
            //   }
            // }
            else if(returnData.resultForPrint!=null && returnData.resultForPrint ==30)
            {
              MassageForToast().massageForAlert(lang!.noPermissionPrint,false,fToast);
              if(Navigator.canPop(context)){
                Navigator.of(context).pop();
              }
            }
            else{
              await PrintingInvoices().printingFun(returnData.fileUrl!);
              if(Navigator.canPop(context)){
                Navigator.of(context).pop();
              }
            }

            //MassageForToast().massageForAlert(lang.invoiceSavedSuccessfully,true,fToast);
            // provider.counterDiscountCheek = 0 ;
            // provider.isDiscountOnItem=false;
            // provider.isEdite=false;
            // provider.settingGeneral.editeInvoice=false;
            // //provider.settingGeneral.returnInvoice=false;
            // provider.settingGeneral.returnInvoice=false;
            // provider.returnInvoice=false;
            // provider.invoiceData = InvoiceData();
            // //provider.invoiceData=InvoiceData();
            // provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
            // Provider.of<menuProviderOptions>(context,listen: false).setNotes("");
            // provider.remove_all_items();
            // provider.updat();
            if(Navigator.canPop(context)){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Main_Screen(
                          index: 0,
                          setIndex: true,
                        )),
                        (route) => false);
              }
            }
            //Navigator.of(context).pop();
          else{
            String massage=Provider.of<modelprovider>(context,listen: false).applocal==Locale("ar")?returnData.errorMassageAr! : returnData.errorMassageEn!;
            MassageForToast().massageForAlert(massage,false,fToast);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r), color: basicColor),
        height: 40.h,
        width: MediaQuery.of(context).size.width/2,
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              AppLocalizations.of(context)!.totalReturn,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void editeCart(
      InvoiceDataEditeApi invoiceDataEditeApi, BuildContext context) {
    var provider = Provider.of<Cart_Items>(context, listen: false);
    provider.invoiceData=InvoiceData();
    provider.counterDiscountCheek = 0 ;
    provider.isDiscountOnItem=false;
    provider.remove_all_items();
    provider.isEdite=false;
    provider.settingGeneral.editeInvoice=false;
    //provider.invoiceData=InvoiceData();
    provider.updat();
    try {
      provider.invoiceData = invoiceDataEditeApi.invoiceData!;
       // provider.isEdite = false;
       // provider.invoiceData.edit = false;
      provider.invoiceData.returnInvoices=true;
      provider.settingGeneral.returnInvoice=true;
      provider.returnInvoice=true;
      provider.settingGeneral.applyVat =
          invoiceDataEditeApi.invoiceData!.applyVat;
      provider.settingGeneral.activeDiscount =
          invoiceDataEditeApi.invoiceData!.activeDiscount;
      provider.settingGeneral.roundNum =
          invoiceDataEditeApi.invoiceData!.roundNumber;
      //provider.settingGeneral.editeInvoice = false;
      provider.settingGeneral.priceIncludeVat =
          invoiceDataEditeApi.invoiceData!.priceWithVat;
      //provider.discount =invoiceDataEditeApi.invoiceData!.discountType == 2 ? invoiceDataEditeApi.invoiceData!.totalDiscountValue!: 0.0;
      if(invoiceDataEditeApi.invoiceData!.discountType == 2 ){
        if(invoiceDataEditeApi.invoiceData!.isDiscountRatio ==true){
          provider.discount= invoiceDataEditeApi.invoiceData!.totalDiscountRatio!;
        }
        else{
          provider.discount=invoiceDataEditeApi.invoiceData!.totalDiscountValue!;
        }
      }
      provider.invoiceData.parentInvoiceCode = invoiceDataEditeApi.invoiceData!.parentInvoiceCode;
      provider.radioDiscount= invoiceDataEditeApi.invoiceData!.isDiscountRatio ==true ? "percentage" : "fixed";
      provider.personId.dataparameter(invoiceDataEditeApi.invoiceData!.personId!,
          invoiceDataEditeApi.invoiceData!.personNameAr!,
          invoiceDataEditeApi.invoiceData!.personNameEn! );
      provider.isDiscountOnItem =
      invoiceDataEditeApi.invoiceData!.discountType==2
          ? true
          : false;
      for (int i = 0;
      i < invoiceDataEditeApi.invoiceData!.invoiceDetails!.length;
      i++) {
        Item item = Item.a();
        item.indexOfItem =  invoiceDataEditeApi.invoiceData!.invoiceDetails![i].indexOfItem;

        item.isEdite = true;

        item.applyVATEdite =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].applyVat;

        item.canDelete =
        invoiceDataEditeApi.invoiceData!.invoiceDetails![i].canDelete!;

        item.balanceBarcode =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].balanceBarcode;

        item.conversionFactor = invoiceDataEditeApi
            .invoiceData!.invoiceDetails![i].conversionFactor;

        item.discountRatioEdite =invoiceDataEditeApi.invoiceData!.invoiceDetails![i].isDiscountRatioItem==true?
        invoiceDataEditeApi.invoiceData!.invoiceDetails![i].discountRatio : 0.0;

        item.discountValueEdite =invoiceDataEditeApi.invoiceData!.invoiceDetails![i].isDiscountRatioItem==false?
        invoiceDataEditeApi.invoiceData!.invoiceDetails![i].discountValue : 0.0;

        item.itemDisccount=invoiceDataEditeApi.invoiceData!.invoiceDetails![i].isDiscountRatioItem==true?
        invoiceDataEditeApi.invoiceData!.invoiceDetails![i].discountRatio! :
        invoiceDataEditeApi.invoiceData!.invoiceDetails![i].discountValue!;

        if(invoiceDataEditeApi.invoiceData!.invoiceDetails![i].discountValue! > 0 ||
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].discountRatio! > 0  ){
          provider.counterDiscountCheek ++ ;
        }
        item.itemDisccountType= invoiceDataEditeApi.invoiceData!.invoiceDetails![i].isDiscountRatioItem==true ?
        "percentage" : "fixed";

        item.expiryItemDate =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].expireDate;

        item.id = invoiceDataEditeApi.invoiceData!.invoiceDetails![i].itemId;

        item.invoiceId =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].invoiceId;

        item.selectedSerialItems = invoiceDataEditeApi
            .invoiceData!.invoiceDetails![i].invoiceSerialDtos ==
            null
            ? []
            : invoiceDataEditeApi
            .invoiceData!.invoiceDetails![i].invoiceSerialDtos!;

        item.itemCode =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].itemCode;

        item.arabName =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].itemNameAr;

        item.latinName =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].itemNameEn;

        item.itemTypeId =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].itemTypeId;

        item.qty = invoiceDataEditeApi. invoiceData!.invoiceDetails![i].quantity!
            .toDouble();

        item.splitedDiscountRatioEdit = invoiceDataEditeApi
            .invoiceData!.invoiceDetails![i].splitedDiscountRatio;

        item.splitedDiscountValueEdit = invoiceDataEditeApi
            .invoiceData!.invoiceDetails![i].splitedDiscountValue;

        item.itemPriceEdit =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].price;

        item.unitId =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].unitId;

        item.vatRatioEdit =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].vatRatio;

        item.vatValueEdit =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].vatValue;

        item.itemTypeId =
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].itemTypeId;

        Unit unit = Unit(
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].unitNameAr,
            invoiceDataEditeApi
                .invoiceData!.invoiceDetails![i].conversionFactor,
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].unitNameEn,
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].price,
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].unitId,
            null);

        if(invoiceDataEditeApi.invoiceData!.invoiceDetails![i].units.isNotEmpty){
          for(int x=0; x< invoiceDataEditeApi.invoiceData!.invoiceDetails![i].units.length;x++ ){
            invoiceDataEditeApi.invoiceData!.invoiceDetails![i].units[x].itemId=null;
          }
          item.units.addAll(invoiceDataEditeApi.invoiceData!.invoiceDetails![i].units);
          //int founded = _myItems.indexWhere((element) => element.id == item.id);
          int indexx= item.units.indexWhere((element) => element.unitId==
              invoiceDataEditeApi.invoiceData!.invoiceDetails![i].unitId);
          if(indexx != -1){
            item.dropDownIndex=indexx;
          }
          else{
            item.dropDownIndex=0;
          }

        }
        else{
          item.dropDownValue=unit;
        }

        // item.dropDownValue = unit;
        provider.add_item(item);

      }
    } catch (e) {
      showSnack(e.toString());
      print(e.toString());
    }
  }
}
