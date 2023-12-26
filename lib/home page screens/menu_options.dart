


// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:apex/api_directory/login_api.dart';
import 'package:apex/home%20page%20screens/signalRProvider.dart';
import 'package:apex/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'alert_massage.dart';
import 'main_screen.dart';
import 'massage_toast.dart';
import 'menu option repo/comment_popup.dart';
import 'menu option repo/get_invoice_popup.dart';
import 'menu option repo/return_pos_view.dart';
import 'menu_provider.dart';


class menuOptions extends StatefulWidget {
  const menuOptions({super.key});

  @override
  State<menuOptions> createState() => _menuOptionsState();
}

class _menuOptionsState extends State<menuOptions> {
  bool isLogin=false;
  Save_data() async {
    //var setting=Provider.of<menuProviderOptions>(context);
  var  setting=Provider.of<menuProviderOptions>(context,listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool( "isLogin" , setting.isLogin );
    pref.setBool("popUpEnable", setting.enablePopup);
    pref.setBool("imageDisable", setting.disableImage);

  }

  FToast fToast=FToast();
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState

    if(context.mounted){
      super.setState(fn);
    }

  }
  @override
  void initState() {
    //dropValue=Provider.of<modelprovider>(context).applocal==Locale("ar")? language[0] : language[1];
    // TODO: implement initState
    fToast.init(context);
    signalRContext=context;
    super.initState();
  }
  bool x=false;
  int exitCount=0;
  List<String> language=[
  "العربية",
    "English"
  ];
  String dropValue="";
  @override
  Widget build(BuildContext context) {
    var lang= AppLocalizations.of(context);//Applocalizations
   var changeLanguage= Provider.of<modelprovider>(context,listen: false);
    //dropValue=changeLanguage.applocal==Locale("ar")? language[0] : language[1];
    return WillPopScope(
      onWillPop: ()async {
        exitCount ++;
        Timer(Duration(seconds: 2), () { // <-- Delay here
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
          pref.setString("dateOfBack", DateTime.now().toString());// save the token in preference
          return true;
        }


      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Main_Screen(index: 0,setIndex: true,)), (route) => false);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title:  Text(lang!.more,style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 25.sp),),
          //automaticallyImplyLeading:false,
        ),
        body: Card(
          child: Consumer<menuProviderOptions>(builder: (context,provider,child){
           //print("the value of note is ${ provider.note}");
            //dropValue=changeLanguage.applocal==Locale("ar")? language[0] : language[1];
            return ListView(
              children: [
                SwitchListTile(
                  title: Text(lang.popupEnable),
                  secondary:const  Icon(Icons.table_chart_outlined),
                  value:provider.enablePopup, onChanged: (val){
                  provider.changePopupData(val);
                 Save_data();
                },),
                SwitchListTile(
                  title:  Text(lang.disableImage),
                  secondary:const  Icon(Icons.image),
                  value:provider.disableImage , onChanged: (val){
                  provider.changeImageData(val);
                  Save_data();
                },),
                changeLanguage.permissionLoginForReturn.isShow !=null && changeLanguage.permissionLoginForReturn.isShow ==false ?
                    SizedBox():
                ListTile(
                  leading: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(lang.returnBtn,style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w200))),
                  trailing:Icon(Icons.repeat,size: 30,color: Colors.black54,),
                  onTap: (){
                    //Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);
                    showDialog(context: context, builder: (context)=> ReturnPOS());
                    //showDialog(context: context, builder: ()=> )
                  },
                ),
                ListTile(
                  leading: FittedBox(
                    fit: BoxFit.contain,
                      child: Text(lang.comment,style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w200))),
                  trailing:SizedBox(
                      width: 27.w,
                      height: 27.h,
                      child: Image.asset("images/menu.png",fit:BoxFit.fill,color: Colors.black54,)),
                  onTap: (){
                    //Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);
                    showDialog(context: context, builder: (context)=> CommentsPopUp());
                    //showDialog(context: context, builder: ()=> )
                  },
                ),
                ListTile(
                  leading: FittedBox(
                    fit: BoxFit.contain,
                      child: Text(lang.search,style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w200))),
                  trailing:Icon(Icons.search,size: 30,color: Colors.black54,),
                  onTap: (){
                    //Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);
                    showDialog(context: context, builder: (context)=> GetAllInvoicePopUp());
                    //showDialog(context: context, builder: ()=> )
                  },
                ),

                // ListTile(
                //   leading: FittedBox(
                //       fit: BoxFit.contain,
                //       child: Text("container",style: TextStyle(
                //           decoration: TextDecoration.underline,
                //           fontSize: 20.sp,fontWeight: FontWeight.w200))),
                //   trailing:Icon(Icons.factory,size: 30,color: Colors.black54,),
                //   onTap: (){
                //     //Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);
                //     showDialog(context: context, builder: (context)=> EmployeeBranchView());
                //     //showDialog(context: context, builder: ()=> )
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: provider.dropDownValue=="" ? language[0] : provider.dropDownValue,
                            icon: Visibility(
                              visible: false,
                              child: const Icon(
                                Icons.arrow_drop_down ,
                                size: 30,
                              ),
                            ),
                            items:language.map((items) {
                              return DropdownMenuItem<String>(
                                value: items,
                                child: Text(
                                  items,
                                  style:  TextStyle(
                                    fontSize: 20.sp,
                                      color: Colors.black54, ),
                                ),
                              );
                            }).toList(),
                            onChanged: (item) {
                             if(mounted){
                               setState(() {
                                 provider.changeDropDownValue(item!);
                                 changeLanguage.changeDropDown(item);
                               });
                             }
                            },
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                //context.read<modelprovider>().changedriction();
                ListTile(
                  leading: FittedBox(
                    fit: BoxFit.contain,
                      child: Text(lang.logOut,style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w200),)),
                  trailing:const Icon(Icons.logout_sharp,size: 30,color: Colors.black54,),
                  onTap: (){
                    //Navigator.of(context).pushNamedAndRemoveUntil(Arab_login.rout, (route) => false);

                    showDialog(context: context, builder: (context)=> WarningMassage(massage: lang.logoutMassage,index: -2,));


                  },
                ),


              ],
            );
          },)
        ),
      ),
    );
  }
}

