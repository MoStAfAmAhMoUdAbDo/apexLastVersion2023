import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Draft_Screen extends StatelessWidget {
  const Draft_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lang =AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang!.draft.toString(),
          style:const  TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {},
          icon:const  Icon(Icons.menu),
        ),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           const  Icon(Icons.description_sharp ,size: 100,color: Colors.indigo,),
            Text(lang.nodraft.toString(),style:const  TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
            Text(lang.draftnosle.toString() ,style:const  TextStyle(fontSize: 20 ,color: Colors.grey),)
          ],
        ),
      ),
    );
  }
}
