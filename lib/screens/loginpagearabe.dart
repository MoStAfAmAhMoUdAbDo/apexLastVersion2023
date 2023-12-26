import 'package:apex/home%20page%20screens/main_screen.dart';
import 'package:apex/model.dart';
import 'package:apex/passwordtext.dart';
import 'package:apex/screens/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../api_directory/get_app_version.dart';
import '../api_directory/login_api.dart';
import '../home page screens/massage_toast.dart';
import '../home page screens/menu_provider.dart';
import '../home page screens/splashScreenTest.dart';
import '../models/login_data.dart';
import '../mytextfile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;


// i try to show some massage by it f
GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
void showSnack(String text) {
  if (_scaffoldKey.currentContext != null) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}



class Arab_login extends StatefulWidget {
  const Arab_login({Key? key}) : super(key: key);
  static const rout = '/login';

  @override
  State<Arab_login> createState() => _Arab_loginState();
}

class _Arab_loginState extends State<Arab_login> {
   bool remember =false;
  final formkey = GlobalKey<FormState>();
  final TextEditingController companytxt = TextEditingController();
  final TextEditingController usernametxt = TextEditingController();
  final TextEditingController passwordtxt = TextEditingController();
  bool lang = true;
  bool circale_load_flag = false;
  var size;
  var setting;
  FToast fToast = FToast();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //remember = false;
    fToast.init(context);

