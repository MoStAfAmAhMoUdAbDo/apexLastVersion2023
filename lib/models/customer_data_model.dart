import 'package:apex/models/salesman_model.dart';
import 'branch_model.dart';
import 'employee_type.dart';
import 'get_financial_account_model.dart';

class CustomerDataModel{
    String arabicCustomerName="";
    String latinCustomerName ="";
    EmployeeType customerType =EmployeeType();
    List<int> branch =[];
    int customerStatus =1;
    String taxNumber ="";
    SalesManModel? salesMan ;
    GetFinancialAccountDropDownModel financialAccountDropDownModel= GetFinancialAccountDropDownModel();
    CustomerDataModel();
    //CustomerDataModel([this.arabicCustomerName,this.branch,this.customerStatus,this.customerType,this.latinCustomerName,this.salesMan,this.taxNumber]);
}