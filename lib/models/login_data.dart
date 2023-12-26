

import 'package:apex/models/peermission.dart';
import 'package:apex/models/salesman_model.dart';

import 'branch_model.dart';
import 'financial_setting_model.dart';
import 'get_financial_account_model.dart';
import 'items.dart';

class LoginData{
  int? result;
  String? errorMassageAr;
  String? errorMassageEn;
  String? socketError;
  Item? item;
  int? resultForPrint;
  bool? isPrint;
  String? fileUrl;
  int? statusCode;
  List <PermissionLogin> permissionLogin =[];
  List<EmployeeBranch>?  employeeBranch;
  List<SalesManModel>? salesMan;
  FinancialSettingModel? financialSettingModel;
  List<GetFinancialAccountDropDownModel>? financialDropDown;
  LoginData([this.result=0,this.errorMassageAr,this.errorMassageEn ,this.socketError ,
    this.item,this.resultForPrint,this.isPrint,this.fileUrl,this.statusCode,
    this.employeeBranch,this.salesMan,this.financialSettingModel,this.financialDropDown]);
}


class AppVersionInfo{
  String? AppStoreUrl;
  String? PlayStoreUrl;
  String? VersionNumber;
  int? result;
  String? errorMassageAr;
  String? errorMassageEn;
  String? socketError;
  AppVersionInfo({this.AppStoreUrl,this.PlayStoreUrl,this.VersionNumber});
}