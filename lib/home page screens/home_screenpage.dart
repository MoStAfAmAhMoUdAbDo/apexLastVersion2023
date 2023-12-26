// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:apex/api_directory/get_all_category_data.dart';
import 'package:apex/api_directory/open_session_api.dart';
import 'package:apex/home%20page%20screens/round_number.dart';
import 'package:apex/home%20page%20screens/serial_item.dart';
import 'package:apex/home%20page%20screens/session_popup.dart';
import 'package:apex/home%20page%20screens/signalRProvider.dart';
import 'package:apex/model.dart';
import 'package:apex/models/category_data..dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_directory/get_activdis_vatPrice.dart';
import '../api_directory/get_general_setting_vat.dart';
import '../api_directory/get_home_data.dart';
import '../api_directory/get_other_setting.dart';
import '../api_directory/login_api.dart';
import '../api_directory/payment_method.dart';
import '../api_directory/search_barcode.dart';
import '../costants/color.dart';
import '../models/other_payment_method.dart';
import 'cart_items.dart';
import 'cart_screen.dart';
import '../models/items.dart';
import 'expiry_item.dart';
import 'massage_toast.dart';
import 'menu_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

List<Item> mainListForItems=[];
List<CategoryData> mainListForCat=[];
bool gridButton=false;
class home_screen extends StatefulWidget {
  const home_screen({super.key});
  static const rout = '/home_screen';
  static bool reloadHomepage=true;
  static List<PaymentMethods> paymentMethodList =[];

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen>
    with TickerProviderStateMixin {
  String searchValue = "";
  List<Item> myCart = mainListForItems;
  List<Item> newListSearch = mainListForItems;
  bool isConvert = true;
  final _globalKey =  GlobalKey<ScaffoldState>();

  TextEditingController txtPriceController = TextEditingController();
  TextEditingController txtValueController = TextEditingController();
  TextEditingController txtTotalValue = TextEditingController();
  int lastId = 0;
  List<CategoryData> categoryData = mainListForCat;
  late ScrollController _scrollController;
  bool isLoadMore = false;
  int pageNumber = 1;
  //TextEditingController txtPriceController = TextEditingController();
  bool searchChange = true;
  bool isOpened = true;
  TextEditingController txtSearchController = TextEditingController();
 late String result;
  //LoginData barCodeResult=LoginData();
  var barCodeResult;
  double flagScroll = 0;
  int pageSize = 30;
  late AnimationController _animationController;
  FToast fToast =FToast();
  var resultOfSession;
  String titleHomePage="";

  @override
  void initState() {
    _requestCompleter = Completer<void>();
    Future.delayed(Duration.zero,(){
      titleHomePage= AppLocalizations.of(context)!.allcactegory;
    });
    super.initState();
    signalRContext=context;
    fToast.init(context);
    sessionPos();
      //callApi();
    // });
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
  }
  void sessionGetData()async
  {
    resultOfSession= await OpenPosSession().openPosSession();
  }
  sessionPos(){
    sessionGetData();
    if(resultOfSession.result == 1){
      //getGeneralSetting();
      if(mainListForItems.isEmpty)
      {
        if(mounted){
          callApi();
          setState(() {
          });
        }
      }
    }
    else{
      String massage=Provider.of<modelprovider>(context,listen: false).applocal ==const Locale("ar") ? resultOfSession.errorMassageAr :resultOfSession.errorMassageEn;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder:(context){
            return WillPopScope(
                onWillPop: ()async {
                  return false;
                },
                child: SessionPopUp(massage: massage,newContext: context,));
          });
    }
  }

  Completer<void>? _requestCompleter;
  void callApi() {
    if (!_requestCompleter!.isCompleted) {
      getCategoryDataApi();

      getOtherMethodsOfPayment();
      getHomeDataApi();
    }
  }
  void getOtherMethodsOfPayment(){
    OtherPaymentMethods().getPaymentMethods().then((value) {
      home_screen.paymentMethodList=value;
    });
  }
  int categoryId = 0;
  bool stopLoading =false;
  void getHomeDataApi([int id = 0]) {
    if(mounted){
      getHomeData().getCategoryData(pageNumber, id, "", categoryId,pageSize).then((value) {
        if(mounted){
          setState(() {
            mainListForItems.addAll(value);
            myCart= mainListForItems;
            newListSearch = myCart;
            if(value.isEmpty || value.length<pageSize){
              stopLoading=true;
            }
            else{
              stopLoading=false;
            }
          });
        }

      });
    }

  }

  void getCategoryDataApi() {
    if(mounted){
      categoryData.clear();  // i cleare the all data in the category data before make any thing
      GetAllGategoryData().getAllCat().then((value) {
        if(mounted){
          setState(() {
            mainListForCat.addAll(value);
            categoryData = mainListForCat;
          });
        }

      });
    }
  }


