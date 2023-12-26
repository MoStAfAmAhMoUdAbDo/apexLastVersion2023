
import 'package:flutter/material.dart';

import 'navigation_bar.dart';
class Main_Screen extends StatefulWidget {
  int? index;
  bool? setIndex=false;
   Main_Screen({Key? key,this.index ,this.setIndex}) : super(key: key);
  static const rout ='/main_test';
  @override
  State<Main_Screen> createState() => _Main_ScreenState();
}

class _Main_ScreenState extends State<Main_Screen> {

  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(context.mounted){
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
   // print("the index in main screen is ${widget.index}");
    return widget.index==null ?   Navigation_bar() :Navigation_bar(setIndex: widget.setIndex,index: widget.index,);

    //Persistent_nav_Bar();
  }
}
