import 'package:apex/api_directory/get_financial_drop_down.dart';
import 'package:apex/api_directory/get_salesman_dropdown.dart';
import 'package:apex/home%20page%20screens/add_user/dialog_for_more_tabe.dart';
import 'package:apex/model.dart';
import 'package:apex/models/get_financial_account_model.dart';
import 'package:apex/models/salesman_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../api_directory/get_all_branches_drop_down.dart';
import '../../api_directory/get_financial_setting.dart';
import '../../models/branch_model.dart';
import '../../models/employee_type.dart';
import '../../models/login_data.dart';
import 'financial_data_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
List<EmployeeType> employeeType=[];
List<EmployeeBranch>  employeeBranch=[];
List<SalesManModel>  salesmanDropDown=[];
List<GetFinancialAccountDropDownModel> getFinancialDropDown=[];
LoginData salesManData=LoginData();
LoginData financialTextCheck=LoginData();
LoginData financialAccount=LoginData();
LoginData branchDataDropDown=LoginData();
class ClientDataView extends StatefulWidget {
  final GlobalKey<FormState> globalKey;
  //LoginData res = LoginData();
  ClientDataView({super.key,required this.globalKey});

  @override
  State<ClientDataView> createState() => _ClientDataViewState();
}

class _ClientDataViewState extends State<ClientDataView> {
  TextEditingController arabicClintController = TextEditingController();
  TextEditingController latinClintController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  TextEditingController salesManController = TextEditingController();
  TextEditingController customerTypeController =TextEditingController();
  TextEditingController branchController=TextEditingController();
  TextEditingController financialAccountController=TextEditingController();
  ScrollController customerScroll=ScrollController();
  ScrollController salesmanScroll=ScrollController();
  ScrollController branchScroll=ScrollController();
  ScrollController financialAccountScroll=ScrollController();
  //List<EmployeeType> employeeType=[];
  late OverlayEntry overlayEntry;
  final LayerLink customerTypeLink = LayerLink();
  final LayerLink branchLink = LayerLink();
  final LayerLink salesManLink=LayerLink();
  final LayerLink financialAccountLink=LayerLink();
  FocusNode customerTypeFocus=FocusNode();
  FocusNode branchFocus=FocusNode();
  FocusNode salesManFocus =FocusNode();
  FocusNode financialAccountFocus=FocusNode();
  bool radioValue=true;
  FocusNode arabicClientFocusNode=FocusNode();
  bool didChange=false;
  //LoginData branchDataDropDown=LoginData();
  int pageSize=10;
  int pageNumberForSalesman=1;
  int pageNumberForFinancialAccount=1;

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>FocusScope.of(context).requestFocus(arabicClientFocusNode));
    getAllBranchesAndSalesMan();
    focusListener(customerTypeFocus,customerTypeLink , 1);// the number 1 mean the focus come from the customer type text
    focusListener(branchFocus ,branchLink ,2);//the number 2 mean the focus come from the branch text
    focusListener(salesManFocus ,salesManLink,3 );//the number 3 mean the focus come from the salesMan text
    focusListener(financialAccountFocus, financialAccountLink, 4);//the number 4 mean the focus come from the financial Account text
    salesmanScroll.addListener(salesManScrollListener);
    financialAccountScroll.addListener(financialAccountScrollListener);
  }
  Future<void> financialAccountScrollListener() async {
    if (financialAccountScroll.position.pixels ==
        financialAccountScroll.position.maxScrollExtent
        )
    {
      pageNumberForFinancialAccount++;
      financialAccount=await GetFinancialDropDown().getFinancialDropDown(pageSize, pageNumberForFinancialAccount);
      if(financialAccount.result==1 && financialAccount.financialDropDown !=null && financialAccount.financialDropDown!.isNotEmpty){
        getFinancialDropDown.addAll(financialAccount.financialDropDown!);
        overlayEntry.markNeedsBuild();
      }
    }
  }
  Future<void> salesManScrollListener() async {
    if (salesmanScroll.position.pixels ==
        salesmanScroll.position.maxScrollExtent &&
        salesmanDropDown.length >= pageSize) {
      pageNumberForSalesman++;
      salesManData=await GetSalesManDropDown().getSalesManDropDown(pageSize, pageNumberForSalesman);
      if(salesManData.result==1 && salesManData.salesMan !=null && salesManData.salesMan!.isNotEmpty){
        salesmanDropDown.addAll(salesManData.salesMan!);
        overlayEntry.markNeedsBuild();
      }
    }
  }
  void getAllBranchesAndSalesMan()async{
    if(employeeType.isEmpty && employeeBranch.isEmpty && salesmanDropDown.isEmpty){
      //financialTextCheck=await GetFinancialSettingApi().getFinancialSettingApi();
      //print("the financial linkid is ${financialTextCheck.financialSettingModel!.linkingMethodId}");
      if(financialTextCheck.result==1 && financialTextCheck.financialSettingModel!.linkingMethodId==1 &&getFinancialDropDown.isNotEmpty){
        //financialAccount = await GetFinancialDropDown().getFinancialDropDown(pageSize, pageNumberForFinancialAccount);
        getFinancialDropDown=financialAccount.financialDropDown!;
      }
      //branchDataDropDown=await GetAllBranchesDropDown().getAllBranchesDropDown();
      //salesManData=await GetSalesManDropDown().getSalesManDropDown(pageSize, pageNumberForSalesman);
      salesmanDropDown=salesManData.salesMan!;
      employeeBranch = branchDataDropDown.employeeBranch!;
      arabicClintController.text=customerDataProvider.customerDataModel.arabicCustomerName;
      latinClintController.text=customerDataProvider.customerDataModel.latinCustomerName;
      taxNumberController.text=customerDataProvider.customerDataModel.taxNumber;
      if(mounted){
        setState(() {
        });
      }
    }

  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(didChange==false){
      didChange=true;
      var lang=AppLocalizations.of(context);
      // TODO: implement initState
      employeeType.add(EmployeeType(id: 1 ,emType: lang!.normal ));
      employeeType.add(EmployeeType(id: 2 ,emType: lang.sectoral ));
      employeeType.add(EmployeeType(id: 3 ,emType: lang.wholesale ));
      employeeType.add(EmployeeType(id: 4 ,emType: lang.halfWholesale ));
    }

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context);
    var langType=Provider.of<modelprovider>(context,listen: false).applocal;
    if(branchDataDropDown.result == 1 && branchDataDropDown.employeeBranch !=null ){
        if(salesManController.text.isEmpty){
          salesManController.text= langType ==Locale("ar") ?salesmanDropDown[0].arabicName! :salesmanDropDown[0].arabicName!;
          customerDataProvider.customerDataModel.salesMan=salesmanDropDown[0];
        }
        String massage="";
        if(branchController.text.isEmpty){
          for(var i in branchDataDropDown.employeeBranch!){
            if(i.status==1){
              massage=langType==Locale("ar") ?i.arabicName! : i.latinName!;
              branchController.text += "$massage,";
              customerDataProvider.customerDataModel.branch.add(i.branchId!);
            }
          }
        }
        if(customerTypeController.text.isEmpty){
          customerTypeController.text=employeeType[0].emType!;
          customerDataProvider.customerDataModel.customerType=employeeType[0];
        }
      return Form(
        key:widget.globalKey,
        child: RawScrollbar(
          controller: customerScroll,
          thumbVisibility: true,
          trackVisibility: true,
          radius: Radius.circular(4),
          thumbColor: Colors.grey,
          child: ListView(
            controller: customerScroll,
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 5.h,
              ),
              TextFormField(
                controller: arabicClintController,
                focusNode:arabicClientFocusNode,
                decoration: textDecoration(lang!.arabicCustomerName, true),
                autofocus: true,
                onChanged: (ch) {
                  customerDataProvider.customerDataModel.arabicCustomerName = ch;
                },
                validator: (val){
                  if(val!.isEmpty || val == null) {
                    return lang.pleaseFillText;
                  }
                  else{
                    return null ;
                  }
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              TextFormField(
                controller: latinClintController,
                decoration: textDecoration(lang.englishCustomerName),
                onChanged: (ch) {
                  customerDataProvider.customerDataModel.latinCustomerName = ch;
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              TextFormField(
                //controller: arabicClintController,
                focusNode: customerTypeFocus,
                controller: customerTypeController,
                decoration: textDecoration(lang.customerType, true ,true),
                onChanged: (ch) {
                  //customerDataProvider.customerDataModel.customerType = ch;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val){
                  if(val!.isEmpty || val == null) {
                    return lang.pleaseFillText;
                  }
                  else{
                    return null ;
                  }
                },
              ),
              CompositedTransformTarget(//CompositedTransformTarget
                link: customerTypeLink,
                child: SizedBox(
                  height: 8.h,
                ),
              ),
              TextFormField(
                controller: branchController,
                focusNode: branchFocus,
                decoration: textDecoration(lang.branch, true,true),
                onChanged: (ch) {
                  //customerDataProvider.customerDataModel.branch = ch;
                },
                validator: (val){
                  if(val!.isEmpty || val == null) {
                    return lang.pleaseFillText;
                  }
                  else{
                    return null ;
                  }
                },
              ),
              CompositedTransformTarget(
                link: branchLink,
                child: SizedBox(
                  height: 8.h,
                ),
              ),
              Text(lang.customerStatus,style: TextStyle(
                fontSize: 16.sp,
              ),),
              // SizedBox(
              //   height: 3.h,
              // ),
              StatefulBuilder(
                builder: (BuildContext context, myState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(value: true, groupValue: radioValue, onChanged: (ch){
                        if(mounted){
                          myState((){
                            radioValue = ch!;
                            customerDataProvider.customerDataModel.customerStatus= 1;
                          });
                        }
                      }),
                      Text(lang.active),
                      SizedBox(width: 5.w,),
                      Radio(value: false, groupValue: radioValue, onChanged: (ch){
                        if(mounted){
                          myState((){
                            radioValue = ch!;
                            customerDataProvider.customerDataModel.customerStatus= 2;
                          });
                        }
                      }),
                      Text(lang.inactive),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              TextFormField(
                controller: taxNumberController,
                decoration: textDecoration(lang.taxNumber, false),
                onChanged: (ch) {
                  customerDataProvider.customerDataModel.taxNumber = ch;
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              CompositedTransformTarget(
                link: salesManLink,
                child: TextFormField(
                  controller: salesManController,
                  focusNode: salesManFocus,
                  decoration: textDecoration(lang.salesMan, true,true),
                  onChanged: (ch) {
                    //customerDataProvider.customerDataModel.salesMan = ch;
                  },
                  validator: (val){
                    if(val!.isEmpty || val == null) {
                      return lang.pleaseFillText;
                    }
                    else{
                      return null ;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              CompositedTransformTarget(
                link: financialAccountLink,
                child: TextFormField(
                  focusNode: financialAccountFocus,
                  controller: financialAccountController,
                  enabled:financialTextCheck.result==1 && financialTextCheck.financialSettingModel!.linkingMethodId==1? true :false,
                  decoration: textDecoration(lang.financialAccount, true ,true),
                  onChanged: (ch) {
                    //customerDataProvider.customerDataModel.customerType = ch;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator:financialTextCheck.result==1 && financialTextCheck.financialSettingModel!.linkingMethodId==1?  (val){
                    if(val!.isEmpty || val == null ) {
                      return lang.pleaseFillText;
                    }
                    else{
                      return null ;
                    }
                  } : null,
                ),
              ),
            ],
          ),
        ),
      );
    }
   else{
     return Center(child: CircularProgressIndicator());
    }//CircularProgressIndicator();
  }

  void focusListener(FocusNode focusNode , LayerLink textLink,int textFocus) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        overlayEntry = createDropdownDesign(setState ,textLink,textFocus);
        Overlay.of(context).insert(overlayEntry);
        //overlayEntry.remove();
      } else {
        overlayEntry.remove();
      }
    });
  }


  OverlayEntry createDropdownDesign(Function(void Function()) myBasicState ,LayerLink textFieldLink ,int textFocus){
    return OverlayEntry(builder: (context){
      return Positioned(
        // height: MediaQuery.sizeOf(context).height/7,
        width: MediaQuery.of(context).size.width/1.56,
        top: 250.h,
        //left: 67.w,
        child:
        CompositedTransformFollower(
          link: textFieldLink,
          showWhenUnlinked: false,
          //offset: Offset(0.0,  5.0),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: focusTextDropDown(myBasicState,textFocus),
          ),
        ),

      );
    });
  }
  Widget focusTextDropDown(Function(void Function()) myBasicState ,int textFocus ){
    if(textFocus == 1){
      return customerTypeDesignList(myBasicState);
    }
    else if( textFocus==2){
      return branchDropDownDesign(myBasicState);
    }
    else if(textFocus==3){
      return salesManDropDownDesign(myBasicState);
    }
    else{
      return financialAccountDropDownDesign(myBasicState);
    }
  }

  Widget customerTypeDesignList(Function(void Function()) myBasicState) {
   // var provider = Provider.of<Cart_Items>(context, listen: false);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height / 4.5,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.grey,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child:ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
        itemCount: employeeType.length,
          itemBuilder: (context,index){
          return Card(//Card(
            margin:const EdgeInsets.all(0.3),
            child: ListTile(
              onTap: () {
                if(mounted){
                  customerTypeFocus.unfocus();
                  customerTypeController.text=employeeType[index].emType!;
                  customerDataProvider.customerDataModel.customerType =employeeType[index];
                }
              },
              dense: true,
              visualDensity: VisualDensity(vertical: -1),
              title: Text(employeeType[index].emType!,style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp
              ),),
            ),
          );
          }
      )
    );
  }
  Widget branchDropDownDesign(Function(void Function()) myBasicState) {
    // var provider = Provider.of<Cart_Items>(context, listen: false);
    return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height / 4.5,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.grey,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child:RawScrollbar(
          controller: branchScroll,
          radius: Radius.circular(4),
          thumbColor: Colors.black,
          thumbVisibility: true,
          child: StatefulBuilder(
            builder: ( context,  myState) {
              return ListView.builder(
                  controller: branchScroll,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: employeeBranch.length,
                  itemBuilder: (context,index){
                    String branchName=Provider.of<modelprovider>(context,listen: false).applocal==Locale("ar") ?
                    employeeBranch[index].arabicName! :employeeBranch[index].latinName!;
                    return Card(//Card(
                      margin:const EdgeInsets.all(0.3),
                      child: ListTile(
                        onTap: () {
                          if(mounted){
                            //branchFocus.unfocus();
                            employeeBranch[index].status = employeeBranch[index].status.isOdd ? 0 : 1;
                            if(employeeBranch[index].status==1){
                              branchController.text +="$branchName,";
                              customerDataProvider.customerDataModel.branch.add(employeeBranch[index].branchId!);
                            }
                            else{
                              List<String> newString= branchController.text.split("$branchName,");
                              branchController.text=newString.join("");
                              customerDataProvider.customerDataModel.branch.remove(employeeBranch[index].branchId);
                            }
                            overlayEntry.markNeedsBuild();
                          }
                        },
                        dense: true,
                        visualDensity: VisualDensity(vertical: -1),
                        title: Text(branchName,style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp
                        ),),
                        trailing: Checkbox(
                            value:employeeBranch[index].status.isOdd , onChanged: (ch){
                              print("the ch is$ch" );
                              employeeBranch[index].status=employeeBranch[index].status.isOdd ? 0 : 1;
                              if(employeeBranch[index].status==1){
                                branchController.text +="$branchName,";
                                customerDataProvider.customerDataModel.branch.add(employeeBranch[index].branchId!);
                              }
                              else{
                                List<String> newString= branchController.text.split("$branchName,");
                                branchController.text=newString.join("");
                                customerDataProvider.customerDataModel.branch.remove(employeeBranch[index].branchId);
                              }
                          myState((){
                          });
                             // overlayEntry.markNeedsBuild();
                        }),
                      ),
                    );
                  }
              );
            },
          ),
        )
    );
  }
  Widget salesManDropDownDesign(Function(void Function()) myBasicState) {
    // var provider = Provider.of<Cart_Items>(context, listen: false);
    return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height / 4.5,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.grey,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child:RawScrollbar(
          controller: salesmanScroll,
          radius: Radius.circular(4),
          thumbColor: Colors.black,
          thumbVisibility: true,
          child: ListView.builder(
              controller: salesmanScroll,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: salesmanDropDown.length,
              itemBuilder: (context,index){
                String salesManName=Provider.of<modelprovider>(context,listen: false).applocal==Locale("ar") ?
                salesmanDropDown[index].arabicName! :salesmanDropDown[index].latinName!;
                return Card(
                  margin:const EdgeInsets.all(0.3),
                  child: ListTile(
                    onTap: () {
                      if(mounted){
                        salesManFocus.unfocus();
                        salesManController.text =salesManName;
                        customerDataProvider.customerDataModel.salesMan=salesmanDropDown[index];
                      }
                    },
                    dense: true,
                    visualDensity: VisualDensity(vertical: -1),
                    title: Text(salesManName,style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp
                    ),),
                  ),
                );
              }
          ),
        )
    );
  }

  Widget financialAccountDropDownDesign(Function(void Function()) myBasicState) {
    // var provider = Provider.of<Cart_Items>(context, listen: false);
    return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height / 4.5,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.grey,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child:RawScrollbar(
          controller: financialAccountScroll,
          radius: Radius.circular(4),
          thumbColor: Colors.black,
          thumbVisibility: true,
          child: ListView.builder(
              controller: financialAccountScroll,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: getFinancialDropDown.length,
              itemBuilder: (context,index){
                String financial=Provider.of<modelprovider>(context,listen: false).applocal==Locale("ar") ?
                getFinancialDropDown[index].arabicName! : getFinancialDropDown[index].latinName!;
                if(index <getFinancialDropDown.length){
                  return Card(
                    margin:const EdgeInsets.all(0.3),
                    child: ListTile(
                      onTap: () {
                        if(mounted){
                          financialAccountFocus.unfocus();
                          financialAccountController.text =financial;
                          customerDataProvider.customerDataModel.financialAccountDropDownModel= getFinancialDropDown[index];
                        }
                      },
                      dense: true,
                      visualDensity: VisualDensity(vertical: -1),
                      title: Text(financial,style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp
                      ),),
                    ),
                  );
                }
                else{
                  overlayEntry.markNeedsBuild();
                  return Center(child: CircularProgressIndicator(),);
                }
              }
          ),
        )
    );
  }
}