    //setState(() {
    printVersion();
      get_data();
    //});
    //print("the remember me is${remember}" );
  }


  Save_data(bool rememberMe, String companyName, String userName) async {
    //var setting=Provider.of<menuProviderOptions>(context);
    //setting=Provider.of<menuProviderOptions>(context,listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("remember_me", rememberMe);
    pref.setString("company_name", companyName);
    pref.setString("user_name", userName);
    get_data();
  }

  get_data() async {
    setting=Provider.of<menuProviderOptions>(context,listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var re = pref.getBool("remember_me") ==null ? false : pref.getBool("remember_me");
    //print("the re in sharedpref $re");
    companytxt.text = pref.getString("company_name") ==null ? "" : pref.getString("company_name")!;
    if (re == true) {
      remember = true;
      if(pref.getString("user_name")!=null){
        usernametxt.text = pref.getString("user_name")!;
      }
      setState(() {

      });
      setting.changePopupData(pref.getBool("popUpEnable")==null ?false :pref.getBool("popUpEnable"));
      setting.changeImageData(pref.getBool("imageDisable")== null ? false : pref.getBool("imageDisable")) ;

    }
  }

  setsize(bool language) {
    if (language) {
      size = 100.0.w;
    } else {
      size = 0.0.w;
    }
    // return size;
  }

   Future<String> getCurrentAppVersion() async {
     PackageInfo packageInfo = await PackageInfo.fromPlatform();
     return packageInfo.version;
   }

   void printVersion() async {
     String currentVersion = await getCurrentAppVersion();
     AppVersionInfo appVersionInfo =await GetAppNewVersion().checkForAppNewVersion();
     //print('Current App Version: $currentVersion');
     int appVersion= int.parse(currentVersion.replaceAll('.', ''));
     int newVersion=appVersionInfo.VersionNumber != null ? int.parse(appVersionInfo.VersionNumber!.replaceAll('.', '')) :appVersion;
     //int testversion=222;
     String url="";
     if(newVersion > appVersion){
       if(Platform.isAndroid){
         //print("the platform is android ");
         url=appVersionInfo.PlayStoreUrl!;
       }
       else if (Platform.isIOS){
         //print("the platform is ios");
         url=appVersionInfo.AppStoreUrl!;
       }
       showDialog(
           barrierDismissible: false,
           context: context,
           // ignore: deprecated_member_use
           builder:(_) => WillPopScope(
               onWillPop: ()async {return false;  },
               child: UpdateDialog(appLink:url ,newVersion:appVersionInfo.VersionNumber! , oldVersion:currentVersion ,)));
       // print("version 1 is bigger than 2");

     }
   }


   @override
  Widget build(BuildContext context) {
    setsize(lang);
    return Scaffold(
      backgroundColor: Color(0x0ffffffff),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
             Image.asset(
              "images/apex ERP-6.png",
              fit: BoxFit.fill,
            ),
            ElevatedButton(
              onPressed: () {
                  context.read<modelprovider>().changedriction();
                  lang = !lang;
                  formkey.currentState!.reset();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r)),
                    fixedSize:Size(100.w, 110.h) , //Size.fromWidth(110.w),

                  backgroundColor: Colors.white,
              ),
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(
                    AppLocalizations.of(context)!.english,
                    style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
              ),
            ),
                    ],
                  ),
                ),

                Center(
                  child: Container(
                    padding:  EdgeInsets.only(top: 10.h),
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 25, bottom: 20),
                        child: Text(AppLocalizations.of(context)!.companyname),
                      ),
                      MyTextForm(
                          hint: AppLocalizations.of(context)!.companyname,
                          excep: AppLocalizations.of(context)!.companyname,
                          control: companytxt),
                      Container(
                        padding: const EdgeInsets.only(top: 25, bottom: 20),
                        child: Text(AppLocalizations.of(context)!.username),
                      ),
                      MyTextForm(
                        hint: AppLocalizations.of(context)!.username,
                        excep: AppLocalizations.of(context)!.username,
                        control: usernametxt,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 25, bottom: 20),
                        child: Text(AppLocalizations.of(context)!.password),
                      ),
                      PasswordText(
                          hint: AppLocalizations.of(context)!.password,
                          obsecur: true,
                          control: passwordtxt),
                      SizedBox(
                        height: 50.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(AppLocalizations.of(context)!.rememberme),
                              Checkbox(
                                  value: remember,
                                  onChanged: (val) {
                                    setState(() {
                                      remember = val!;
                                    });
                                  }),
                            ],
                          ),
                          // SizedBox(
                          //   width:Provider.of<modelprovider>(context).applocal==Locale("ar") ?size : size-3,
                          // ),
                          InkWell(
                            child: Text(
                              AppLocalizations.of(context)!.forgetpassword,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                            onTap: () {
                              formkey.currentState!.reset();
                              Navigator.pushNamed(
                                  context, Forget_Password.rout);
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding:  EdgeInsets.only(top: 10.h),
                        width: double.infinity,
                        height: 60.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            var language = AppLocalizations.of(context);
                            var itemLang = Provider.of<modelprovider>(context,
                                    listen: false)
                                .applocal;
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                circale_load_flag = true;
                              });
                              var res = await loginapi().logincheck(
                                  usernametxt.text.toString(),
                                  passwordtxt.text.toString(),
                                  companytxt.text.toString());
                              Navigator.of(context).pop();
                              if (res.result == 1) {
                                Provider.of<modelprovider>(context,listen: false).permissionLoginForReturn=res.permissionLogin[1];
                                if(res.permissionLogin[0].isShow !=null && res.permissionLogin[0].isShow == true ){
                                  circale_load_flag = false;
                                  setState(() {});
                                  await Save_data(
                                      remember,
                                      companytxt.text.toString(),
                                      usernametxt.text.toString());
                                  //massageForAlert(language.checkInternet,false);
                                  Navigator.pushReplacementNamed(
                                      context, Main_Screen.rout);
                                }
                                else if(res.permissionLogin[0].isShow != null && res.permissionLogin[0].isShow == false){
                                  MassageForToast().massageForAlert(language!.noPermission, false,fToast);
                                }


                              }
                              else if (res.errorMassageAr != null ||
                                  res.errorMassageEn != null) {
                                circale_load_flag = false;
                                setState(() {});
                                // print("else if is running ");
                                String massage = itemLang == Locale('en')
                                    ? res.errorMassageEn!
                                    : res.errorMassageAr!;
                                MassageForToast().massageForAlert(massage, false,fToast);
                              }
                              else {
                                circale_load_flag = false;
                                setState(() {});
                                if (res.socketError == "internet check") {
                                  MassageForToast().massageForAlert(
                                      language!.checkInternet, false,fToast);
                                } else {
                                  MassageForToast().massageForAlert(
                                      language!.errorOccurredServer, false,fToast);
                                }
                              }
                            }
                            else{
                              Navigator.of(context).pop();
                            }
                          },
                          //style: ElevatedButton.styleFrom(),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child:
                            // circale_load_flag
                            //     ? const CircularProgressIndicator(
                            //   color: Colors.white,
                            // )
                            //     :
                            Text(
                              AppLocalizations.of(context)!.login,
                              style: TextStyle(
                                    fontSize: 25.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding:  EdgeInsets.only(top: 25.h),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.account),
                            InkWell(
                              child: Text(
                                '${AppLocalizations.of(context)?.createaccounte}?',
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    usernametxt.dispose();
  }
}
