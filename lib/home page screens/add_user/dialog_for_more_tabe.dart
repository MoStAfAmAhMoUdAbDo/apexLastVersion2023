import 'package:apex/home%20page%20screens/cart_items.dart';
import 'package:apex/model.dart';
import 'package:apex/models/login_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../api_directory/add_person_api.dart';
import '../../api_directory/get_all_branches_drop_down.dart';
import '../../api_directory/get_persons_dropdown_data.dart';
import '../../costants/color.dart';
import '../../models/add_person_model.dart';
import '../massage_toast.dart';
import 'clint_data_view.dart';
import 'contact_information.dart';
import 'customer_data_provider.dart';
import 'financial_data_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

CustomerDataProvider customerDataProvider =CustomerDataProvider();
AddPersonModel addPersonModel=AddPersonModel();
class PersonAddPopUp extends StatefulWidget {
  State<PersonAddPopUp> createState() => _PersonAddPopUpState();
}

class _PersonAddPopUpState extends State<PersonAddPopUp> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<FormState> _formKeyTab1 = GlobalKey<FormState>();
  //LoginData result=LoginData();

  FToast fToast =FToast();
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    //getAllBranches();
    // Provider.of<CustomerDataProvider>(context,listen: false).setFinancialModel();
    // Provider.of<CustomerDataProvider>(context,listen: false).setContactInformation();
    // Provider.of<CustomerDataProvider>(context,listen: false).setCustomerDataModel();
    fToast.init(context);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if(mounted){
        setState(() {
        });
      }
    });

  }

  @override
  void dispose() {
// TODO: implement dispose
     customerDataProvider =CustomerDataProvider();
     addPersonModel=AddPersonModel();
     //branchDataDropDown=LoginData();
    employeeType=[];
    employeeBranch=[];
    salesmanDropDown=[];
    getFinancialDropDown=[];
    super.dispose();
    tabController.removeListener(() { });
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // int currentIndex = tabController.index;
    // print("the current index is $currentIndex");
    var lang =AppLocalizations.of(context);
    return AlertDialog(
      title:TabBar(
         controller: tabController,
        labelStyle: TextStyle(fontSize: 15.sp),
        isScrollable: true,
        tabs: [
           Tab(
             text: lang!.clintData,
             icon: Icon(Icons.man),
           ),
           Tab(
             text: lang.contactInformation,
             icon: Icon(Icons.contact_page),
           ),
           Tab(
             text: lang.financialData,
             icon: Icon(Icons.contact_page),
           ),
        ],
       ) ,
      content: Container(
        constraints: BoxConstraints(
          maxHeight: 300.h
        ),
        child: Column(
          children: [
            Flexible(
              child: TabBarView(
                  controller: tabController,
                  children: [
                ClientDataView(globalKey: _formKeyTab1),
                ContactInformation(),
                FinancialData(),
                  ]),
            ),
          ],
        ),
      ),
      actions: [
        InkWell(
          onTap: ()async{
            //print(FinancialData().creditLimit.text);
            if(tabController.index==0 && _formKeyTab1.currentState!.validate()){
              addPersonModel.type=1;
              addPersonModel.salesPriceId=0;
              addPersonModel.isSupplier=false;
              addPersonModel.responsibleEn=customerDataProvider.contactInformationModel.latinResponsibleName;
              addPersonModel.responsibleAr=customerDataProvider.contactInformationModel.arabicResponsibleName;
              addPersonModel.lessSalesPriceId= 0;
              addPersonModel.financialAccountId=customerDataProvider.customerDataModel.financialAccountDropDownModel.id==null ?0:
                                                customerDataProvider.customerDataModel.financialAccountDropDownModel.id;
              addPersonModel.branches=customerDataProvider.customerDataModel.branch;
              addPersonModel.addToAnotherList=false;
              addPersonModel.addressEn=customerDataProvider.contactInformationModel.latinAddress;
              addPersonModel.addressAr=customerDataProvider.contactInformationModel.arabicAddress;
              addPersonModel.salesManId=customerDataProvider.customerDataModel.salesMan!.id;
              addPersonModel.creditLimit=customerDataProvider.financialModel.creditLimit;
              addPersonModel.creditPeriod=customerDataProvider.financialModel.creditPeriod;
              addPersonModel.discountRatio=customerDataProvider.financialModel.discountRatio;
              addPersonModel.phone=customerDataProvider.contactInformationModel.phone;
              addPersonModel.fax=customerDataProvider.contactInformationModel.fax;
              addPersonModel.email=customerDataProvider.contactInformationModel.email;
              addPersonModel.buildingNumber=customerDataProvider.contactInformationModel.buildingNumber;
              addPersonModel.streetName=customerDataProvider.contactInformationModel.streetName;
              addPersonModel.neighborhood=customerDataProvider.contactInformationModel.neighborhood;
              addPersonModel.city=customerDataProvider.contactInformationModel.city;
              addPersonModel.country=customerDataProvider.contactInformationModel.country;
              addPersonModel.postalNumber=customerDataProvider.contactInformationModel.postalNumber;
              addPersonModel.taxNumber=customerDataProvider.customerDataModel.taxNumber;
              addPersonModel.status=customerDataProvider.customerDataModel.customerStatus;
              addPersonModel.arabicName=customerDataProvider.customerDataModel.arabicCustomerName;
              addPersonModel.latinName=customerDataProvider.customerDataModel.latinCustomerName;
              if(Provider.of<Cart_Items>(context,listen: false).otherSettingData.other_ConfirmeCustomerPhone==true && addPersonModel.phone=="" && addPersonModel.phone!.length<7 ){
                fToast.init(context);
                MassageForToast().massageForAlert(lang.telephoneRequired,false,fToast);
              }
              else if(addPersonModel.phone!.isNotEmpty && addPersonModel.phone!.length < 7){
                fToast.init(context);
                MassageForToast().massageForAlert(lang.telephoneRequired,false,fToast);
              }
              else{
                Map<String , dynamic> personData = addPersonModel.toJson();
                showDialog(
                  barrierDismissible: false,
                    context: context, builder: (context){
                      // ignore: deprecated_member_use
                      return WillPopScope(
                          onWillPop: ()async {
                            return false;
                          },
                          child: Center(child: CircularProgressIndicator(),));
                });
                LoginData loginData=await AddPersonApi().addPersonApi(personData);
                //Navigator.pop(context);
                if(loginData.result!=null &&loginData.result==1 ){
                  //GetPersonDropDown().getPersonDropDown(pageNumber, pageSize)
                  var person= await GetPersonDropDown().getPersonDropDown(1, 50,customerDataProvider.customerDataModel.arabicCustomerName);
                  Provider.of<Cart_Items>(context,listen: false).personId=person.data[0];
                  Navigator.pop(context);
                  employeeType=[];
                  employeeBranch=[];
                  salesmanDropDown=[];
                  getFinancialDropDown=[];
                  customerDataProvider=CustomerDataProvider();
                  addPersonModel=AddPersonModel();
                  branchDataDropDown=LoginData();
                  fToast.init(context);
                  MassageForToast().massageForAlert(lang.addedSuccessfully,true,fToast);
                  Navigator.of(context).pop(true);
                }
                else if(loginData.result!=null &&loginData.result == 34){
                  Navigator.pop(context);
                  String massage =Provider.of<modelprovider>(context,listen: false).applocal==Locale("ar") ? loginData.errorMassageAr!:
                      loginData.errorMassageEn!;
                  employeeType=[];
                  employeeBranch=[];
                  salesmanDropDown=[];
                  getFinancialDropDown=[];
                  branchDataDropDown=LoginData();
                  customerDataProvider=CustomerDataProvider();
                  addPersonModel=AddPersonModel();
                  fToast.init(context);
                  MassageForToast().massageForAlert(massage,false,fToast);
                  Navigator.of(context).pop();

                }
              }

            }
            else{
              if(customerDataProvider.customerDataModel.salesMan!= null &&customerDataProvider.customerDataModel.branch.isNotEmpty&&
              customerDataProvider.customerDataModel.customerType!=null ){
                addPersonModel.type=customerDataProvider.customerDataModel.customerType.id;
                addPersonModel.salesPriceId=0;
                addPersonModel.isSupplier=false;
                addPersonModel.responsibleEn=customerDataProvider.contactInformationModel.latinResponsibleName;
                addPersonModel.responsibleAr=customerDataProvider.contactInformationModel.arabicResponsibleName;
                addPersonModel.lessSalesPriceId= 0;
                addPersonModel.financialAccountId=customerDataProvider.customerDataModel.financialAccountDropDownModel.id==null ?0:
                customerDataProvider.customerDataModel.financialAccountDropDownModel.id;
                addPersonModel.branches=customerDataProvider.customerDataModel.branch;
                addPersonModel.addToAnotherList=false;
                addPersonModel.addressEn=customerDataProvider.contactInformationModel.latinAddress;
                addPersonModel.addressAr=customerDataProvider.contactInformationModel.arabicAddress;
                addPersonModel.salesManId=customerDataProvider.customerDataModel.salesMan!.id;
                addPersonModel.creditLimit=customerDataProvider.financialModel.creditLimit;
                addPersonModel.creditPeriod=customerDataProvider.financialModel.creditPeriod;
                addPersonModel.discountRatio=customerDataProvider.financialModel.discountRatio;
                addPersonModel.phone=customerDataProvider.contactInformationModel.phone;
                addPersonModel.fax=customerDataProvider.contactInformationModel.fax;
                addPersonModel.email=customerDataProvider.contactInformationModel.email;
                addPersonModel.buildingNumber=customerDataProvider.contactInformationModel.buildingNumber;
                addPersonModel.streetName=customerDataProvider.contactInformationModel.streetName;
                addPersonModel.neighborhood=customerDataProvider.contactInformationModel.neighborhood;
                addPersonModel.city=customerDataProvider.contactInformationModel.city;
                addPersonModel.country=customerDataProvider.contactInformationModel.country;
                addPersonModel.postalNumber=customerDataProvider.contactInformationModel.postalNumber;
                addPersonModel.taxNumber=customerDataProvider.customerDataModel.taxNumber;
                addPersonModel.status=customerDataProvider.customerDataModel.customerStatus;
                addPersonModel.arabicName=customerDataProvider.customerDataModel.arabicCustomerName;
                addPersonModel.latinName=customerDataProvider.customerDataModel.latinCustomerName;
                if(Provider.of<Cart_Items>(context,listen: false).otherSettingData.other_ConfirmeCustomerPhone==true && addPersonModel.phone=="" && addPersonModel.phone!.length<7 ){
                  fToast.init(context);
                  MassageForToast().massageForAlert(lang.telephoneRequired,false,fToast);
                }
                else if(addPersonModel.phone!.isNotEmpty && addPersonModel.phone!.length < 7){
                  fToast.init(context);
                  MassageForToast().massageForAlert(lang.telephoneRequired,false,fToast);
                }
                else{
                  Map<String , dynamic> personData = addPersonModel.toJson();
                  showDialog(
                      barrierDismissible: false,
                      context: context, builder: (context){
                    // ignore: deprecated_member_use
                    return WillPopScope(
                        onWillPop: ()async {
                          return false;
                        },
                        child: Center(child: CircularProgressIndicator(),));
                  });
                  LoginData loginData=await AddPersonApi().addPersonApi(personData);
                  //Navigator.pop(context);
                  if(loginData.result!=null &&loginData.result==1 ){
                    var person= await GetPersonDropDown().getPersonDropDown(1, 50,customerDataProvider.customerDataModel.arabicCustomerName);
                    Provider.of<Cart_Items>(context,listen: false).personId=person.data[0];
                    Navigator.pop(context);
                    employeeType=[];
                    employeeBranch=[];
                    salesmanDropDown=[];
                    getFinancialDropDown=[];
                    branchDataDropDown=LoginData();
                    customerDataProvider=CustomerDataProvider();
                    addPersonModel=AddPersonModel();
                    fToast.init(context);
                    MassageForToast().massageForAlert(lang.addedSuccessfully,true,fToast);
                    Navigator.of(context).pop(true);
                  }
                  else if(loginData.result!=null &&loginData.result == 34){
                    Navigator.of(context).pop();
                    String massage =Provider.of<modelprovider>(context,listen: false).applocal==Locale("ar") ? loginData.errorMassageAr!:
                    loginData.errorMassageEn!;
                    employeeType=[];
                    employeeBranch=[];
                    salesmanDropDown=[];
                    getFinancialDropDown=[];
                    branchDataDropDown=LoginData();
                    customerDataProvider=CustomerDataProvider();
                    addPersonModel=AddPersonModel();
                    fToast.init(context);
                    MassageForToast().massageForAlert(massage,false,fToast);
                    Navigator.of(context).pop();

                  }
                }
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r), color: basicColor),
            height: 40.h,
            width: double.infinity,
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  lang.add,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
