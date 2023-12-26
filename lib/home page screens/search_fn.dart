import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Data_search extends SearchDelegate{
  List<String> names=[
    "mohamed",
    "mahmoud",
    "ahmed",
    "abdel rahman",
    "syed"
  ];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(onPressed: (){
        query="";
      }, icon:const  Icon(Icons.close),),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon:const  Icon(Icons.arrow_back),);
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    List<String> matcing=[];
    for(var i in names){
      if(i.toLowerCase().contains(query.toLowerCase())){
        matcing.add(i);
      }
    }
    return ListView.builder(
        itemCount:matcing.length ,
        itemBuilder: (context,i){
          var result= matcing[i];
          return ListTile(
            title: Text(result,style:  TextStyle(fontWeight: FontWeight.bold ,fontSize: 20.sp),),
            leading:const  Icon(Icons.account_circle_rounded),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matcing=[];
    for(var i in names){
      if(i.toLowerCase().contains(query.toLowerCase())){
        matcing.add(i);
      }
    }

    return ListView.builder(
        itemCount:query =="" ? names.length : matcing.length,
        itemBuilder: (context,i){
          return InkWell(
            onTap: (){
              query = query =="" ? names[i] : matcing[i];
              showResults(context);
            },
            child: ListTile(
              title:query=="" ?  Text(names[i],
                style:  TextStyle(fontWeight: FontWeight.bold ,fontSize: 20.sp),)
                  : Text(matcing[i],style:  TextStyle(fontWeight: FontWeight.bold ,fontSize: 20.sp),),
              leading:const  Icon(Icons.account_circle_rounded),
            ),
          );
        });
  }

}




