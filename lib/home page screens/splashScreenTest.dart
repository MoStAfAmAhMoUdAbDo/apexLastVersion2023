
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api_directory/login_api.dart';
import '../costants/color.dart';
import '../screens/loginpagearabe.dart';
import 'main_screen.dart';
import 'menu_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool isLogin = false;
  String versionNumberOfApp="";
  Future<String> getCurrentAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
  get_data() async {
    versionNumberOfApp = await getCurrentAppVersion();
    var setting=Provider.of<menuProviderOptions>(context,listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setting.changePopupData(pref.getBool("popUpEnable") == null ? false :pref.getBool("popUpEnable")!);
    setting.changeImageData(pref.getBool("imageDisable")== null ? false : pref.getBool("imageDisable")!) ;
    String dateBack= pref.getString("dateOfBack") == null ? DateTime.now().toString(): pref.getString("dateOfBack")!;// check on the date and the differncee make the user to go the login page agin but still in test
    bool flagPref= pref.getBool("isLogin")==null ? false :pref.getBool("isLogin")!;// check on the date and the differncee make the user to go the login page agin but still in test
    var differenceDate= DateTime.now().difference(DateTime.parse(dateBack));

    //print("is login in splash screen is $flagPref");// check on the date and the differncee make the user to go the login page agin but still in test
    if(flagPref==true){
      if(differenceDate.inMinutes <= 10){
        isLogin=true;
        loginapi.token=pref.getString("token") == null ? "" : pref.getString("token")!;
      }
      else{
        isLogin=false;
      }
      //print("the login token is ${loginapi.token} ");
      setState(() {

      });
    }
  }


  @override
  void initState() {
    //super.initState();
    // Add a delay before navigating to the main screen

    get_data();
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>isLogin==false ?  const Arab_login() : Main_Screen()
        ),
      );
    });


  }
  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //UpgradeAlert(
    // upgrader: Upgrader(
    //   showIgnore: false,
    //   showLater: false,
    //   canDismissDialog: false,
    //   showReleaseNotes: false,
    //   dialogStyle: Platform.isAndroid ? UpgradeDialogStyle.material :UpgradeDialogStyle.cupertino,
    // ),
    //child: Scaffold());

    return Scaffold(
      backgroundColor: Color(0x0ffffffff),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/apex ERP-6.png",fit: BoxFit.fill,),
            SizedBox(height: 16.h,width: double.infinity,),
            Text(
              'version 1.0.2',
              //versionNumberOfApp,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            // Text(
            //   'My Awesome App',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class UpdateDialog extends StatelessWidget {
  String? appLink;
  String? oldVersion;
  String? newVersion;
   UpdateDialog({super.key ,this.appLink , this.newVersion,this.oldVersion});

  @override
  Widget build(BuildContext context) {
    var lang =AppLocalizations.of(context);
    return AlertDialog(
          title: Text(lang!.appUpdate,style: TextStyle(
              fontSize: 21.sp,
              color: Colors.black,
            fontWeight: FontWeight.bold
          ),),
      content: Text("${lang.updateMassageFirst} ${newVersion} ${lang.updateMassageSecond} ${oldVersion}",style:TextStyle(
          fontSize: 18.sp,
          color: Colors.black
      ) ,),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                openLink(Uri.parse(appLink!));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r), color: basicColor),
                height: 40.h,
                width: 100.w,
                child: Center(
                  child: Text(lang.update,style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white
                  ),),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


Future<void> openLink(Uri url) async {
  if (!await launchUrl(url ,mode: LaunchMode.platformDefault)) {
    print('uld not launch $url');
  }
}