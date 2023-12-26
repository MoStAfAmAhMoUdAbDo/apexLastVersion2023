import 'package:apex/home%20page%20screens/cart_items.dart';
import 'package:apex/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../api_directory/search_barcode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/items.dart';
import '../models/login_data.dart';
import 'massage_toast.dart';
//ignore: must_be_immutable
class ExpiryItemSheet extends StatefulWidget {
  String itemCode;
  ExpiryItemSheet({super.key,required this.itemCode});

  @override
  State<ExpiryItemSheet> createState() => _ExpiryItemSheetState();
}

class _ExpiryItemSheetState extends State<ExpiryItemSheet> {
  final ScrollController _controller= ScrollController();

  //List<Item> expiryItemList=[];
  LoginData expiryItemList=LoginData();
  List<TextEditingController> expiryController = [];
  final formKey = GlobalKey<FormState>();
  FToast fToast =FToast();
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(context.mounted){
      super.setState(fn);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast.init(context);
    getBarcodeData().searchBarcode(widget.itemCode).then((value){
      if(Navigator.canPop(context)){
        setState(() {
          expiryItemList=value;
          for (int i = 0; i < expiryItemList.item!.expiryDate.length; i++) {
            TextEditingController textEditingController = TextEditingController();
            expiryController.add(textEditingController);
          }
        });
      }
    });
  }
  // void massageForAlert(String massage ,bool failedData ){
  //   fToast.showToast(
  //     child: ToastDesign(massage: massage,failedData:failedData ),
  //     gravity: ToastGravity.TOP,
  //     toastDuration: const Duration(seconds: 2),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    var lang=AppLocalizations.of(context);
    var languageType=Provider.of<modelprovider>(context);

