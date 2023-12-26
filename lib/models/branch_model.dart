class EmployeeBranch{
  int? branchId;
  String? arabicName;
  String? latinName;
  int status=1;
  bool isMain=false;

  EmployeeBranch({this.latinName,this.arabicName,this.branchId });

  factory EmployeeBranch.fromJson(Map<String, dynamic> json) {
    EmployeeBranch employeeBranch=EmployeeBranch();
    employeeBranch.branchId = json['id'];
    employeeBranch.arabicName = json['arabicName'];
    employeeBranch.latinName = json['latinName'];
    employeeBranch.status = json['status'];
    employeeBranch.isMain=json['isMain'];
    return employeeBranch;
  }
}