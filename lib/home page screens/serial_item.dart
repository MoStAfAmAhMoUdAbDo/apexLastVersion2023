  import 'package:apex/home%20page%20screens/cart_items.dart';
  import 'package:apex/models/login_data.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_gen/gen_l10n/app_localizations.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:provider/provider.dart';

  import '../api_directory/search_barcode.dart';
  import '../model.dart';
  import 'massage_toast.dart';

  //ignore: must_be_immutable
  class SerialItem extends StatefulWidget {
    String itemCode;
    SerialItem({super.key, required this.itemCode});

    @override
    State<SerialItem> createState() => _SerialItemState();
  }

  class _SerialItemState extends State<SerialItem> {
    LoginData serialItemList = LoginData();
    TextEditingController inStockController = TextEditingController();
    TextEditingController toSoldController = TextEditingController();
    ScrollController toSoldScrollController = ScrollController();
    ScrollController inStockScrollController = ScrollController();

    //List<LoginData> inStockSerial=[];
    LoginData inStockSerial = LoginData();
    List<String> toSoldSerial = [];
    List<String> inStockSerialList = [];
    List<String> searchInStock=[];
    List<String> searchToSold=[];
    FocusNode inStockFocus = FocusNode();
    FocusNode toSoldFocus = FocusNode();
    FToast fToast = FToast();

    late int founded;
    void setState(VoidCallback fn) {
      // TODO: implement setState
      if(mounted){
        super.setState(fn);
      }

    }
    @override
    void initState() {
      // TODO: implement initState
      fToast.init(context);
      var provider = Provider.of<Cart_Items>(context, listen: false);
      if (provider.bascet_item.isNotEmpty) {
         founded = provider.bascet_item
            .indexWhere((element) => element.itemCode == widget.itemCode);
        if (founded != -1) {
          if (provider.bascet_item[founded].selectedSerialItems.isNotEmpty) {
            toSoldSerial = provider.bascet_item[founded].selectedSerialItems;
            searchToSold=toSoldSerial;
          }
        }
      }

      getSerialItem();

      focusListener(inStockFocus);
      focusListenerw(toSoldFocus);
      super.initState();
    }
    void focusListener(FocusNode focusNode) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {

        } else {
          inStockSerialList=searchInStock;
        }
      });
    }
    void focusListenerw(FocusNode focusNode) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {

        } else {
          toSoldSerial=searchToSold;
        }
      });
    }
    void filterSearchResults(String query,int searchType) {
      if(mounted){
        setState(() {
          if(searchType==1){
            //searchInStock=inStockSerialList;

            inStockSerialList = searchInStock
                .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
                .toList();
          }
          else if(searchType ==2){
            // searchToSold=toSoldSerial;

            toSoldSerial = searchToSold
                .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
                .toList();
          }
        });
      }
    }
  bool emptyList =false;
    void getSerialItem() async {
      inStockSerial = await getBarcodeData().searchBarcode(widget.itemCode);
      var provider =Provider.of<Cart_Items>(context,listen: false);
      if (inStockSerial.result == 1) {
        inStockSerialList.addAll(inStockSerial.item!.existedSerials!) ;
        if (toSoldSerial.isNotEmpty) {
          for (String serial in toSoldSerial) {
            inStockSerialList.removeWhere((element) => serial == element);
          }
        }
        if (provider.bascet_item.isNotEmpty) {

          if (founded != -1) {
            if (provider.bascet_item[founded].selectedSerialItems.isNotEmpty) {
              inStockSerial.item!.selectedSerialItems=provider.bascet_item[founded].selectedSerialItems;
            }
          }
        }
        if(inStockSerial.item!.existedSerials!.isEmpty){
          emptyList=true;
        }
        searchInStock.addAll(inStockSerialList);
        print("in search list len ${searchInStock.length}");
      }

      if(mounted){
        setState(() {});
      }
    }

    @override
    Widget build(BuildContext context) {
      //print("in search list len ${searchInStock.length}");
      var lang = AppLocalizations.of(context);
      var languageType = Provider.of<modelprovider>(context).applocal;
      //print(inStockSerial.item!.existedSerials);
      return inStockSerial.result == 0
          ? SizedBox(
              height: MediaQuery.sizeOf(context).height / 3,
              child: const Center(
                child: CircularProgressIndicator(),
              ))
          : emptyList
              ? emptySerialList()
              : SizedBox(
                  height: MediaQuery.sizeOf(context).height / 1.3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          //fit: FlexFit.loose,
                          flex: 2,
                          child: SizedBox(
                              height: MediaQuery.sizeOf(context).height / 25,
                              width: double.infinity,
                              child: Center(
                                  child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        lang!.serialNumbers,
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold),
                                      )))),
                        ),
                        Flexible(
                          //fit: FlexFit.tight,
                          flex: 2,
                          child: SizedBox(
                              height: MediaQuery.sizeOf(context).height / 22,
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "${lang.itemName} :${languageType == const Locale("ar") ? inStockSerial.item!.arabName : inStockSerial.item!.latinName} ",
                                    style: TextStyle(fontSize: 20.sp),
                                  ))),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Flexible(
                          //fit: FlexFit.loose,
                          flex: 2,
                          child: SizedBox(
                              height: MediaQuery.sizeOf(context).height / 22,
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    lang.selectSerialNumbers,
                                    style: TextStyle(fontSize: 30.sp),
                                  ))),
                        ),
                        Flexible(
                          flex: 10,
                          child: StatefulBuilder(builder: (context, myState) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width / 2,
                                      height: 215.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blue,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r))),
                                      child: Column(
                                        children: [
                                          Text(lang.inStock),
                                          const Divider(
                                            thickness: 1,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                            child: Center(
                                              child: TextFormField(
                                                focusNode: inStockFocus,
                                                controller: inStockController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      lang.enterSerialNumber,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.h,
                                                          horizontal: 6.w),
                                                  // hintStyle: TextStyle(
                                                  //   fontSize: 12.sp,),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.r),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: .6.w)),
                                                ),

                                                onChanged: (value){
                                                  filterSearchResults(value,1);// 1 that meaning i search in in stock items
                                                },
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Scrollbar(
                                              thumbVisibility: true,
                                              radius: Radius.circular(10.r),
                                              thickness: 5,
                                              controller: inStockScrollController,
                                              child: ListView.builder(
                                                controller:
                                                    inStockScrollController,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    inStockSerialList.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 0.0.h,
                                                            horizontal: 12.w),
                                                    dense: true,
                                                    visualDensity: VisualDensity(
                                                        vertical: -2.4.h),
                                                    onTap: () {
                                                      myState(() {
                                                        String serial =inStockSerialList[index];
                                                        //print("the serial is $serial");
                                                        searchToSold.add(serial);
                                                        toSoldSerial=searchToSold;
                                                        inStockSerial.item!.selectedSerialItems.add(serial);
                                                        inStockSerial.item!.existedSerials!.remove(serial);
                                                        searchInStock.remove(serial);
                                                        inStockSerialList=searchInStock;
                                                        inStockController.clear();
                                                        //filterSearchResults("", 1);
                                                      });
                                                    },
                                                    leading: Text(
                                                        inStockSerialList[index]),
                                                    trailing:
                                                        const Icon(Icons.menu),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      height: 215.h,
                                      width: MediaQuery.sizeOf(context).width / 2,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blue),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.r))),
                                      child: Column(
                                        children: [
                                          Text(lang.toSold),
                                          const Divider(
                                            thickness: 1,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                            child: Center(
                                              child: TextFormField(
                                                controller: toSoldController,
                                                focusNode: toSoldFocus,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      lang.enterSerialNumber,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 2.h,
                                                          horizontal: 6.w),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.r),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: .6.w)),
                                                ),
                                                onChanged: (value){
                                                    filterSearchResults(value,2);// 2 that meaning i search in sold item
                                                },
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Scrollbar(
                                              thumbVisibility: true,
                                              radius: Radius.circular(10.r),
                                              thickness: 5,
                                              controller: toSoldScrollController,
                                              child: ListView.builder(
                                                controller:
                                                    toSoldScrollController,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: toSoldSerial.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 0.0.h,
                                                            horizontal: 12.w),
                                                    dense: true,
                                                    visualDensity: VisualDensity(
                                                        vertical: -2.4.h),
                                                    onTap: () {
                                                      myState(() {
                                                        String serial=toSoldSerial[index];
                                                        inStockSerial.item!.existedSerials!.add(serial);
                                                        searchInStock.add(serial);
                                                        searchToSold.remove(serial);
                                                        inStockSerialList=searchInStock;
                                                        inStockSerial.item!.selectedSerialItems.remove(serial);
                                                        toSoldSerial=searchToSold;
                                                        toSoldController.clear();
                                                      });
                                                    },
                                                    leading:
                                                        Text(toSoldSerial[index]),
                                                    trailing:
                                                        const Icon(Icons.menu),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        Flexible(
                          flex: 3,
                          child: Row(
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
                                              backgroundColor:
                                                  Colors.greenAccent),
                                          onPressed: () {
                                            var provid=Provider.of<Cart_Items>(context,
                                                listen: false);
                                            inStockSerial.item!.isEdite=false;
                                            provid.isEdite=false;
                                            provid.add_item(inStockSerial.item!);

                                            MassageForToast().massageForAlert(
                                                lang.itemAddedSuccessfully,
                                                true,
                                                fToast);
                                            Navigator.of(context).pop();
                                            // MassageForToast().massageForAlert("",false ,fToast);
                                            //var provider =Provider.of<Cart_Items>(context,listen: false);
                                          },
                                          child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: Text(
                                                lang.add,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.sp),
                                              )))),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                );
    }

    Widget emptySerialList() {
      var lang = AppLocalizations.of(context);
      return SizedBox(
          height: MediaQuery.sizeOf(context).height / 3,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  flex: 2,
                  child: SizedBox(
                      height: MediaQuery.sizeOf(context).height / 20,
                      width: double.infinity,
                      child: Center(
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                lang!.serialNumbers,
                                style: TextStyle(
                                    fontSize: 20.sp, fontWeight: FontWeight.bold),
                              )))),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  flex: 2,
                  child: SizedBox(
                      height: MediaQuery.sizeOf(context).height / 22,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "${lang.itemName} :  ${Provider.of<modelprovider>(context).applocal == Locale("ar") ? inStockSerial.item!.arabName : inStockSerial.item!.latinName}",
                            style: TextStyle(fontSize: 17.sp),
                          ))),
                ),
                const Flexible(
                    child: Divider(
                  thickness: 1,
                )),
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: SizedBox(
                      height: MediaQuery.sizeOf(context).height / 10,
                      width: double.infinity,
                      child: Center(
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                lang.thereNoSerialNumbers,
                                style: TextStyle(
                                    fontSize: 20.sp, fontWeight: FontWeight.bold),
                              )))),
                ),
              ]));
    }

    @override
    void dispose() {
      // TODO: implement dispose
      if(mounted){
        inStockController.dispose();
        toSoldScrollController.dispose();
      }
      super.dispose();
    }
  }