    // String itemName=
    return expiryItemList.result ==0 ? SizedBox(
      height: MediaQuery.sizeOf(context).height/3,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ):expiryItemList.item!.expiryDate.isEmpty ? SizedBox(
      height: MediaQuery.sizeOf(context).height/2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Flexible(
        fit: FlexFit.loose,
        flex: 1,
        child: SizedBox(
            height: MediaQuery.sizeOf(context).height / 10,
            width: double.infinity ,
            child: Center( child: FittedBox(
                fit: BoxFit.fill,
                child: Text(lang!.itemsValidity ,style: TextStyle(fontSize: 20.sp ,fontWeight: FontWeight.bold),)))),
      ),
      Flexible(
        fit: FlexFit.loose,
        flex: 1,
        child: SizedBox(
            height: MediaQuery.sizeOf(context).height / 20,
            child: FittedBox(
                fit: BoxFit.fill,
                child: Text("${lang.itemName} :  ${(languageType.applocal == const Locale("ar") ? expiryItemList.item!.arabName! :expiryItemList.item!.latinName!)}" ,style: TextStyle(fontSize: 17.sp ),))),
      ),
         const Flexible(child: Divider(
            thickness: 1,
          )),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 10,
                width: double.infinity ,
                child: Center( child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(lang.noExpirationDates ,style: TextStyle(fontSize: 20.sp ,fontWeight: FontWeight.bold),)))),
          ),
    ]),
    ):
    SingleChildScrollView(
      child: Form(
        key: formKey,
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height/1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: SizedBox(
                    height: MediaQuery.sizeOf(context).height / 10,
                    width: double.infinity ,
                    child: Center( child: FittedBox(
                      fit: BoxFit.fill,
                        child: Text(lang!.itemsValidity ,style: TextStyle(fontSize: 20.sp ,fontWeight: FontWeight.bold),)))),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: SizedBox(
                    height: MediaQuery.sizeOf(context).height / 20,
                    child: FittedBox(
                      fit: BoxFit.fill,
                        child: Text("${lang.itemName} :  ${(languageType.applocal == const Locale("ar") ? expiryItemList.item!.arabName! :expiryItemList.item!.latinName!)}" ,style: TextStyle(fontSize: 17.sp ),))),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue)
                  ),
                  height:200.h ,
                  child: Scrollbar(
                    thumbVisibility :true,
                    controller:_controller ,
                    thickness: 6,
                    radius: Radius.circular(20.r),
                    //viewportBuilder: (BuildContext context, ViewportOffset position) {  },
                    child: ListView(
                      controller: _controller,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Table(
                            border: TableBorder.all(color: Colors.blue,width: 1.w ,borderRadius: BorderRadius.circular(3.r)),
                            // columnWidths:const {
                            //   0: FlexColumnWidth(3),
                            //   1: FlexColumnWidth(3),
                            //   2: FlexColumnWidth(4),
                            // },
                            defaultColumnWidth: IntrinsicColumnWidth(),

// Allows to add a border decoration around your table
                            children: [
                              TableRow(children :[
                                TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child:Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(lang.theValidity ,style: TextStyle(fontSize: 17.sp ,fontWeight: FontWeight.bold ,color: Colors.blue),),
                                    )
                                ),
                                TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child:Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(lang.availableQuantity ,style: TextStyle(fontSize: 17.sp ,fontWeight: FontWeight.bold ,color: Colors.blue),),
                                    )
                                ),
                                TableCell(
                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                    child:Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(lang.quantitySold ,style: TextStyle(fontSize: 17.sp ,fontWeight: FontWeight.bold ,color: Colors.blue),),
                                    )
                                ),

                              ]),
                              ...List.generate(expiryItemList.item!.expiryDate.length, (index) {
                                //print(expiryItemList.item!.expiryDate[index].expiryInvoice.toString());
                                return TableRow(
                                    children: [
                                      TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child:Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(expiryItemList.item!.expiryDate[index].expiryInvoice.toString() ,style:  TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold ,color: Colors.black),),
                                          )
                                      ),
                                      TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child:Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(expiryItemList.item!.expiryDate[index].qtyDate!.toInt().toString() ,style: TextStyle(fontSize: 15.sp ,fontWeight: FontWeight.bold ,color: Colors.black),),
                                          )
                                      ),
                                      TableCell(
                                          verticalAlignment: TableCellVerticalAlignment.middle,
                                          child:Padding(
                                            padding: const  EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 30.h,
                                              width: 40.w,
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                                                  hintText: lang.enterQuantity,
                                                  //alignLabelWithHint:true,
                                                  contentPadding: EdgeInsets.symmetric(vertical: 3.5.h),
                                                  errorBorder:  OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.red ,width:  0.6.w),
                                                  ),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.red.shade300 ,width: 0.6.w),
                                                  ),
                                                  errorStyle:  const TextStyle(height: 0),

                                                ),
                                                controller: expiryController[index],
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.start,
                                                validator: (value) {
                                                  var v =expiryItemList.item!.expiryDate[index].qtyDate.toString();
                                                  // print("the value of validator is ${double.parse(value!)}");
                                                  // print("the value of v is ${v}");
                                                  if(value == null || value.isEmpty){
                                                   return null;
                                                  }
                                                  else{
                                                    if (double.parse(value) >= double.parse(v)  ) {
                                                      return "";
                                                    } else {
                                                      return null;
                                                    }
                                                  }

                                                },
                                              ),
                                            ),
                                          )
                                      ),

                                    ]
                                );
                              } )
                            ]
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 50.h,
                          width: 120.w,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent
                              ),
                              onPressed: (){
                                //var provider =Provider.of<Cart_Items>(context,listen: false);

                                if(formKey.currentState!.validate()){
                                  var provid=Provider.of<Cart_Items>(context,listen: false);
                                  Item item = expiryItemList.item!;
                                  item.isEdite=false;
                                  //List<Item> listItem=[];
                                  for(int i =0 ; i<expiryController.length ;i++){

                                    if(expiryController[i].text.isNotEmpty){
                                      Item temp= item.copyWith();
                                      temp.expiryItemDate = expiryItemList.item!.expiryDate[i].expiryInvoice;
                                      temp.qty = double.parse(expiryController[i].text);
                                      temp.isEdite=false;
                                      provid.add_item(temp);
                                    }
                                  }
                                  provid.isEdite=false;
                                  MassageForToast().massageForAlert(lang.itemAddedSuccessfully,true,fToast);
                                  Navigator.of(context).pop();
                                }
                                else{
                                  MassageForToast().massageForAlert(lang.quantityMoreAvailable,false,fToast);
                                }
                              },
                              child: FittedBox(
                                fit: BoxFit.fill,
                                  child: Text(lang.add, style: TextStyle(color: Colors.black ,fontWeight: FontWeight.bold , fontSize: 20.sp),)))),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    if(mounted){
      for(var con in expiryController){
        if(mounted)
          con.dispose();
      }
    }
    super.dispose();
  }
}

