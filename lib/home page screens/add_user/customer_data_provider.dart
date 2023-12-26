
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../models/contact_information_model.dart';
import '../../models/customer_data_model.dart';
import '../../models/finanial_model.dart';

class CustomerDataProvider {
  ContactInformationModel contactInformationModel=ContactInformationModel();
  CustomerDataModel customerDataModel=CustomerDataModel();
  FinancialModel  financialModel = FinancialModel();
  BuildContext? _ancestorContext;
  BuildContext? get ancestorContext => _ancestorContext;
  // void saveAncestorReference(BuildContext context) {
  //   _ancestorContext = context;
  // }

  // void setContactInformation(){
  //   contactInformationModel.latinResponsibleName="";
  //   contactInformationModel.arabicResponsibleName="";
  //   contactInformationModel.phone="";
  //   contactInformationModel.fax="";
  //   contactInformationModel.email="";
  //   contactInformationModel.buildingNumber="";
  //   contactInformationModel.streetName="";
  //   contactInformationModel.neighborhood="";
  //   contactInformationModel.arabicAddress="";
  //   contactInformationModel.latinAddress="";
  //   contactInformationModel.city="";
  //   contactInformationModel.country="";
  //   contactInformationModel.postalNumber="";
  //
  //   //notifyListeners();
  //
  // }
  // void setCustomerDataModel(){
  //   customerDataModel.taxNumber="";
  //   customerDataModel.salesMan="";
  //   customerDataModel.latinCustomerName="";
  //   customerDataModel.customerType="";
  //   customerDataModel.customerStatus=true;
  //   customerDataModel.branch.latinName="";
  //   customerDataModel.branch.arabicName="";
  //   customerDataModel.branch.branchId=1;
  //   customerDataModel.branch.status=1;
  //   customerDataModel.arabicCustomerName="";
  //
  //   //notifyListeners();
  // }

  void setFinancialModel(){
    financialModel.creditPeriod=0;
    financialModel.creditLimit=0;
    financialModel.discountRatio=0;
    //notifyListeners();
  }


  void setContactInformationForm(ContactInformationModel contact){
    contactInformationModel.latinResponsibleName=contact.latinResponsibleName;
    contactInformationModel.arabicResponsibleName=contact.arabicResponsibleName;
    contactInformationModel.phone=contact.phone;
    contactInformationModel.fax=contact.fax;
    contactInformationModel.email=contact.email;
    contactInformationModel.buildingNumber=contact.buildingNumber;
    contactInformationModel.streetName=contact.streetName;
    contactInformationModel.neighborhood=contact.neighborhood;
    contactInformationModel.arabicAddress=contact.arabicAddress;
    contactInformationModel.latinAddress=contact.latinAddress;
    contactInformationModel.city=contact.city;
    contactInformationModel.country=contact.country;
    contactInformationModel.postalNumber=contact.postalNumber;
    //notifyListeners();

  }
  // void setCustomerDataModelForm(CustomerDataModel customer){
  //   customerDataModel.taxNumber=customer.taxNumber;
  //   customerDataModel.salesMan=customer.salesMan;
  //   customerDataModel.latinCustomerName=customer.latinCustomerName;
  //   customerDataModel.customerType=customer.customerType;
  //   customerDataModel.customerStatus=customer.customerStatus;
  //   customerDataModel.branch.latinName=customer.branch.latinName;
  //   customerDataModel.branch.arabicName=customer.branch.arabicName;
  //   customerDataModel.branch.branchId=customer.branch.branchId;
  //   customerDataModel.branch.status=customer.branch.status;
  //   customerDataModel.arabicCustomerName=customer.arabicCustomerName;
  //
  //   //notifyListeners();
  // }
  //
  // void setFinancialModelForm(FinancialModel financial){
  //   financialModel.creditPeriod=financial.creditPeriod;
  //   financialModel.creditLimit=financial.creditLimit;
  //   financialModel.discountRatio=financial.discountRatio;
  //   //notifyListeners();
  // }
  // void setFinancialModelForm(FinancialModel newFinancialModel) {
  //   // Implement your logic to store or update the FinancialModel data
  //    financialModel = newFinancialModel;
  //
  //   // Notify listeners about the change
  //  // notifyListeners();
  // }


}