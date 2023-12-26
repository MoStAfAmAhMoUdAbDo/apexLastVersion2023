import 'dart:async';
import 'package:apex/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:apex/costants/color.dart';
import 'package:apex/home%20page%20screens/cart_items.dart';
import 'package:apex/home%20page%20screens/cart_screen.dart';
import 'package:apex/models/items.dart';
//import '../package:intl/intl.dart';

import '../../api_directory/get_all_invoice.dart';
import '../../api_directory/get_persons_dropdown_data.dart';
import '../../api_directory/get_pos invoice by id.dart';
import '../../models/all_invoice_data.dart';
import '../../models/get_invoice_api.dart';
import '../../models/invoice_data_object.dart';
import '../signalRProvider.dart';

class GetAllInvoicePopUp extends StatefulWidget {
  GetAllInvoicePopUp({super.key});

  @override
  State<GetAllInvoicePopUp> createState() => _GetAllInvoicePopUpState();
}

class _GetAllInvoicePopUpState extends State<GetAllInvoicePopUp> {
  TextEditingController toCalenderText = TextEditingController();
  TextEditingController fromCalenderText = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  // GlobalKey globalKey = GlobalKey();
  // OverlayState? overlayState;
  double offSet=0;
   ScrollController scrollController =ScrollController();
  ScrollController scrollController2 = ScrollController();
  ScrollController invoiceScrollTable = ScrollController();
  String? selectedValue;
  // SingleValueDropDownController dropDownController=SingleValueDropDownController();
  DataFromApi personDropDownList = DataFromApi();
  DataFromApi allInvoicesData = DataFromApi();
  int pageNumber = 1;
  int pageSize = 20;
  ///---------------------------
  List<PersonInvoiceDropDown> tempList = [];
  List<PersonInvoiceDropDown> tempList2 = [];
  List<PersonInvoiceDropDown> testOfDropDown =[];
  FocusNode codeFocus = FocusNode();
  FocusNode clientFocus = FocusNode();
  FocusNode fromFocus = FocusNode();
  FocusNode toFocus = FocusNode();

  TextEditingController textEditingController = TextEditingController();
  bool visible = false;
  bool visibleInvoice = false;

  bool isLoading = false;
  var fromDate;
  var toDate;
  var personId;
  late  OverlayEntry overlayEntry;

  bool tryLoading =false;

  final LayerLink _layerLink = LayerLink();

