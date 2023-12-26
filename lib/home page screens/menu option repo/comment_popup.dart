
 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../menu_provider.dart';

 class CommentsPopUp extends StatelessWidget {
   CommentsPopUp({super.key});

   ScrollController scrollController=ScrollController();
   TextEditingController commentController=TextEditingController();
   @override
   Widget build(BuildContext context) {
     commentController.text=Provider.of<menuProviderOptions>(context,listen: false).note;
     var lang=AppLocalizations.of(context);
     return AlertDialog(
       title: Center(
         child: Text(lang!.comment),
       ),
       content: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           Flexible(
             child: Scrollbar(
               controller: scrollController,
               trackVisibility: true,
               thumbVisibility: true,
               thickness: 7,
               child: Container(
                 height: 100.h,
                 width: double.infinity,
                 decoration: BoxDecoration(
                   border: Border.all(
                     color: Colors.lightBlue,
                   ),
                   borderRadius: BorderRadius.circular(5.r),
                 ),
                 child: Padding(
                   padding: const EdgeInsets.only(left: 4.0 ,right: 4.0),
                   child: TextFormField(
                     scrollController:scrollController ,
                     controller: commentController,
                     autofocus: true,
                     decoration: InputDecoration(
                       border: InputBorder.none,
                       isDense: true,
                     ),
                     keyboardType:  TextInputType.multiline,
                     maxLines: null,
                   ),
                 ),
               ),
             ),
           ),
         ],
       ),
       actions: [
         Row(
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
             Flexible(
               child: InkWell(
                 onTap: (){
                   var provider=Provider.of<menuProviderOptions>(context,listen: false);
                   provider.setNotes(commentController.text.toString());
                   Navigator.of(context).pop();
                 },
                 child: Container(
                   decoration: BoxDecoration(
                     color: Colors.greenAccent,
                     borderRadius: BorderRadius.circular(5.r),

                   ),
                   height: 40.h,
                   width: 100.w,
                   child:Center(child: FittedBox(
                       fit: BoxFit.contain,
                       child: Text(lang.save ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),))) ,

                 ),
               ),
             ),
           ],
         ),
       ],
     );
   }
 }

