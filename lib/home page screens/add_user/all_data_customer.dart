
import '../../models/contact_information_model.dart';
import '../../models/customer_data_model.dart';
import '../../models/finanial_model.dart';

class CustomerAllDataModel{
  ContactInformationModel? contactInformationModel;
  CustomerDataModel? customerDataModel;
  FinancialModel? financialModel;
  CustomerAllDataModel({this.financialModel,this.customerDataModel,this.contactInformationModel});
}