  OverlayEntry createDropdownDesign(Function(void Function()) myBasicState){
    return OverlayEntry(builder: (context){
      return Positioned(
       // height: MediaQuery.sizeOf(context).height/7,
        width: MediaQuery.of(context).size.width/1.56,
        top: 250.h,
        //left: 67.w,
        child:
        CompositedTransformFollower(
          link: this._layerLink,
          showWhenUnlinked: false,
          //offset: Offset(0.0,  5.0),
          child: Material(
            color: Colors.transparent,
            elevation: 4.0,
            child: listViewDesign(myBasicState),
          ),
        ),

      );
    });
  }

  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    // getClientPopUpData();
    // overlayState = Overlay.of(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   globalKey;
    // });
    //scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    invoiceScrollTable.addListener(scrollTableListener);
    focusListener(clientFocus);
    signalRContext=context;
    super.initState();
  }

  void focusListener(FocusNode focusNode) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        overlayEntry=createDropdownDesign(setState);
        Overlay.of(context).insert(overlayEntry);
        if(mounted){
          setState(() {
            visible = true;
          });
        }
      } else {
        overlayEntry.remove();
       if(mounted){
         setState(() {
           visible = false;

         });
       }

      }
    });
  }

  bool tableLoadingData = false;
  bool personLoadingData=false;
  void getClientPopUpData([int scrol=0]) {
    GetPersonDropDown().getPersonDropDown(pageNumber, pageSize).then((value) {
      //setState(() {
        personDropDownList = value;
        if (personDropDownList.data != null || personDropDownList.data!.length < pageSize)
        {
          tempList.addAll(value.data);
          tempList2.addAll(value.data);
          if(scrol==1)
          {
            overlayEntry.markNeedsBuild();
          }
          else{
            overlayEntry.markNeedsBuild();
          }

          //isLoading = true;
        }
        else if (value.result==1 || value.data ==null)
        {
          if(scrol==1)
          {
            overlayEntry.markNeedsBuild();
          }
          isLoading = false;
        }
        // else{
        //   overlayEntry.markNeedsBuild();
        // }

      //});
    });
  }

  // void getClientPopUpDataTest([int scroll =0])async{
  //   if(scroll ==0){
  //     testOfDropDown = await GetPersonDropDown().getPersonDropDown(pageNumber, pageSize);
  //     overlayEntry.markNeedsBuild();
  //   }
  //   else{
  //     var tem=await GetPersonDropDown().getPersonDropDown(pageNumber, pageSize);
  //     testOfDropDown.addAll(tem);
  //     overlayEntry.markNeedsBuild();
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  //
  // }

  double flagScroll = 0;
  Future<void> _scrollListener() async {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent
        && personDropDownList.data!.length >= pageSize)
    {
      //flagScroll = scrollController.position.maxScrollExtent;
      // offSet= scrollController.offset;
      // overlayEntry.remove();
      // overlayEntry=createDropdownDesign(setState);
      // Overlay.of(context).insert(overlayEntry);

      // isLoading = true;
      // setState(() {
      //
      // });
      pageNumber++;
      //print("page number is in scroll listener $pageNumber");
      getClientPopUpData(1);
    }
  }

  int tablePageNumber = 1;

  Future<void> scrollTableListener() async {
   // print(personDropDownList.data!.length);
    print(pageSize);
    if (invoiceScrollTable.position.pixels >=
            invoiceScrollTable.position.maxScrollExtent &&
        allInvoicesData.data!.length >= pageSize) {
      if(mounted){
        setState(() {
          tableLoadingData=true;
        });
      }

      // flagScroll = invoiceScrollTable.position.maxScrollExtent ;
      tablePageNumber++;
      //print("page number is in scroll listener $tableLoadingData");
      getAllInvoicesOther(2);
    }
  }

  @override
  Widget build(BuildContext context) {
   // print("object");
    //print("the value is ${dropDownController.dropDownValue}");
    var lang = AppLocalizations.of(context);
    return
      // personDropDownList.data == null
      //   ? Center(
      //       child: CircularProgressIndicator(),
      //     )
      //   :
    AlertDialog(
            title: Center(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(lang!.search,
                    style: TextStyle(
                        fontSize: 30.sp, fontWeight: FontWeight.w200)),
              ),
            ),
            content: contentInvoicePopup(),
          );
  }

  Widget contentInvoicePopup() {
    var lang = AppLocalizations.of(context);
    return StatefulBuilder(builder: (context, MyBaseState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Text("1-pos-209",textDirection: TextDirection.RTL),
          Flexible(
            child: Container(
              height: 190.h,//so
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  clientCode( MyBaseState),
                  clientNameText(MyBaseState),
                  // Visibility(
                  //     visible: visible, child: listViewDesign(MyBaseState)),
                  CompositedTransformTarget(
                      link: this._layerLink,
                      child: fromTextField( MyBaseState)),
                  toTextField( MyBaseState),
                ],
              ),
            ),
          ),
          searchButton(lang!.search),
          Flexible(
            child: Visibility(
              visible: visibleInvoice,
              child: tryLoading ==false && invoices.isNotEmpty
                  ? invoiceAllData(MyBaseState)
                  : allInvoicesData.result != null
                      ? Container(
                          child: Text(
                            lang.noInvoice,
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
            ),
          ),
        ],
      );
    });
  }

  List<AllInvoiceData> invoices = [];
  void getAllInvoices(int typeCall) { //type call if 1 its mean the search btn is calling  ... 2 its mean the scroll pagination
    String invoiceType =
        codeController.text.isEmpty ? "" : codeController.text.toString();
    var fDate = fromDate == null ? "" : fromDate;
    var tDate = toDate == null ? "" : toDate;
    var pId = personId == null || clientController.text.isEmpty ? "0" : personId;
    GetAllPosInvoice()
        .getAllPosInvoice(
            tablePageNumber, pageSize, invoiceType, fDate, tDate, pId)
        .then((value) {
          if(typeCall == 1){
            invoices.clear();
            allInvoicesData=DataFromApi();
            allInvoicesData = value;
            if(allInvoicesData.data != null){
              invoices = value.data;
            }
          }
          else{
            allInvoicesData = value;
            if(allInvoicesData.data != null){
              invoices.addAll(value.data);
            }
          }


      if (value.result==1 || value.data ==null) {
        tableLoadingData = false;
      }
      if(mounted){
        setState(() {});
      }
    });


  }

  void getAllInvoicesOther(int typeCall) async{
    String invoiceType =
    codeController.text.isEmpty ? "" : codeController.text.toString();
    var fDate = fromDate == null ? "" : fromDate;
    var tDate = toDate == null ? "" : toDate;
    //var pId = personId == null || clientController.text.isEmpty  ? "0" : personId;
    var pIdtest = personId == null? "" : personId ;

    allInvoicesData = await  GetAllPosInvoice().getAllPosInvoice(tablePageNumber, pageSize, invoiceType, fDate, tDate, pIdtest,"",false);
    if(typeCall == 1){

      invoices.clear();
      if(allInvoicesData.data != null){
        invoices =allInvoicesData.data!.cast<AllInvoiceData>();
      }
    }
    else{
      if(allInvoicesData.data != null){
        invoices.addAll(allInvoicesData.data!.cast<AllInvoiceData>());
        if(mounted){
          setState(() {
            tableLoadingData=false;
          });
        }
      }
    }
    if(mounted){
      setState(() {
        tableLoadingData=false;
        tryLoading=false;
      });
    }
  }

  Widget clientCode(
       Function(void Function()) myBasicState) {
    var lang = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(3),
      child: SizedBox(
        height: 40.h,
        child: TextFormField(
          focusNode: codeFocus,
          controller: codeController,
          decoration: InputDecoration(
              contentPadding:
              EdgeInsets.symmetric(
                  vertical:-14.h,
                  horizontal: 6.w),
              label: Text(lang!.invoiceCode,style: TextStyle(color: Colors.blue),),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),),),
        ),
      ),
    );
  }

  bool arrowButtonPressed=false;
  Widget clientNameText(
       Function(void Function()) myBasicState) {
    var lang = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 40.h,
        ),
        //height:
        child:
        TextFormField(
          focusNode: clientFocus,
          controller: clientController,
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(
                vertical:-14.h,
                horizontal: 6.w),
            label: Text(lang!.clientName,style: TextStyle(color: Colors.blue),),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue),
            ),
          ),
          onTap: () {
            tempList.clear();
            tempList2.clear();
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
            // myBasicState(() {
            //
            // });
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

    ///      newListSearch = myCart
    //           .where((item) =>
    //               item.latinName!.toLowerCase().contains(query.toLowerCase()) ||
    //               item.arabName!.contains(query.toString()))
    //           .toList();
  }

  Widget fromTextField(
       Function(void Function()) myBasicState) {
    var lang = AppLocalizations.of(context);
    return StatefulBuilder(builder: (context, myState) {
      return Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox(
          height: 40.h,
          child: TextFormField(
              focusNode: fromFocus,
              controller: fromCalenderText,
              readOnly: true,
              style: TextStyle(fontSize: 15.sp),
              // textAlign: TextAlign.start,
              decoration: textDecoration(lang!.from),
              onTap: () async {
                ///visible = false;
                var date = await calenderOnTap("fromDate");
                myState(() {
                  fromCalenderText.clear();
                  fromCalenderText.text = date;
                  //set output date to TextField value.
                });
                //}
              }),
        ),
      );
    });
  }

  Widget toTextField(
      Function(void Function()) myBasicState) {
    var lang = AppLocalizations.of(context);
    return StatefulBuilder(builder: (context, myState) {
      return Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox(
          height: 40.h,
          child: TextFormField(
              focusNode: toFocus,
              controller: toCalenderText,
              style: TextStyle(fontSize: 15.sp),
              decoration: textDecoration(lang!.to),
              readOnly: true,
              onTap: () async {
                //visible = false;
                var date = await calenderOnTap("toDate");
                myState(() {
                  toCalenderText.clear();
                  toCalenderText.text = date;
                  //set output date to TextField value.
                });
                //}
              }),
        ),
      );
    });
  }

  PersonInvoiceDropDown person = PersonInvoiceDropDown();
  Widget searchButton(String search) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
             // invoices.clear();
              //getAllInvoices(1);

             if(mounted){
               setState(() {
                 allInvoicesData=DataFromApi();
                 getAllInvoicesOther(1);
                 visibleInvoice = true;
                 tryLoading = true ;
               });
             }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r), color: basicColor),
              height: 40.h,
              width: 100.w,
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
        ],
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
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue)));
  }

  Future<String> calenderOnTap(String textType) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));
    String formattedDate = "";
    if (pickedDate != null) {
      if (textType == "toDate") {
        toDate = pickedDate;
      } else {
        fromDate = pickedDate;
      }

      List<String>date=pickedDate.toString().split(" ");

      return date[0];
    }
    return formattedDate;
  }

  final focus = FocusNode();
