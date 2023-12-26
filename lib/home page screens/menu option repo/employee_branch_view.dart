import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EmployeeBranchView extends StatelessWidget {
  const EmployeeBranchView({super.key});


  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    return     AlertDialog(
        title: Center(
          child: FittedBox(
            fit: BoxFit.fill,
            child: Text(lang!.search,
                style: TextStyle(
                    fontSize: 30.sp, fontWeight: FontWeight.w200)),
          ),
        ),
        content:Container() //contentInvoicePopup(),
    );
  }
}
