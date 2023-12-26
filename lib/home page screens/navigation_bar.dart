import 'package:apex/costants/color.dart';
import 'package:apex/home%20page%20screens/cart_items.dart';
import 'package:apex/home%20page%20screens/pdf_printing.dart';
import 'package:apex/home%20page%20screens/signalRProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../api_directory/get_activdis_vatPrice.dart';
import '../api_directory/get_all_branches_drop_down.dart';
import '../api_directory/get_financial_drop_down.dart';
import '../api_directory/get_financial_setting.dart';
import '../api_directory/get_general_setting_vat.dart';
import '../api_directory/get_other_setting.dart';
import '../api_directory/get_salesman_dropdown.dart';
import '../model.dart';
import '../models/invoice_data_object.dart';
import '../models/login_data.dart';
import 'add_user/clint_data_view.dart';
import 'alert_massage.dart';
import 'basic_printer.dart';
import 'draft_screen.dart';
import 'home_screenpage.dart';
import 'massage_toast.dart';
import 'menu_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Navigation_bar extends StatefulWidget {
  int? index;
  bool? setIndex= false;
   Navigation_bar({Key? key,this.index,this.setIndex}) : super(key: key);
  static const rout ='/navigation_bar';
  @override
  State<Navigation_bar> createState() => _Navigation_barState();
}

class _Navigation_barState extends State<Navigation_bar> {
  int page_index=0;
  var signalRService ;
  List pages =[
   const  home_screen(),

   const Draft_Screen(),
    const   pdf_printing(),
   // const search_test(),
    const  menuOptions(),
  ];
  FToast fToast =FToast();
  @override
  void initState() {
    // TODO: implement initState
     //page_index = widget.index == null ? 0: widget.index!;
    fToast.init(context);
    //signalRContext=context;
    super.initState();
    print("in navigation bar in init state ");
    getGeneralSetting();

    if(salesManData.salesMan==null  &&
        financialTextCheck.financialSettingModel ==null && financialAccount.financialDropDown==null &&
         branchDataDropDown.employeeBranch ==null ){
      getPersonDataPopUp();
    }
    signalInitial();
  }
  void signalInitial(){
    signalRService=Provider.of<SignalRService>(context, listen: false);
    signalRService.signalInit();
    signalRService.startConnection();
    // if(signalRService.massage.result!=0){
    //   Navigator.pushNamedAndRemoveUntil(context, Arab_login.rout, (route) => false);
    // }
  }

  void getPersonDataPopUp()async{
    salesManData=LoginData();
    financialTextCheck=LoginData();
    financialAccount=LoginData();
    branchDataDropDown=LoginData();
      int pageNumber =1;
      int pageSize=30;
      //if(employeeType.isEmpty && employeeBranch.isEmpty && salesmanDropDown.isEmpty){
        financialTextCheck=await GetFinancialSettingApi().getFinancialSettingApi();
        //print("the financial linkid is ${financialTextCheck.financialSettingModel!.linkingMethodId}");
        if(financialTextCheck.result==1 && financialTextCheck.financialSettingModel!.linkingMethodId==1 &&getFinancialDropDown.isNotEmpty){
          financialAccount = await GetFinancialDropDown().getFinancialDropDown(pageSize, pageNumber);
          //getFinancialDropDown=financialAccount.financialDropDown!;
        }
        branchDataDropDown=await GetAllBranchesDropDown().getAllBranchesDropDown();
        salesManData=await GetSalesManDropDown().getSalesManDropDown(pageSize, pageNumber);
        // salesmanDropDown=salesManData.salesMan!;
        // employeeBranch = branchDataDropDown.employeeBranch!;
      //}
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
  @override
  Widget build(BuildContext context) {
   //print("the index is in navigator bar ${widget.index}");
    //print("the index in navigation is ${widget.index}");
   // print("the reload in navigation is ${home_screen.reloadHomepage}");
    print ("the page index value is ${page_index}");
    print("the widget index is ${widget.index}");
    print("in navigation bar in build  ");
    return Scaffold(
      bottomNavigationBar: navigation_fn(),

      body:
      widget.index== null ?
      pages[page_index]
          : pages[widget.index!],

    );
  }
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }

  }
  Widget navigation_fn(){
    //var lang=AppLocalizations.of(context);
    var provider=Provider.of<Cart_Items>(context);
    return BottomNavigationBar(
      selectedItemColor:basicColor ,
      unselectedItemColor: Colors.grey,
      currentIndex:page_index ,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      unselectedLabelStyle:TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ) ,
      iconSize: 30,
      items:[
        BottomNavigationBarItem(icon:const  Icon(Icons.home),label:AppLocalizations.of(context)!.hometitle.toString() ),
        BottomNavigationBarItem(icon:const Icon(Icons.add,color:Colors.black,),label: AppLocalizations.of(context)!.newInvoiceBtn.toString()),
        // BottomNavigationBarItem(icon:const Icon(Icons.folder),label: AppLocalizations.of(context)!.draft.toString()),
        BottomNavigationBarItem(icon:const Icon(Icons.print_sharp,color:Colors.black,),label: AppLocalizations.of(context)!.print.toString()),
        BottomNavigationBarItem(icon:const Icon(Icons.more_horiz),label: AppLocalizations.of(context)!.more.toString(),),
      ],
      onTap: (val)async{

        if(val == 1){
          widget.index=null;
         // page_index =val;
          if(provider.isEdite==false && provider.bascet_item.isNotEmpty){
            showDialog(
                context: context,
                builder: (context) => WarningMassage(
                    index: -1,
                    massage: AppLocalizations.of(context)!.newInvoice,insideNewButton: false,));
          }
          else{
            provider.counterDiscountCheek = 0 ;
            provider.isDiscountOnItem=false;
            provider.personId.dataparameter(2, "عميل نقدي", "Cash Customer" );
            provider.remove_all_items();
            provider.isEdite=false;
            provider.settingGeneral.editeInvoice=false;
            provider.settingGeneral.returnInvoice=false;
            provider.returnInvoice=false;
            provider.invoiceData=InvoiceData();
            provider.updat();
          }
        }
        else if(val == 2){
          if(provider.settingGeneral.editeInvoice==true){
            //provid.invoiceData.invoiceId
            showDialog(
                barrierDismissible: false,
                context: context, builder: (context){
              // ignore: deprecated_member_use
              return WillPopScope(onWillPop: () async{return false;  },
              child: Center(child: CircularProgressIndicator(),));
            });
            bool isArabic = Provider.of<modelprovider>(context,listen: false).applocal ==Locale("ar")? true :false;
          await  PrintingInvoices().printingInvoice(provider.invoiceData.invoiceId!, provider.invoiceData.invoiceCode!, isArabic, fToast,context);
            // Future.delayed(Duration(seconds: 3), () {});
            Navigator.of(context).pop();

          }
          else{
            fToast.init(context);
            MassageForToast().massageForAlert(AppLocalizations.of(context)!.toPrintSaveInvoice, false, fToast);
          }
        }
        else{
          if(mounted){
            setState(() {
              widget.index=null;
              page_index =val;


            });
          }

        }

      },
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}