int listIndex=0;
  Widget listViewDesign(Function(void Function()) myBasicState) {
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
      child:tempList2.isNotEmpty? RawScrollbar(
        controller: scrollController,
        radius: Radius.circular(4),
        thumbColor: Colors.blue,
        thumbVisibility: true,
        trackVisibility: true,

        child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: scrollController,
            shrinkWrap: true,
            itemCount: tempList2.length,
            itemBuilder: (context, index) {
              if (index < tempList2.length) {
                String? massage =
                    Provider.of<modelprovider>(context).applocal == Locale('ar')
                        ? tempList2[index].arabicName
                        : tempList2[index].latinName;
                return Card(
                  color: Colors.white,
                  margin:const EdgeInsets.all(0.20),
                  child: ListTile(
                      onTap: () {
                        if(mounted){
                          myBasicState(() {
                            personId = tempList2[index].id;
                            clientController.text = massage.length > 20 ? massage.substring(0,20):massage;
                            visible = false;
                            clientFocus.unfocus();
                            //overlayEntry.remove();

                          });
                        }
                      },
                   // tileColor: Colors,
                      dense: true,
                      visualDensity: VisualDensity(vertical: -1),
                      title: Text(massage!,style: TextStyle(color: Colors.black54),)),
                );
              } else {
                overlayEntry.markNeedsBuild();
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ):Center(child: CircularProgressIndicator(),),
    );
  }

  int listLength = 8;
  Widget invoiceAllData(
       Function(void Function()) myBasicState) {
    var lang = AppLocalizations.of(context);
    var langType=Provider.of<modelprovider>(context,listen: false).applocal;
    return Container(
      width: double.maxFinite,
      constraints: BoxConstraints(
        maxHeight: 200.h,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Scrollbar(
        controller: scrollController2,
        radius: Radius.circular(4),
        thumbVisibility: true,
        child: Scrollbar(
          controller: invoiceScrollTable,
          thumbVisibility: true,
          //trackVisibility: true,
          radius: Radius.circular(4),
          child: ListView(
            controller: invoiceScrollTable,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              SingleChildScrollView(
                controller: scrollController2,
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Table(
                      //border:TableBorder.all(color: Colors.blue,width: 1.w ,borderRadius: BorderRadius.circular(3.r)) ,
                      //defaultColumnWidth: FixedColumnWidth(200.0),
                      // columnWidths: {
                      //   0: FixedColumnWidth(130.w),
                      //   1: FixedColumnWidth(130.w),
                      //   2: FixedColumnWidth(110.w),
                      //   3: FixedColumnWidth(150.w),
                      //   4: FixedColumnWidth(80.w),
                      //   5: FixedColumnWidth(80.w),
                      //   6: FixedColumnWidth(50.w)
                      // },
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      children: [
                        TableRow(
                            decoration: BoxDecoration(color: Colors.blue),
                            children: [
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      lang!.invoiceCode,
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Center(
                                  child: Text(
                                    lang.date,
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Center(
                                  child: Text(
                                    lang.time,
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Center(
                                  child: Text(
                                    lang.clientName,
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Center(
                                  child: Text(
                                    lang.total,
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Center(
                                  child: Text(
                                    lang.discount,
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Center(
                                  child: Text(
                                    lang.open,
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ]),
                        ...List.generate(invoices.length, (index) {
                          List<String> temp =invoices[index].invoiceDate!.split("T");
                         //var cartProvider=Provider.of<Cart_Items>(context,listen: false);
                          String personName =
                              langType ==
                                      Locale('ar')
                                  ? invoices[index].personNameAr!
                                  : invoices[index].personNameEn!;
                          return TableRow(
                              decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.white30
                                      : Colors.white),
                              children: [
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: InkWell(
                                      child: Text(
                                        invoices[index].invoiceType!,
                                          textDirection:TextDirection.ltr
                                          ,
                                          // textDirection: TextDirection.RTL
                                          // ,
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            color: Colors.black),
                                      ),
                                      onTap: () async {
                                        InvoiceDataEditeApi invoiceDataId;
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
                                        invoiceDataId = await GetInvoiceById()
                                            .getInvoiceById(
                                                invoices[index].invoiceId!);
                                        //cartProvider.personId.dataparameter(invoices[index]., invoices[index].personNameAr!, invoices[index].personNameEn! );
                                        Navigator.of(context).pop();
                                        if (invoiceDataId.result == 1) {
                                          // write code here
                                          editeCart(invoiceDataId, context);
                                          Navigator.of(context)
                                              .pushReplacementNamed(My_basket.root);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        child: Text(
                                          // langType==Locale("ar") ? arabicDate:
                                          // formattedDate,
                                        temp[0],
                                          textDirection: TextDirection.ltr ,
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              color: Colors.black),
                                        ),
                                        onTap: () async {
                                          InvoiceDataEditeApi invoiceDataId;
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              });
                                          invoiceDataId = await GetInvoiceById()
                                              .getInvoiceById(
                                                  invoices[index].invoiceId!);
                                          Navigator.of(context).pop();
                                          if (invoiceDataId.result == 1) {
                                            // write code here
                                            editeCart(invoiceDataId, context);
                                            Navigator.of(context)
                                                .pushReplacementNamed(My_basket.root);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        child: Text(
                                          temp[1],
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        onTap: () async {
                                          InvoiceDataEditeApi invoiceDataId;
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              });
                                          invoiceDataId = await GetInvoiceById()
                                              .getInvoiceById(
                                                  invoices[index].invoiceId!);
                                          Navigator.of(context).pop();
                                          if (invoiceDataId.result == 1) {
                                            // write code here
                                            editeCart(invoiceDataId, context);
                                            Navigator.of(context)
                                                .pushReplacementNamed(My_basket.root);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        child: Text(
                                          personName,
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        onTap: () async {
                                          InvoiceDataEditeApi invoiceDataId;
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              });
                                          invoiceDataId = await GetInvoiceById()
                                              .getInvoiceById(
                                                  invoices[index].invoiceId!);
                                          Navigator.of(context).pop();
                                          if (invoiceDataId.result == 1) {
                                            // write code here
                                            editeCart(invoiceDataId, context);
                                            Navigator.of(context)
                                                .pushReplacementNamed(My_basket.root);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        child: Text(
                                          invoices[index].totalPrice!.toString(),
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        onTap: () async {
                                          InvoiceDataEditeApi invoiceDataId;
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              });
                                          invoiceDataId = await GetInvoiceById()
                                              .getInvoiceById(
                                                  invoices[index].invoiceId!);
                                          Navigator.of(context).pop();
                                          if (invoiceDataId.result == 1) {
                                            // write code here
                                            editeCart(invoiceDataId, context);
                                            Navigator.of(context)
                                                .pushReplacementNamed(My_basket.root);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: InkWell(
                                        child: Text(
                                          invoices[index].discount.toString(),
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        onTap: () async {
                                          InvoiceDataEditeApi invoiceDataId;
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              });
                                          invoiceDataId = await GetInvoiceById()
                                              .getInvoiceById(
                                                  invoices[index].invoiceId!);
                                          Navigator.of(context).pop();
                                          if (invoiceDataId.result == 1) {
                                            // write code here
                                            editeCart(invoiceDataId, context);
                                            Navigator.of(context)
                                                .pushReplacementNamed(My_basket.root);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconButton(
                                        onPressed: () async {
                                          InvoiceDataEditeApi invoiceDataId;
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              });
                                          invoiceDataId = await GetInvoiceById()
                                              .getInvoiceById(
                                                  invoices[index].invoiceId!);
                                          Navigator.of(context).pop();
                                          if (invoiceDataId.result == 1) {
                                            // write code here
                                            editeCart(invoiceDataId, context);
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    My_basket.root);
                                          }
                                        },
                                        icon: Icon(Icons.remove_red_eye_rounded),
                                      ),
                                    ),
                                  ),
                                ),
                              ]);
                        })
                      ],
                    ),
                    Visibility(
                      visible: tableLoadingData,
                        child: Center(child: CircularProgressIndicator())
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget dataTable() {
  //   var lang =AppLocalizations.of(context);
  //   return Container(
  //     constraints: BoxConstraints(
  //       maxHeight: 200.h,
  //       maxWidth: MediaQuery.of(context).size.width,
  //     ),
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       shrinkWrap: true,
  //
  //       children: [
  //         DataTable(
  //             decoration: BoxDecoration(color: Colors.lightBlueAccent),
  //             columns: [
  //           DataColumn(
  //             label: Text(
  //               lang!.invoiceCode,
  //               style: TextStyle(
  //                   fontSize: 17.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //             ),
  //           ),
  //           DataColumn(
  //             label: Text(
  //               lang.date,
  //               style: TextStyle(
  //                   fontSize: 17.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //             ),
  //           ),
  //           DataColumn(
  //             label: Text(
  //               lang.time,
  //               style: TextStyle(
  //                   fontSize: 17.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //             ),
  //           ),
  //           DataColumn(
  //             label: Text(
  //               lang.clientName,
  //               style: TextStyle(
  //                   fontSize: 17.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //             ),
  //           ),
  //           DataColumn(
  //             label: Text(
  //               lang.total,
  //               style: TextStyle(
  //                   fontSize: 17.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //             ),
  //           ),
  //           DataColumn(
  //             label: Text(
  //               lang.discount,
  //               style: TextStyle(
  //                   fontSize: 17.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //             ),
  //           ),
  //           DataColumn(
  //             label: Text(
  //               lang.open,
  //               style: TextStyle(
  //                   fontSize: 17.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //             ),
  //           ),
  //         ],
  //             rows: [
  //
  //               ...List.generate(invoices.length , (index) {
  //                 // String formattedDate = DateFormat('yyyy-MM-dd')
  //                 //     .format(
  //                 //     DateTime.parse(invoices[index].invoiceDate!))
  //                 //     .toString();
  //                 // //print("the date is $formattedDate");
  //                 // String time = DateFormat('kk:mm:ss')
  //                 //     .format(
  //                 //     DateTime.parse(invoices[index].invoiceDate!))
  //                 //     .toString();
  //                 String personName =
  //                 Provider.of<modelprovider>(context).applocal ==
  //                     Locale('ar')
  //                     ? invoices[index].personNameAr!
  //                     : invoices[index].personNameEn!;
  //                 return DataRow(
  //                   cells: [
  //                   DataCell(
  //                     FittedBox(
  //                         fit: BoxFit.fitWidth,
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Text(
  //                             invoices[index].invoiceType!,
  //                             style: TextStyle(
  //                                 fontSize: 17.sp,
  //                                 color: Colors.black),
  //                           ),
  //                         ),
  //                       ),
  //                       onTap: () async {
  //                         InvoiceDataEditeApi invoiceDataId;
  //                         showDialog(
  //                             context: context,
  //                             builder: (context) {
  //                               return Center(
  //                                 child: CircularProgressIndicator(),
  //                               );
  //                             });
  //                         invoiceDataId = await GetInvoiceById()
  //                             .getInvoiceById(
  //                             invoices[index].invoiceId!);
  //                         Navigator.of(context).pop();
  //                         if (invoiceDataId.result == 1) {
  //                           // write code here
  //                           editeCart(invoiceDataId, context);
  //                           Navigator.of(context)
  //                               .pushReplacementNamed(My_basket.root);
  //                         }
  //                       },
  //                   ),
  //                   DataCell(
  //                     FittedBox(
  //                       fit: BoxFit.fitWidth,
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Text(
  //                           formattedDate,
  //                           style: TextStyle(
  //                               fontSize: 17.sp,
  //                               color: Colors.black),
  //                         ),
  //                       ),
  //                     ),
  //                       onTap: () async {
  //                         InvoiceDataEditeApi invoiceDataId;
  //                         showDialog(
  //                             context: context,
  //                             builder: (context) {
  //                               return Center(
  //                                 child: CircularProgressIndicator(),
  //                               );
  //                             });
  //                         invoiceDataId = await GetInvoiceById()
  //                             .getInvoiceById(
  //                             invoices[index].invoiceId!);
  //                         Navigator.of(context).pop();
  //                         if (invoiceDataId.result == 1) {
  //                           // write code here
  //                           editeCart(invoiceDataId, context);
  //                           Navigator.of(context)
  //                               .pushReplacementNamed(My_basket.root);
  //                         }
  //                       },
  //                   ),
  //                   DataCell(
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         time,
  //                         style: TextStyle(
  //                             fontSize: 17.sp,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black),
  //                       ),
  //                     ),
  //                     onTap: () async {
  //                       InvoiceDataEditeApi invoiceDataId;
  //                       showDialog(
  //                           context: context,
  //                           builder: (context) {
  //                             return Center(
  //                               child: CircularProgressIndicator(),
  //                             );
  //                           });
  //                       invoiceDataId = await GetInvoiceById()
  //                           .getInvoiceById(
  //                           invoices[index].invoiceId!);
  //                       Navigator.of(context).pop();
  //                       if (invoiceDataId.result == 1) {
  //                         // write code here
  //                         editeCart(invoiceDataId, context);
  //                         Navigator.of(context)
  //                             .pushReplacementNamed(My_basket.root);
  //                       }
  //                     },
  //                   ),
  //                   DataCell(
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         personName,
  //                         style: TextStyle(
  //                             fontSize: 17.sp,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black),
  //                       ),
  //                     ),
  //                     onTap: () async {
  //                       InvoiceDataEditeApi invoiceDataId;
  //                       showDialog(
  //                           context: context,
  //                           builder: (context) {
  //                             return Center(
  //                               child: CircularProgressIndicator(),
  //                             );
  //                           });
  //                       invoiceDataId = await GetInvoiceById()
  //                           .getInvoiceById(
  //                           invoices[index].invoiceId!);
  //                       Navigator.of(context).pop();
  //                       if (invoiceDataId.result == 1) {
  //                         // write code here
  //                         editeCart(invoiceDataId, context);
  //                         Navigator.of(context)
  //                             .pushReplacementNamed(My_basket.root);
  //                       }
  //                     },
  //                   ),
  //                   DataCell(
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         invoices[index].totalPrice!.toString(),
  //                         style: TextStyle(
  //                             fontSize: 17.sp,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black),
  //                       ),
  //                     ),
  //                     onTap: () async {
  //                       InvoiceDataEditeApi invoiceDataId;
  //                       showDialog(
  //                           context: context,
  //                           builder: (context) {
  //                             return Center(
  //                               child: CircularProgressIndicator(),
  //                             );
  //                           });
  //                       invoiceDataId = await GetInvoiceById()
  //                           .getInvoiceById(
  //                           invoices[index].invoiceId!);
  //                       Navigator.of(context).pop();
  //                       if (invoiceDataId.result == 1) {
  //                         // write code here
  //                         editeCart(invoiceDataId, context);
  //                         Navigator.of(context)
  //                             .pushReplacementNamed(My_basket.root);
  //                       }
  //                     },
  //                   ),
  //                   DataCell(
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         invoices[index].discount.toString(),
  //                         style: TextStyle(
  //                             fontSize: 17.sp,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.black),
  //                       ),
  //                     ),
  //                     onTap: () async {
  //                       InvoiceDataEditeApi invoiceDataId;
  //                       showDialog(
  //                           context: context,
  //                           builder: (context) {
  //                             return Center(
  //                               child: CircularProgressIndicator(),
  //                             );
  //                           });
  //                       invoiceDataId = await GetInvoiceById()
  //                           .getInvoiceById(
  //                           invoices[index].invoiceId!);
  //                       Navigator.of(context).pop();
  //                       if (invoiceDataId.result == 1) {
  //                         // write code here
  //                         editeCart(invoiceDataId, context);
  //                         Navigator.of(context)
  //                             .pushReplacementNamed(My_basket.root);
  //                       }
  //                     },
  //                   ),
  //                   DataCell(
  //                     Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Icon(
  //                         Icons.remove_red_eye_rounded
  //                       ),
  //                     ),
  //                     onTap: () async {
  //                       InvoiceDataEditeApi invoiceDataId;
  //                       showDialog(
  //                           context: context,
  //                           builder: (context) {
  //                             return Center(
  //                               child: CircularProgressIndicator(),
  //                             );
  //                           });
  //                       invoiceDataId = await GetInvoiceById()
  //                           .getInvoiceById(
  //                           invoices[index].invoiceId!);
  //                       Navigator.of(context).pop();
  //                       if (invoiceDataId.result == 1) {
  //                         // write code here
  //                         editeCart(invoiceDataId, context);
  //                         Navigator.of(context)
  //                             .pushReplacementNamed(My_basket.root);
  //                       }
  //                     },
  //                   ),
  //                 ],
  //                     color: MaterialStateProperty.resolveWith ((Set  states) {
  //                   if (states.contains(MaterialState.selected)) {
  //                     return Theme.of(context).colorScheme.primary.withOpacity(0.08);
  //                   }
  //                   return null;  // Use the default value.
  //                 }),
  //                 );
  //               },
  //               ),
  //             ]
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void editeCart(InvoiceDataEditeApi invoiceDataEditeApi, BuildContext context) {
    var provider = Provider.of<Cart_Items>(context, listen: false);
    provider.invoiceData=InvoiceData();
    provider.counterDiscountCheek = 0 ;
    provider.isDiscountOnItem=false;
    provider.remove_all_items();
    provider.isEdite=false;
    provider.settingGeneral.editeInvoice=false;
    provider.settingGeneral.returnInvoice=false;
    provider.returnInvoice=false;

    //provider.invoiceData=InvoiceData();
    provider.updat();
    try {
      provider.invoiceData = invoiceDataEditeApi.invoiceData!;
      provider.isEdite = true;
      provider.invoiceData.edit = true;
      provider.settingGeneral.applyVat =
          invoiceDataEditeApi.invoiceData!.applyVat;
      provider.settingGeneral.activeDiscount =
          invoiceDataEditeApi.invoiceData!.activeDiscount;
      provider.settingGeneral.roundNum =
          invoiceDataEditeApi.invoiceData!.roundNumber;
      provider.settingGeneral.editeInvoice = true;
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

        item.qty = invoiceDataEditeApi.invoiceData!.invoiceDetails![i].quantity!
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
      print(e.toString());
    }
  }
}

// Widget testDropdown(BuildContext){
//   return DropdownButtonHideUnderline(
//     child: DropdownButton2(
//       isExpanded: true,
//       hint: Container(
//         child: TextFormField(
//           decoration: InputDecoration(
//
//             label: Text("clint code "),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5.r),
//               borderSide: BorderSide(
//                 color: Colors.grey,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.lightBlue),),
//           ),
//         ),
//       ),
//         items: items
//             .map((String item) => DropdownMenuItem<String>(
//           value: item,
//           child: Text(
//             item,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ))
//             .toList(),
//       value: selectedValue,
//       onChanged: (value) {
//         setState(() {
//           selectedValue = value.toString() ;
//         });
//       },
//       buttonStyleData: ButtonStyleData(
//         height: 50,
//         width: 160,
//         padding: const EdgeInsets.only(left: 14, right: 14),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: Colors.black26,
//           ),
//           color: Colors.redAccent,
//         ),
//         elevation: 2,
//       ),
//       iconStyleData: const IconStyleData(
//         icon: Icon(
//           Icons.arrow_forward_ios_outlined,
//         ),
//         iconSize: 14,
//         iconEnabledColor: Colors.yellow,
//         iconDisabledColor: Colors.grey,
//       ),
//       dropdownStyleData: DropdownStyleData(
//         maxHeight: 200,
//         width: 200,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           color: Colors.redAccent,
//         ),
//         offset: const Offset(-20, 0),
//         scrollbarTheme: ScrollbarThemeData(
//           radius: const Radius.circular(40),
//           thickness: MaterialStateProperty.all<double>(6),
//           thumbVisibility: MaterialStateProperty.all<bool>(true),
//         ),
//       ),
//
//       menuItemStyleData: const MenuItemStyleData(
//         height: 40,
//         padding: EdgeInsets.only(left: 14, right: 14),
//       ),
//     ),
//   );
// }

// var _value=-1;
//    Widget PersonDropDownField(BuildContext context){
//     return DropdownButtonFormField(
//       value:_value ,
//         items:[
//           DropdownMenuItem(child: Text("client code"),
//             value: "-1",
//           ),
//           DropdownMenuItem(child: Text("clienlt code"),
//             value: "1",
//           ),
//           DropdownMenuItem(child: Text("clientkk code"),
//             value: "2",
//           ),
//           DropdownMenuItem(child: Text("clienllllt code"),
//             value: "3",
//           ),
//           DropdownMenuItem(child: Text("clientllml code"),
//             value: "4",
//           ),
//         ] ,
//         onChanged: (val){
//         //_value=val;
//         });
//    }
// Widget PersonDropDownField(BuildContext context){
//       return DropDownTextField(
//       //controller: dropDownController,
//         clearOption: false,
//       enableSearch :true,
//       searchShowCursor: false,
//       dropDownItemCount: 6,
//         dropDownList: const [
//           DropDownValueModel(name: 'name1', value: "value1"),
//           DropDownValueModel(
//               name: 'name2',
//               value: "value2",
//               toolTipMsg:
//               "DropDownButton is a widget that we can use to select one unique value from a set of values"),
//           DropDownValueModel(name: 'name3', value: "value3"),
//           DropDownValueModel(
//               name: 'name4',
//               value: "value4",
//               toolTipMsg:
//               "DropDownButton is a widget that we can use to select one unique value from a set of values"),
//           DropDownValueModel(name: 'name5', value: "value5"),
//           DropDownValueModel(name: 'name6', value: "value6"),
//           DropDownValueModel(name: 'name7', value: "value7"),
//           DropDownValueModel(name: 'name8', value: "value8"),
//         ],
//       onChanged: (val){},
//     );
// }
/// Widget test4(){
//     return SearchableDropdown<PersonInvoiceDropDown>.paginated(
//       hintText: const Text('Paginated request'),
//       margin: const EdgeInsets.all(15),
//
//       paginatedRequest: (int page, String? searchKey) async {
//         // DataFromApi pagination=DataFromApi();
//         final paginatedList = await GetPersonDropDown().getPersonDropDown(page ,10);
//
//          return paginatedList?.data
//             ?.map<SearchableDropdownMenuItem<PersonInvoiceDropDown>>((PersonInvoiceDropDown e) =>
//
// //-----------
//             SearchableDropdownMenuItem<PersonInvoiceDropDown>(value: e , label: e.arabicName ?? '', child: Text(e.arabicName ?? '')))
//             .toList();
//
//         //var futureList=Future<List<SearchableDropdownMenuItem<PersonInvoiceDropDown>>?>.value(paginationConvertedList !=null?paginationConvertedList:[]);
//        // return paginationConvertedList;
//       },
//
//       requestItemCount: 10,
//       onChanged: (value) {
//         print('$value');
//       },
//     );
//   }
///Widget searchDropDown(BuildContext context){
//     print("the person size id ${person.id}");
//     return Flexible(
//       child: SizedBox(
//         height: 40.h,
//         child: SearchField<PersonInvoiceDropDown>(
//           //focusNode: focus,
//           controller: clientController,
//           scrollbarAlwaysVisible:true ,
//           hint: "client code",
//           searchStyle: TextStyle(
//             fontSize: 18,
//             color: Colors.black.withOpacity(0.8),
//           ),
//           maxSuggestionsInViewPort: 4,
//           searchInputDecoration: InputDecoration(
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black.withOpacity(0.8),
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             border: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.black),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//             itemHeight: 50,
//             suggestionItemDecoration: BoxDecoration(
//               color: Colors.white,
//             ),
//
//           suggestions:personDropDownList.data!
//               .map((e) => SearchFieldListItem<PersonInvoiceDropDown>(e.arabicName,
//             item: e,
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal:16.0),
//                 child: Text(e.arabicName,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ),
//           ),)
//               .toList(),
//           onSuggestionTap: (SearchFieldListItem<PersonInvoiceDropDown>va){
//                 print("gggggggg");
//                 person = va.item!;
//                 print("the person id is ${va.item!.id}");
//             //focus.unfocus();
//           },
//
//         ),
//       ),
//     );
//   }
///  Widget test(BuildContext context){
//     return  DropdownButton<int>(
//       hint: Text("client code"),
//
//       items: new List<DropdownMenuItem<int>>.generate(
//         50,
//             (int index) => new DropdownMenuItem<int>(
//           value: index,
//           child: new Text(index.toString()),
//         ),
//       ),
//       onChanged: (value) {},
//     );
//   }