  void getGeneralSetting() {

    var cartProvider = Provider.of<Cart_Items>(context, listen: false);
    if(mounted){//id: 2,latinName: "Cash Customer" ,arabicName: "عميل نقدي"
      if(cartProvider.personId == null){
        cartProvider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
      }
      getGeneralSettingVat().getGeneralVat().then((value) {
        if(mounted){
          setState(() {
            cartProvider.dataSetting = value;
            cartProvider.settingGeneral.dataSetting = value;
          });
        }

      });
    }
   if(mounted){
     getActDiscountwithVatprice().GetVatActiveDiscount().then((value) {
       if(mounted){
         setState(() {
           cartProvider.dataDisVat = value;
           cartProvider.settingGeneral.dataDisVat=value;
           //cartProvider.settingGeneral.modifyPrice=true;
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
  }

  Future<void> _scrollListener() async {
   // print(_scrollController.position.pixels );
   // print("max pixel is ${_scrollController.position.maxScrollExtent}");
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 400 &&
        _scrollController.position.pixels > flagScroll &&
        newListSearch.length >= 20) {
      flagScroll = _scrollController.position.maxScrollExtent;
      pageNumber++;
      int value =
          lastId == 0 ? newListSearch[newListSearch.length - 1].id! : lastId;
      if(mounted){
        getHomeDataApi(value);
      }
      lastId = 0;
    }
  }

  @override
  void dispose() {

    if(mounted){
      txtTotalValue.dispose();
      txtPriceController.dispose();
      txtValueController.dispose();// here make change
      txtSearchController.dispose();// here make change
      _scrollController.dispose();// here make change
      _animationController.dispose();
    }
    super.dispose();
   // here make change
  }

  void _onPressed() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
  int exitCount=0;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }
  }


  String removeDecimalIfNeeded(double number) {
    String formattedNumber = number.toString();

    if (formattedNumber.contains('.') && !formattedNumber.contains(RegExp(r'[1-9]'))) {
      // If the number has a decimal point and no digit after the decimal point
      // Remove the decimal point and trailing zeros
      formattedNumber = formattedNumber.replaceAll(RegExp(r'\.0*$'), '');
    }

    return formattedNumber;
  }
  //String vat=getGeneralSettingVat.generalData!.vatDefaultValue.toString();
  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    if(titleHomePage==""){
      titleHomePage= lang!.allcactegory;
    }
      return WillPopScope(
      onWillPop: ()async {
        exitCount ++;
        Timer(const Duration(seconds: 2), () { // <-- Delay here
          if(mounted){
            setState(() {
              // <-- Code run after delay
              exitCount=0;
            });
          }
        });
        if( exitCount<2){
          fToast.init(context);
          MassageForToast().massageForAlert( "press back button again to exit",false,fToast ,"back");
          return false;
        }
        else{
          SharedPreferences pref = await SharedPreferences.getInstance();// some changes i do in 18/10
          pref.setBool("isLogin", true);
          pref.setString("token", loginapi.token);
          pref.setString("dateOfBack", DateTime.now().toString());
          return true;
        }
      },
      child: Scaffold(

          appBar: AppBar(
            iconTheme: IconThemeData(color: basicColor),
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                //_onPressed();
                if (_globalKey.currentState!.isDrawerOpen == false) {
                 if(mounted){
                   setState(() {
                     _onPressed();
                     _globalKey.currentState!.openDrawer();
                   });
                 }
                } else {
                  _onPressed();
                  _globalKey.currentState!.closeDrawer();
                }
              },
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress: _animationController,
                color: basicColor,
                size: 32,
              ),
            ),
            title: searchChange
                ? Text(
              titleHomePage,
                    style: TextStyle(color: basicColor, fontSize: 15.sp,fontWeight: FontWeight.bold),
                  )
                : search(),
            actions: [
              searchChange ? appBar() : Container(),
            ],
          ),
          body: Scaffold(
            //isOpened=false;
            onDrawerChanged: (val) {
              if (val) {
                if(mounted){
                  setState(() {
                    isOpened = !val;
                    //print("the drawer is opened ${val}");
                  });
                }
              } else {
                if(mounted){
                  setState(() {
                    isOpened = !val;
                    _onPressed();
                    //print("the drawer is close ${val}");
                  });
                }
              }
            },
            key: _globalKey,
            floatingActionButton: SizedBox(
              height: 80.h,
              width: 85.w,
              child: FloatingActionButton.large(
                backgroundColor: basicColor,
                foregroundColor: Colors.white,
                tooltip: lang!.addedcard.toString(),
                onPressed: () {
                  //HapticFeedback.vibrate();
                  //fToast.removeCustomToast();
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) => const My_basket()));
                  Navigator.of(context).pushNamed(My_basket.root);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const  Icon(Icons.shopping_cart_rounded),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.white),
                        child: Consumer<Cart_Items>(
                          builder: (context, prov, child) {
                            String cartQty="";
                            if(prov.totalCartQty() > 0  ){
                              cartQty=prov.roundDouble(prov.totalCartQty(), prov.settingGeneral.roundNumG!).toString();
                            }
                            else{
                              cartQty= prov.totalCartQty().toString();
                            }

                            //print(double.parse(cartQty).toString());
                            return Text(
                             double.parse(cartQty).toString(),
                              style:const TextStyle(color: Colors.black),
                            );
                          },
                        )),
                  ],
                ),
              ),
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  categoryData.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(lang.category.toString()),
                            Center(
                              child: Column(
                                children: [
                                 const Icon(
                                    Icons.description_sharp,
                                    color: Colors.indigo,
                                  ),
                                  Text(
                                    lang.nocategory.toString(),
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Flexible(
                          child: ListView.builder(
                              itemCount: categoryData.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    myCart.clear();
                                    newListSearch.clear();
                                    pageNumber = 1;
                                    flagScroll = 0;
                                    categoryId = categoryData[index].catId!;
                                    titleHomePage=Provider.of<modelprovider>(context,listen: false).applocal==const Locale("ar")?
                                    categoryData[index].arabicName! :categoryData[index].latinName!;
                                    getHomeDataApi();
                                    Navigator.of(context).pop();
                                  },
                                  child: drawerTest(index),

                                  // Card(
                                  //   margin:const EdgeInsets.all(0.5),
                                  //   // elevation: 5,
                                  //   child: ListTile(
                                  //     //style:ListTileTheme(tileColor: Colors.blueGrey, child: null,) ,
                                  //     tileColor: Colors.white10,
                                  //     leading: ClipRRect(
                                  //         borderRadius:
                                  //             BorderRadius.circular(12.0.r),
                                  //         child: categoryData[index].imageUrl ==
                                  //                 null
                                  //             ? Image.asset(
                                  //                 "images/no-image-icon-6.png")
                                  //             : CachedNetworkImage(
                                  //           placeholder: (context, url) => const Center(child: CircularProgressIndicator(),) ,
                                  //           imageUrl: categoryData[index].imageUrl.toString(),
                                  //           errorWidget: (context, url, error) => const Icon(Icons.error),
                                  //         ),),
                                  //         // Image.network(categoryData[index]
                                  //         //         .imageUrl
                                  //         //         .toString())),
                                  //     title: Text(
                                  //       Provider.of<modelprovider>(context).applocal == const Locale("ar")
                                  //           ? categoryData[index].arabicName!
                                  //           : categoryData[index].latinName!,
                                  //       style: TextStyle(
                                  //           fontSize: 14.sp,
                                  //            fontWeight: FontWeight.bold,
                                  //           color: Colors.black),
                                  //       textAlign: TextAlign.center,
                                  //     ),
                                  //   ),
                                  // ),
                                );
                              }),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: basicColor
                      ),
                      onPressed: () {
                        //here some change
                        titleHomePage= lang.allcactegory;
                        isOpened = true;
                        myCart.clear();
                        newListSearch.clear();
                        pageNumber = 1;
                        flagScroll = 0;
                        categoryId = 0;
                        getHomeDataApi();
                        if(mounted){
                          Navigator.of(context).pop();
                        }

                        //Navigator.pushReplacementNamed(context, Main_Screen.rout);
                      },
                      child: Center(
                        child: Text(lang.allcactegory.toString(),style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body:
              // myCart.isEmpty
              //     ? Container(
              //         color: Colors.white,
              //         child:const Center(child: CircularProgressIndicator()),
              //       )
              //     : Container(
              //       color:const Color.fromARGB(255, 224, 224, 224),
              //         child:   check(),
              //
              //     ),
              checkLoading(),
            ),),
    );
  }

  Widget drawerTest(int index){
    return Card(
      margin:const EdgeInsets.all(0.5),
      // elevation: 5,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 35.h,
              width:35.h,
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(12.0.r),
                child: categoryData[index].imageUrl ==
                    null
                    ? Image.asset(
                    "images/no-image-icon-6.png")
                    : CachedNetworkImage(
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(),) ,
                  imageUrl: categoryData[index].imageUrl.toString(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            Provider.of<modelprovider>(context).applocal == const Locale("ar")
                ? categoryData[index].arabicName!
                : categoryData[index].latinName!,
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget  checkLoading(){
    //print("the massage is ${signalRService.massage.result}");
    if(myCart.isEmpty){
     // Timer(Duration(seconds: 2), () { });
      if(stopLoading ==true){
        stopLoading =false;
        return Center(
          child: Text(mounted?
            AppLocalizations.of(context)!.noItemsCategory :"" /// do error here
            ,style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black),),
        );
      }
      else{
        return Container(
          color: Colors.white,
          child:const Center(child: CircularProgressIndicator()),
        );
      }
    }
    else{
      //stopLoading =false;
   return  Container(
        color:const Color.fromARGB(255, 224, 224, 224),
        child:   check(),

      );
    }
   // return Container();
  }
  Widget gridViewConvert() {
   // print(newListSearch);
    var lang = AppLocalizations.of(context);
    var itemLang = Provider.of<modelprovider>(context,listen: false).applocal;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            //mainAxisSpacing: 7,
            crossAxisSpacing: 5,
            childAspectRatio:
                Provider.of<menuProviderOptions>(context).disableImage == false
                    ? .8 // it was 0.7 and this control the height of grid view
                    : 1.33 // make the grid with low height
        ),
        controller: _scrollController,
        shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(),
        itemCount: newListSearch.length >= pageSize &&stopLoading == false ? newListSearch.length + 1 :newListSearch.length,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          if(i < newListSearch.length){
            return  Consumer<Cart_Items>(builder: (context, prov, child) {
              return Consumer<menuProviderOptions>(
                  builder: (context, pro, child) {
                    stopLoading=false;
                    final keyToolTip = GlobalKey<State<Tooltip>>();
                    if (pro.disableImage == false) {
                      return Tooltip(
                        key: keyToolTip,
                        message: itemLang == const  Locale("en")
                            ?
                        newListSearch[i].latinName.toString()
                            :
                        newListSearch[i].arabName.toString(),
                        child: InkWell(
                          onLongPress: (){
                            final dynamic tooltip =keyToolTip.currentState;
                            tooltip?.ensureTooltipVisible();
                          },
                          onTap: () {

                            if (prov.invoiceData.edit == true) {
                              if (prov.invoiceData.isAccredited! == true) {
                                MassageForToast().massageForAlert(lang.isAccredited, false, fToast);
                              } else if (prov.invoiceData.isDeleted == true) {
                                MassageForToast().massageForAlert(lang.isDeleted, false, fToast);
                              } else if (prov.invoiceData.isCollectionReceipt == true) {
                                MassageForToast().massageForAlert(lang.isCollectionReceipt, false, fToast);
                              }
                              else if (prov.invoiceData.isReturn == true) {
                                MassageForToast().massageForAlert(lang.isReturn, false, fToast);
                              }
                              else{
                                ontapFn(i);
                              }
                            }
                            else{
                              ontapFn(i);
                            }


                           //  print("the id of item is ${newListSearch[i].id}");
                           //  if( newListSearch[i].itemTypeId==3){
                           //    expirySheet(newListSearch[i].itemCode!);
                           //  }
                           //  else if(newListSearch[i].itemTypeId==2){
                           //    serialSheet(newListSearch[i].itemCode!);
                           //  }
                           // else if (pro.enablePopup == true) {
                           //    int index = prov.bascet_item.indexWhere(
                           //            (item) => item.id == newListSearch[i].id);
                           //    if (index != -1 && prov.bascet_item.isNotEmpty) {
                           //      txtValueController.text =
                           //          prov.bascet_item[index].qty.toString();
                           //      txtPriceController.text =
                           //      prov.bascet_item[index].units.isEmpty
                           //          ? "0"
                           //          : prov.bascet_item[index].units[0].salePrice1
                           //          .toString();
                           //      txtTotalValue.text=txtPriceController.text;
                           //    } else {
                           //      txtValueController.text =
                           //          newListSearch[i].qty.toString();
                           //      txtPriceController.text = newListSearch[i]
                           //          .units
                           //          .isEmpty
                           //          ? "0"
                           //          : newListSearch[i].units[0].salePrice1.toString();
                           //      txtTotalValue.text=txtPriceController.text;
                           //    }
                           //
                           //    showDialog(
                           //        context: context,
                           //        builder: (context) =>   customDialog(i));
                           //  } else {
                           //    int index = prov.bascet_item.indexWhere(
                           //            (item) => item.id == newListSearch[i].id);
                           //    if (index != -1 && prov.bascet_item.isNotEmpty) {
                           //      prov.bascet_item[index].qty++;
                           //      prov.isEdite=false;
                           //      prov.updat();
                           //    } else {
                           //      prov.isEdite=false;
                           //      prov.add_item(newListSearch[i]);
                           //    }
                           //  }
                          },
                          child: Container(
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 65.h,
                                  width: double.infinity,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: newListSearch[i].imageUrl == null
                                        ? Image.asset("images/no-image-icon-6.png")
                                        :
                                    CachedNetworkImage(
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(),) ,
                                      imageUrl: newListSearch[i].imageUrl.toString(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                    // Image.network(
                                    //     newListSearch[i].imageUrl.toString()),
                                  ),
                                ),
                                Expanded(
                                  // height: 25.h,
                                  child: itemLang ==const  Locale("en")
                                      ?   arabicNameTxT(
                                      newListSearch[i].latinName.toString(), 50)
                                      :   arabicNameTxT(
                                      newListSearch[i].arabName.toString(), 50),
                                ),
                                Text(
                                    "${lang!.price.toString()} : ${newListSearch[i].units.isEmpty ? "0" : newListSearch[i].units[0].salePrice1}"),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Tooltip(
                        key: keyToolTip,
                          message: itemLang == const  Locale("en")
                              ?
                          newListSearch[i].latinName.toString()
                              :
                          newListSearch[i].arabName.toString(),
                        child: InkWell(
                          onLongPress: (){
                            final dynamic toolTip =keyToolTip.currentState;
                            toolTip?.ensureTooltipVisible();
                          },
                          onTap: () {
                            if (prov.invoiceData.edit == true) {
                              if (prov.invoiceData.isAccredited! == true) {
                                MassageForToast().massageForAlert(lang.isAccredited, false, fToast);
                              } else if (prov.invoiceData.isDeleted == true) {
                                MassageForToast().massageForAlert(lang.isDeleted, false, fToast);
                              } else if (prov.invoiceData.isCollectionReceipt == true) {
                                MassageForToast().massageForAlert(lang.isCollectionReceipt, false, fToast);
                              }else if(prov.invoiceData.isReturn == true){
                                MassageForToast().massageForAlert(lang.isCollectionReceipt, false, fToast);
                              }else{
                                ontapFn(i);
                              }
                            }
                            else{
                              ontapFn(i);
                            }
                            // if( newListSearch[i].itemTypeId==3){
                            //   expirySheet(newListSearch[i].itemCode!);
                            // }
                            // else if(newListSearch[i].itemTypeId==2){
                            //   serialSheet(newListSearch[i].itemCode!);
                            // }
                            // else if (pro.enablePopup == true) {
                            //   int index = prov.bascet_item.indexWhere(
                            //           (item) => item.id == newListSearch[i].id);
                            //   if (index != -1 && prov.bascet_item.isNotEmpty) {
                            //     txtValueController.text =
                            //         prov.bascet_item[index].qty.toString();
                            //     txtPriceController.text =
                            //     prov.bascet_item[index].units.isEmpty
                            //         ? "0"
                            //         : prov.bascet_item[index].units[0].salePrice1
                            //         .toString();
                            //     txtTotalValue.text=txtPriceController.text;
                            //   } else {
                            //     txtValueController.text =
                            //         newListSearch[i].qty.toString();
                            //     txtPriceController.text = newListSearch[i]
                            //         .units
                            //         .isEmpty
                            //         ? "0"
                            //         : newListSearch[i].units[0].salePrice1.toString();
                            //     txtTotalValue.text=txtPriceController.text;
                            //   }
                            //
                            //   showDialog(
                            //       context: context,
                            //       builder: (context) =>   customDialog(i));
                            // } else {
                            //   int index = prov.bascet_item.indexWhere(
                            //           (item) => item.id == newListSearch[i].id);
                            //   if (index != -1 && prov.bascet_item.isNotEmpty) {
                            //     prov.isEdite=false;
                            //     prov.bascet_item[index].qty++;
                            //     prov.updat();
                            //   } else {
                            //     prov.isEdite=false;
                            //     prov.add_item(newListSearch[i]);
                            //   }
                            // }
                          },
                          child: Container(
                            width: double.infinity,
                            color: Colors.grey[200],
                            margin: EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 2,
                                  // height: 20.h,
                                  child: //newListSearch[i].latinName!.length > 15
                                  //?
                                  itemLang ==const Locale("en")
                                      ?   arabicNameTxT(
                                      newListSearch[i].latinName.toString(),
                                      50)
                                      :   arabicNameTxT(
                                      newListSearch[i].arabName.toString(),
                                      50),
                                ),
                                // Text(
                                //   "${lang.inStock.toString()} : ${0}",
                                //   style: TextStyle(color: Colors.red),
                                // ),
                                // SizedBox(
                                //   height:2.h ,
                                // ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                      "${lang!.price.toString()} : ${newListSearch[i].units.isEmpty ? "0" : newListSearch[i].units[0].salePrice1}",style: TextStyle(
                                    fontSize: 17.sp
                                  ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  });
            });
          }
          else{
            return const Center(child:  CircularProgressIndicator(),);
          }
        });
  }
  //final key = GlobalKey<State<Tooltip>>();
  Widget listTileConvert() {
    //on_search();
//print("the value of stop loading in listtile is $stopLoading");
    var itemLang = Provider.of<modelprovider>(context).applocal;
    var lang = AppLocalizations.of(context);
    return ListView.builder(
        itemCount:newListSearch.length >= pageSize && stopLoading == false  ?  newListSearch.length + 1 :newListSearch.length,
        shrinkWrap: true,
        controller: _scrollController,
        //physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          //stopLoading=false;
          if(i<newListSearch.length){
            return Consumer<Cart_Items>(
              builder: (context, prov, child) {
                return Card(
                  margin:const EdgeInsets.all(1.0),
                  child: Consumer<menuProviderOptions>(
                    builder: (context, pro, child) {
                      stopLoading=false;
                      final keyToolTip = GlobalKey<State<Tooltip>>();
                      if (pro.disableImage == false) {
                        return Tooltip(
                          key: keyToolTip,
                            message: itemLang == const  Locale("en")
                                   ?
                               newListSearch[i].latinName.toString()
                                   :
                               newListSearch[i].arabName.toString(),
                          child: ListTile(

                            onLongPress: (){
                              final dynamic tooltip = keyToolTip.currentState;
                              tooltip?.ensureTooltipVisible();
                            },
                            onTap: () {
                              if (prov.invoiceData.edit == true) {
                                if (prov.invoiceData.isAccredited! == true) {
                                  MassageForToast().massageForAlert(lang.isAccredited, false, fToast);
                                } else if (prov.invoiceData.isDeleted == true) {
                                  MassageForToast().massageForAlert(lang.isDeleted, false, fToast);
                                } else if (prov.invoiceData.isCollectionReceipt == true) {
                                  MassageForToast().massageForAlert(lang.isCollectionReceipt, false, fToast);
                                }
                                else if (prov.invoiceData.isReturn == true) {
                                  MassageForToast().massageForAlert(lang.isReturn, false, fToast);
                                }
                                else{
                                  ontapFn(i);
                                }
                              }
                              else{
                                ontapFn(i);
                              }

                              // showDialog(context: context, builder: (context)=>serialPopUp());
                              //print("the item code is ${newListSearch[i].itemCode}");

                              // if( newListSearch[i].itemTypeId==3){
                              //   expirySheet(newListSearch[i].itemCode!);
                              // }
                              // else if(newListSearch[i].itemTypeId==2){
                              //   serialSheet(newListSearch[i].itemCode!);
                              // }
                              // else if (pro.enablePopup == true) {
                              //   int index = prov.bascet_item.indexWhere(
                              //           (item) => item.id == newListSearch[i].id);
                              //   if (index != -1 && prov.bascet_item.isNotEmpty) {
                              //     txtValueController.text =
                              //         prov.bascet_item[index].qty.toString();
                              //     txtPriceController.text = prov
                              //         .bascet_item[index].units.isEmpty
                              //         ? "0"
                              //         : prov.bascet_item[index].units[0].salePrice1
                              //         .toString();
                              //     txtTotalValue.text=txtPriceController.text;
                              //   } else {
                              //     txtValueController.text =
                              //         newListSearch[i].qty.toString();
                              //     txtPriceController.text =
                              //     newListSearch[i].units.isEmpty
                              //         ? "0"
                              //         : newListSearch[i]
                              //         .units[0]
                              //         .salePrice1
                              //         .toString();
                              //     txtTotalValue.text=txtPriceController.text;
                              //   }
                              //   showDialog(
                              //       context: context,
                              //       builder: (context) =>   customDialog(i));
                              // } else {
                              //   int index = prov.bascet_item.indexWhere(
                              //           (item) => item.id == newListSearch[i].id);
                              //   if (index != -1 && prov.bascet_item.isNotEmpty) {
                              //     prov.bascet_item[index].qty++;
                              //     prov.isEdite =false;
                              //     prov.updat();
                              //   } else {
                              //     prov.isEdite=false;
                              //     prov.add_item(newListSearch[i]);
                              //   }
                              // }
                            },
                            leading:
                            SizedBox(
                              height: 90.h,
                              width: 71.w,
                              child: newListSearch[i].imageUrl == null
                                  ? Image.asset("images/no-image-icon-6.png",fit: BoxFit.fill,):
                              CachedNetworkImage(
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator(),) ,
                                imageUrl: newListSearch[i].imageUrl.toString(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      itemLang ==const Locale("en")
                                          ?   arabicNameTxT(
                                          newListSearch[i]
                                              .latinName
                                              .toString(),
                                          50)
                                          :   arabicNameTxT(
                                          newListSearch[i].arabName.toString(),
                                          50),
                                      // Text(
                                      //   "${lang.inStock.toString()} : ${0}",
                                      //   style: TextStyle(color: Colors.red),
                                      // ),
                                      Text(
                                          "${lang!.price.toString()} : ${newListSearch[i].units.isEmpty ? "0" : newListSearch[i].units[0].salePrice1}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // trailing: Text(lang.price.toString(),
                            //     style: TextStyle(
                            //         fontSize: 15.sp, fontWeight: FontWeight.bold)),
                          ),
                        );
                      } else {
                        return Tooltip(
                          key: keyToolTip,
                          message: itemLang == const  Locale("en")
                              ?
                          newListSearch[i].latinName.toString()
                              :
                          newListSearch[i].arabName.toString(),
                          child: ListTile(
                            onLongPress: (){
                              final dynamic tooltip = keyToolTip.currentState;
                              tooltip?.ensureTooltipVisible();
                            },
                            onTap: () {

                              if (prov.invoiceData.edit == true) {
                                if (prov.invoiceData.isAccredited! == true) {
                                  MassageForToast().massageForAlert(lang.isAccredited, false, fToast);
                                } else if (prov.invoiceData.isDeleted == true) {
                                  MassageForToast().massageForAlert(lang.isDeleted, false, fToast);
                                } else if (prov.invoiceData.isCollectionReceipt == true) {
                                  MassageForToast().massageForAlert(lang.isCollectionReceipt, false, fToast);
                                }
                                else if (prov.invoiceData.isReturn == true) {
                                  MassageForToast().massageForAlert(lang.isReturn, false, fToast);
                                }
                                else{
                                  ontapFn(i);
                                }
                              }
                              else{
                                ontapFn(i);
                              }

                             //  if( newListSearch[i].itemTypeId==3){
                             //    expirySheet(newListSearch[i].itemCode!);
                             //  }
                             //  else if(newListSearch[i].itemTypeId==2){
                             //    serialSheet(newListSearch[i].itemCode!);
                             //  }
                             // else if (pro.enablePopup == true) {
                             //    int index = prov.bascet_item.indexWhere(
                             //            (item) => item.id == newListSearch[i].id);
                             //    if (index != -1 && prov.bascet_item.isNotEmpty) {
                             //      txtValueController.text =
                             //          prov.bascet_item[index].qty.toString();
                             //      txtPriceController.text = prov
                             //          .bascet_item[index].units.isEmpty
                             //          ? "0"
                             //          : prov.bascet_item[index].units[0].salePrice1
                             //          .toString();
                             //      txtTotalValue.text=txtPriceController.text;
                             //    } else {
                             //      txtValueController.text =
                             //          newListSearch[i].qty.toString();
                             //      txtPriceController.text = newListSearch[i]
                             //          .units
                             //          .isEmpty
                             //          ? "0"
                             //          : newListSearch[i].units[0].salePrice1
                             //          .toString();
                             //      txtTotalValue.text=txtPriceController.text;
                             //    }
                             //
                             //    showDialog(
                             //        context: context,
                             //        builder: (context) =>   customDialog(i));
                             //  } else {
                             //    int index = prov.bascet_item.indexWhere(
                             //            (item) => item.id == newListSearch[i].id);
                             //    if (index != -1 && prov.bascet_item.isNotEmpty) {
                             //      prov.bascet_item[index].qty++;
                             //      prov.isEdite=false;
                             //      prov.updat();
                             //    } else {
                             //      prov.isEdite=false;
                             //      prov.add_item(newListSearch[i]);
                             //    }
                             //  }

                            },
                            title: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      itemLang == const Locale("en")
                                          ?   arabicNameTxT(
                                          newListSearch[i]
                                              .latinName
                                              .toString(),
                                          50)
                                          :   arabicNameTxT(
                                          newListSearch[i].arabName.toString(),
                                          50),
                                      // Text(
                                      //   "${lang.inStock.toString()} : ${0}",
                                      //   style: TextStyle(color: Colors.red),
                                      // ),
                                      Text(
                                          "${lang!.price.toString()} : ${newListSearch[i].units.isEmpty ? "0" : newListSearch[i].units[0].salePrice1}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // trailing: Text(lang.price.toString(),
                            //     style: TextStyle(
                            //         fontSize: 15.sp, fontWeight: FontWeight.bold)),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }

          //}
        });
  }
  void ontapFn(int i){
   var prov= Provider.of<Cart_Items>(context,listen: false);
   var pro=Provider.of<menuProviderOptions>(context,listen: false);

    if( newListSearch[i].itemTypeId==3){
      expirySheet(newListSearch[i].itemCode!);
    }
    else if(newListSearch[i].itemTypeId==2){
      serialSheet(newListSearch[i].itemCode!);
    }
    else if (pro.enablePopup == true) {
      int index = prov.bascet_item.indexWhere(
              (item) => item.id == newListSearch[i].id);
      if (index != -1 && prov.bascet_item.isNotEmpty) {
        txtValueController.text =
            prov.bascet_item[index].qty.toString();
        txtPriceController.text = prov
            .bascet_item[index].units.isEmpty
            ? "0"
            : prov.bascet_item[index].units[0].salePrice1
            .toString();
        txtTotalValue.text=txtPriceController.text;
      } else {
        txtValueController.text =
            newListSearch[i].qty.toString();
        txtPriceController.text = newListSearch[i]
            .units
            .isEmpty
            ? "0"
            : newListSearch[i].units[0].salePrice1
            .toString();
        txtTotalValue.text=txtPriceController.text;
      }

      showDialog(
          context: context,
          builder: (context) =>   customDialog(i));
    } else {
      int index = prov.bascet_item.indexWhere(
              (item) => item.id == newListSearch[i].id);
      if (index != -1 && prov.bascet_item.isNotEmpty) {
        prov.bascet_item[index].qty++;
        prov.isEdite=false;
        prov.updat();
      } else {
        prov.isEdite=false;
        prov.add_item(newListSearch[i]);
      }
    }
  }

  Widget   check() {
    if (gridButton==false) {
      return listTileConvert();
    } else {
      return gridViewConvert();
    }
  }

  // on_search() {
  //   //print("in search fn ");
  //   if (searchValue != "") {
  //     newListSearch.clear();
  //     for (var item in myCart) {
  //       if (item.latinName!
  //           .toLowerCase()
  //           .contains(txtSearchController.text.toString())) {
  //         newListSearch.add(item);
  //         //print("the value in new list is ${newListSearch[0]}");
  //       }
  //     }
  //   } else {
  //     newListSearch.clear();
  //     for (var item in myCart) {
  //       newListSearch.add(item);
  //     }
  //   }
  // }


  void filterSearchResults(String query) {
   if(mounted){
     setState(() {
       // newListSearch = myCart
       //     .where((item) =>
       //         item.latinName!.toLowerCase().contains(query.toLowerCase()) ||
       //         item.arabName!.contains(query.toString()) || item.itemCode!.toLowerCase().contains(query.toLowerCase())
       // ).toList();
       var set1=Set();
       List<Item> temp=[];
       List<Item> uniquelist =
       myCart.where((student) => set1.add(student.latinName)).toList();
       if(query==""){
         newListSearch=myCart;
       }
       else{
         temp= uniquelist
             .where((item) =>
         item.latinName!.toLowerCase().contains(query.toLowerCase()) ||
             item.arabName!.contains(query.toString()) || item.itemCode!.toLowerCase().contains(query.toLowerCase())
         ).toList();
         newListSearch = temp
             .where((item) =>
         item.latinName!.toLowerCase() == query.toLowerCase() ||
             item.arabName == query.toString()
         ).toList();
         temp.removeWhere((item) =>
         item.latinName!.toLowerCase() == query.toLowerCase() ||
             item.arabName == query.toString());
         temp.sort((a,b){
           return a.latinName!.toLowerCase().compareTo(query)  ;
         });
         temp.sort((a,b){
           return a.arabName!.compareTo(query)  ;
         });
         newListSearch.addAll(temp.where((item)=>
         item.latinName!.toLowerCase().startsWith(query.toLowerCase()) ||
             item.arabName!.startsWith(query.toString()) ));

         temp.removeWhere((item)=>
         item.latinName!.toLowerCase().startsWith(query.toLowerCase()) ||
             item.arabName!.startsWith(query.toString()));
         newListSearch.addAll(temp);


       }
     });
   }
  }
bool toSearchFlag=false;
  Widget search() {
    return TextFormField(
      controller: txtSearchController,
      decoration:   textFieldStyleSearch(),
      autofocus: true,
      cursorColor: Colors.black,
      onChanged: (value) {
        toSearchFlag=true;
        searchValue = value;
        filterSearchResults(searchValue);
      },
    );
  }

  InputDecoration   textFieldStyleSearch() {
    var lang = AppLocalizations.of(context);
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: lang!.search.toString(),
      border: InputBorder.none,
      suffixIcon: IconButton(
        onPressed: () {
          if(mounted){
            setState(() {
              searchChange = true;
              txtSearchController.clear();
              searchValue = "";
              filterSearchResults(searchValue);
            });
          }
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      prefixIcon: IconButton(
        onPressed: () async {
          //set page number to default value
          pageNumber = 1;
          lastId = myCart.isEmpty ? 0 : myCart[myCart.length - 1].id!;
         // int x=0;
          if(toSearchFlag==true)
          {
           // print("the number of calling api is ${x++} ");
            newListSearch.clear();
            await getHomeData()
                .getCategoryData(pageNumber, 0, searchValue)
                .then((value) {
              //myCart.addAll(value);
              newListSearch.addAll(value);
              myCart.addAll(value);
              toSearchFlag=false;
              if(mounted){
                setState(() {});
              }
            });
          }

        },
        icon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
      ),
    );
  }

  InputDecoration textFieldStyle() {
    return InputDecoration(
        filled: true,
        fillColor: Colors.grey[400],

        enabledBorder: OutlineInputBorder(
          borderSide:const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(25.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(25.r),
        ));
  }


  Widget appBar() {
    var provider =Provider.of<Cart_Items>(context, listen: false);
    var lang = AppLocalizations.of(context);
    var itemLang = Provider.of<modelprovider>(context,listen: false).applocal;
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if(mounted){
              setState(() {
                searchChange = false;
              });
            }
          },
          icon:  Icon(
            Icons.search,
            color: basicColor,
          ),
        ),
        IconButton(
          onPressed: () async {
            //result = await Navigator.pushNamed(context, Qr_scanner.rout);
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
             // print("the result before condition is $result");
              showDialog(context: context, builder: (context){
                return const Center(child: CircularProgressIndicator(),);
              });
              barCodeResult = await getBarcodeData().searchBarcode(result);
              Navigator.of(context).pop();
              fToast.init(context);
              if(barCodeResult.result==1){
                provider.isEdite=false;
                int index = provider.bascet_item.indexWhere(
                        (item) => item.id == barCodeResult.item!.id);
                if (index != -1 && provider.bascet_item.isNotEmpty) {
                  provider.bascet_item[index].qty++;
                  provider.isEdite =false;
                  provider.updat();
                } else {
                  provider.isEdite=false;
                  provider.add_item(barCodeResult.item!);
                }
                // provider
                //     .add_item(barCodeResult.item!);
                MassageForToast().massageForAlert( lang!.itemAddedSuccessfully,true,fToast);
              }
              else {
               // FlutterRingtonePlayer.playNotification();
                FlutterRingtonePlayer().play(
                  asAlarm: true,
                  // fromAsset: "sound/mixkit-classic-short-alarm-993.wav", // will be the sound on Android

                    fromAsset: "sound/mixkit-interface-option-select-2573.wav",
                    ios: IosSounds.alarm 			   // will be the sound on iOS

                );
                String  msg= itemLang ==const  Locale("en") ? barCodeResult.errorMassageEn! : barCodeResult.errorMassageAr!;
                MassageForToast().massageForAlert(msg ,false,fToast);
              }
            }
            else{
              MassageForToast().massageForAlert(lang!.codeScan ,false,fToast);
            }
          },
          icon:  Icon(
            Icons.qr_code_scanner_outlined,
            color: basicColor,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:gridButton==false? Colors.white10 :Colors.black12, // Shadow color
                blurRadius: 1,      // Shadow blur radius
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              if(mounted){
                gridButton= !gridButton;
                setState(() {
                  isConvert = !isConvert;
                });
              }
            },
            icon: Icon(
              Icons.grid_on_outlined,
              color: basicColor,
            ),
          ),
        ),
      ],
    );
  }

  // void massageForAlert(String massage ,bool failedData ){
  //   fToast.showToast(
  //     child: ToastDesign(massage: massage,failedData:failedData ),
  //     gravity: ToastGravity.TOP,
  //     toastDuration: Duration(seconds: 2),
  //   );
  // }
  double roundDouble(double value, int places){
    // double mod = pow(10.0, places).toDouble();
    // return ((value * mod).round().toDouble() / mod);
    double roundedNumber = double.parse(value.toStringAsFixed(places));
    return roundedNumber;
  }
  Widget   customDialog(int i) {
    double count = 0;
    var lang = AppLocalizations.of(context);
    var itemLang = Provider.of<modelprovider>(context).applocal;
    txtValueController.selection =  TextSelection(
        baseOffset: 0,
        extentOffset:txtValueController.text.length
    );

    return Consumer<Cart_Items>(
      builder: (context, provider, child) {
        //print("the length of name is ${myCart[i].latinName!.substring(0,20)}");
        txtTotalValue.text=(double.parse(txtPriceController.text) * double.parse(txtValueController.text)).toString();

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          child: SizedBox(
            height: 350.h,
            child: Column(
              children: [
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.r),
                      topRight: Radius.circular(5.r),
                    ),
                    color: basicColor,
                  ),
                  alignment: Alignment.center,
                  child: Center(
                    child: itemLang ==const Locale("en")
                        ?   dialogText(
                            newListSearch[i].latinName.toString())
                        :   dialogText(
                            newListSearch[i].arabName.toString()),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 14.h),
                  height: 180.h,
                  child: Column(
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 45.0,right: 45),
                            child: Text(lang!.itemprice.toString()),
                          ),
                          // SizedBox(width: 100,),
                          Padding(
                            padding: const EdgeInsets.only(left: 45.0,right: 42),
                            child: Text(lang.value.toString()),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100.w,
                            child: TextFormField(
                              controller: txtPriceController,
                              textAlign: TextAlign.center,
                              readOnly: true,
                              decoration:   textFieldStyle(),
                              keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                //FilteringTextInputFormatter.digitsOnly,
                                DecimalTextInputFormatter(
                                    decimalRange: provider.settingGeneral.roundNumG!),
                                FilteringTextInputFormatter.allow(RegExp(r'^[\d,.]*$')),
                              ],

                            ),
                          ),
                          SizedBox(
                            width: 100.w,
                            child: TextFormField(
                              controller: txtTotalValue,
                              decoration:   textFieldStyle(),
                              readOnly: true,
                              textAlign: TextAlign.center,
                              keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                //FilteringTextInputFormatter.digitsOnly,
                                DecimalTextInputFormatter(
                                    decimalRange: provider.settingGeneral.roundNumG!),
                                FilteringTextInputFormatter.allow(RegExp(r'^[\d,.]*$')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 17.h),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(
                            //   width: 5.w,
                            // ),
                            IconButton(
                                onPressed: () {
                                  count = double.parse(
                                    txtValueController.text.toString());
                                    txtValueController.text =provider.roundDouble((++count), provider.settingGeneral.roundNumG!).toString();
                                    txtTotalValue.text=provider.roundDouble( (double.parse(txtPriceController.text.toString()) * count), provider.settingGeneral.roundNumG!).toString();

                                  //txtTotalValue.text=(double.parse(txtPriceController.text.toString()) * count).toString();
                                },
                                icon:const Icon(Icons.add_circle, size: 50)),
                            // SizedBox(
                            //   width: 10.w,
                            // ),
                            SizedBox(
                              width: 130.w,
                              child: TextFormField(
                                controller: txtValueController,
                                textAlign: TextAlign.center,
                                autofocus: true,
                                //keyboardType:  TextInputType.number,
                                keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  //FilteringTextInputFormatter.digitsOnly,
                                  DecimalTextInputFormatter(
                                      decimalRange: provider.settingGeneral.roundNumG!),
                                  FilteringTextInputFormatter.allow(RegExp(r'^[\d,.]*$')),
                                  //LengthLimitingTextInputFormatter(6),
                                ],
                                decoration:   textFieldStyle(),
                                onChanged: (val){
                                  if(val.length < 4) {
                                    //print("the value is $val");
                                    if (val.isEmpty) {
                                      if(mounted){
                                        setState(() {
                                          txtValueController.text = "1";
                                        });
                                      }
                                    }
                                    else {
                                      txtTotalValue.text = (double.parse(
                                          txtPriceController.text) *
                                          double.parse(val)).toString();
                                    }
                                  }
                                 if(mounted){
                                   setState(() {

                                   });
                                 }

                                },
                              ),
                            ),
                            // SizedBox(
                            //   width: 20.w,
                            // ),
                            IconButton(
                                onPressed: () {
                                  count = double.parse(
                                      txtValueController.text.toString());
                                  if(count > 1){
                                    txtValueController.text =provider.roundDouble((--count), provider.settingGeneral.roundNumG!).toString();
                                    txtTotalValue.text=provider.roundDouble( (double.parse(txtPriceController.text.toString()) * count), provider.settingGeneral.roundNumG!).toString();
                                  }

                                },
                                icon:const Icon(
                                  Icons.do_not_disturb_on,
                                  size: 50,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50.h,
                      width: 110.w,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          onPressed: () {
                            if (provider.invoiceData.edit == true) {
                              if (provider.invoiceData.isAccredited! == true) {
                                MassageForToast().massageForAlert(lang.isAccredited, false, fToast);
                              } else if (provider.invoiceData.isDeleted == true) {
                                MassageForToast().massageForAlert(lang.isDeleted, false, fToast);
                              } else if (provider.invoiceData.isCollectionReceipt == true) {
                                MassageForToast().massageForAlert(lang.isCollectionReceipt, false, fToast);
                              }
                              else if (provider.invoiceData.isReturn == true) {
                                MassageForToast().massageForAlert(lang.isReturn, false, fToast);
                              }
                              else{
                                provider.isEdite=false;
                                if(double.parse(txtValueController.text.toString()) == 0){
                                  newListSearch[i].qty =1;
                                  provider.add_item(newListSearch[i]);
                                  Navigator.pop(context);
                                }
                                else{
                                  newListSearch[i].qty =roundDouble(
                                      double.parse(txtValueController.text),provider.settingGeneral.roundNumG! );
                                  provider.add_item(newListSearch[i]);
                                  Navigator.pop(context);
                                }
                              }
                            }
                            else{
                              provider.isEdite=false;
                              if(double.parse(txtValueController.text.toString()) ==0){
                                newListSearch[i].qty =1;
                                provider.add_item(newListSearch[i]);
                                Navigator.pop(context);
                              }
                              else{
                                newListSearch[i].qty =
                                    roundDouble(
                                        double.parse(txtValueController.text),provider.settingGeneral.roundNumG! );
                                provider.add_item(newListSearch[i]);
                                Navigator.pop(context);
                              }
                            }


                          },
                          child: Text(lang.confirm.toString(),style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white))),
                    ),
                    SizedBox(
                      height: 50.h,
                      width: 110.w,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(lang.cancel.toString(),style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.white))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget   arabicNameTxT(String name, int length) {
    if (name.length > length) {
      return Text(
        name.substring(0, length).toString(),
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        maxLines: 2,
      );
    } else {
      return Text(
        name,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        maxLines: 2,
      );
    }
  }
  Widget   dialogText(String name) {
      return Text(
        name,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold,color:Colors.white),
        maxLines: 1,
      );

  }

  Widget expiryPopUp(){
    var emailController = TextEditingController();
    var messageController = TextEditingController();
    return AlertDialog(
      title:const Text('Contact Us'),
      content: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics:const BouncingScrollPhysics() ,
        children: [
          TextFormField(
            controller: emailController,
            decoration:const InputDecoration(hintText: 'Email'),
          ),
          TextFormField(
            controller: messageController,
            decoration:const InputDecoration(hintText: 'Message'),
          ),

        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child:const  Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // // Send them to your email maybe?
            // var email = emailController.text;
            // var message = messageController.text;
            Navigator.pop(context);
          },
          child:const  Text('Send'),
        ),
      ],
  );
}

dynamic expirySheet(String itemCode){
 // print("the item code is ${itemCode}");

  return  showModalBottomSheet(context: context,
       isScrollControlled: true,
        builder: (context){
      return Padding(
        padding:EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ExpiryItemSheet(itemCode : itemCode),
      );
    });
}
  dynamic serialSheet(String itemCode){
    //print("item code is ${itemCode}");
    return  showModalBottomSheet(context: context,
        isScrollControlled: true,

        builder: (context){
          return Padding(
            padding:EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),

            child: SerialItem(itemCode: itemCode,),
          );
        });
  }
}
// bool fullOpen=false;