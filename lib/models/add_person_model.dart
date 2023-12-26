
class AddPersonModel{
  bool?addToAnotherList;
  String? addressAr;
  String?addressEn;
  String?arabicName;
  List<int>?branches;
  String?buildingNumber;
  String?city;
  String?country;
  int? creditLimit;
  int?creditPeriod;
  int?discountRatio;
  String? email;
  String?fax;
  int? financialAccountId;
  bool? isSupplier;
  String?latinName;
  int?lessSalesPriceId;
  String?neighborhood;
  String? phone;
  String?postalNumber;
  String?responsibleAr;
  String?responsibleEn;
  int?salesManId;
  int?salesPriceId;
  int?status;
  String?streetName;
  String?taxNumber;
  int?type;
  AddPersonModel({this.latinName,this.arabicName,this.status,this.taxNumber,this.postalNumber,this.country,this.city,
                  this.neighborhood,this.streetName,this.buildingNumber,this.email,this.fax,this.phone,this.discountRatio,
                 this.creditPeriod,this.creditLimit,this.salesManId,this.addressAr,this.addressEn,this.addToAnotherList,
                  this.branches,this.financialAccountId,this.isSupplier,this.lessSalesPriceId,this.responsibleAr,this.responsibleEn,
                    this.salesPriceId,this.type});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['latinName'] = latinName;
    data['arabicName'] = arabicName;
    data['status'] = status;
    data['taxNumber'] = taxNumber;
    data['postalNumber'] = postalNumber;
    data['country'] = country;
    data['city'] = city;
    data['neighborhood'] = neighborhood;
    data['streetName'] = streetName;
    data['buildingNumber'] = buildingNumber;
    data['email'] = email;
    data['fax'] = fax;
    data['phone'] = phone;
    data['discountRatio'] = discountRatio;
    data['creditPeriod'] = creditPeriod;
    data['creditLimit'] = creditLimit;
    data['salesManId'] = salesManId;
    data['addressAr'] = addressAr;
    data['addressEn'] = addressEn;
    data['addToAnotherList'] = addToAnotherList;
    data['branches'] = branches;//hena t3del
    data['financialAccountId'] = financialAccountId;
    data['isSupplier'] = isSupplier;
    data['lessSalesPriceId'] = lessSalesPriceId;
    data['responsibleAr'] = responsibleAr;
    data['responsibleEn'] = responsibleEn;
    data['salesPriceId'] = salesPriceId;
    data['type'] = type;
    return data;
  }
}
