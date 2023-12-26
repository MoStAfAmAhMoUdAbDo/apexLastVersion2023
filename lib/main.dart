

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:apex/screens/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_directory/login_api.dart';
import 'home page screens/add_user/customer_data_provider.dart';
import 'home page screens/cart_items.dart';
import 'home page screens/cart_screen.dart';
import 'home page screens/payment_option/confirmation_payment.dart';
import 'home page screens/home_screenpage.dart';
import 'home page screens/main_screen.dart';
import 'home page screens/menu_provider.dart';
//import 'home page screens/persistent_bar.dart';
import 'home page screens/qr_scanner.dart';
import 'home page screens/signalRProvider.dart';
import 'home page screens/splashScreenTest.dart';
import 'screens/loginpagearabe.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:upgrader/upgrader.dart';
void main() async{
  //HttpOverrides.global = MyHttpOverrides();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Upgrader.clearSavedSettings();
  ErrorWidget.builder=(FlutterErrorDetails details)
  {
    bool isDebug=false;
    assert((){
      isDebug =true;
      return true;
    }());
    if(isDebug){
      return ErrorWidget(details.exception);
    }
    return Container(
      alignment: Alignment.center,
      child: Text("Error \n ${details.exception}",style: TextStyle(
        color:  Colors.orangeAccent,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
        textAlign: TextAlign.center,
      ),

    );
  };
  runApp(const HOmePage());
}

class SplashAnimated extends StatefulWidget {

  const SplashAnimated({Key? key}) : super(key: key);

  @override
  State<SplashAnimated> createState() => _SplashAnimatedState();
}

class _SplashAnimatedState extends State<SplashAnimated> {
  bool isLogin = false;
  get_data() async {
   var setting=Provider.of<menuProviderOptions>(context,listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
      setting.changePopupData(pref.getBool("popUpEnable") == null ? false :pref.getBool("popUpEnable")!);
      setting.changeImageData(pref.getBool("imageDisable")== null ? false : pref.getBool("imageDisable")!) ;
      String dateBack= pref.getString("dateOfBack") == null ? DateTime.now().toString(): pref.getString("dateOfBack")!;// check on the date and the differncee make the user to go the login page agin but still in test
      bool flagPref= pref.getBool("isLogin")==null ? false :pref.getBool("isLogin")!;// check on the date and the differncee make the user to go the login page agin but still in test
      var differenceDate= DateTime.now().difference(DateTime.parse(dateBack));

      print("is login in splash screen is $flagPref");// check on the date and the differncee make the user to go the login page agin but still in test
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
    // TODO: implement initState
    get_data();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Icons.home,
      splashTransition: SplashTransition.rotationTransition,
      backgroundColor: Colors.blue,
      nextScreen:isLogin==false ?  const Arab_login() : Main_Screen(),
    );
  }
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context ,child) {
        return MaterialApp(
          builder: (context, child) => Overlay(
            initialEntries: [
              if (child != null) ...[
                OverlayEntry(
                  builder: (context) => child,
                ),
              ],
            ],
          ),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            //color for scrollbar
              highlightColor: Colors.grey
          ),
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('ar', ''),
          ],
          locale: context.watch<modelprovider>().applocal,
          routes: {
           // '/': (context) =>const SplashAnimated(),
            '/':(context)=> SplashScreen(),
            Arab_login.rout: (context) =>const Arab_login(),
            Forget_Password.rout: (context) =>const Forget_Password(),
            Qr_scanner.rout: (context) =>const Qr_scanner(),
            home_screen.rout: (context) =>const home_screen(),
            Main_Screen.rout: (context) => Main_Screen(),
            ConfirmPayment.rout : (context)=> const ConfirmPayment(),
            My_basket.root : (context)=> const My_basket()
          },
           navigatorKey:navigatorKey ,
           initialRoute: '/',
        );
      }
    );
  }
}

class HOmePage extends StatefulWidget {
  static bool isLogin=false;
  const HOmePage({Key? key}) : super(key: key);
  @override
  State<HOmePage> createState() => _HOmePageState();
}
class _HOmePageState extends State<HOmePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => modelprovider(),
      ),
      ChangeNotifierProvider(create: (context) => loginapi()),
      ChangeNotifierProvider(create: (context) => Cart_Items()),
      ChangeNotifierProvider(
        create: (context) => menuProviderOptions(),
      ),
      //ChangeNotifierProvider(create:(context)=> CustomerDataProvider() ),
      ChangeNotifierProvider(create: (context)=> SignalRService())
    ], child: MyApp());
  }
}
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }