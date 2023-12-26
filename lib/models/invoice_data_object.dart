import 'items.dart';

class InvoiceData {
  bool edit=false;
  String? invoiceDate;
  int? storeId;
  String? notes;
  int? personId;
  double? totalDiscountValue;
  double? totalDiscountRatio;
  double? paid;
  int? discountType;
  bool? applyVat;
  bool? priceWithVat;
  String? parentInvoiceCode;
  bool? isOtherPayment;
  List<InvoiceDetails>? invoiceDetails;
  List<PaymentsMethods>? paymentsMethods;
  int? invoiceId ;
  int? invoiceTypeId;
  bool? isAccredited ;
  bool? isDeleted ;
  String? invoiceCode;
  double? net;
  double? remain;
  int? roundNumber;
  int? branchId;
  double? totalPrice;
  double? totalAfterDiscount;
  double? totalVat;
  int? invoiceSubTypesId;
  String? qrCode;
  String? bookIndex;
  int? storeIdTo;
  String? storeNameAr;
  String? storeNameEn;
  String? storeToNameAr;
  String? storeToNameEn;
  int? storeStatus;
  String? branchNameAr;
  String? branchNameEn;
  String? branchPhoneNumber;
  String? branchAddressAr;
  String? branchAddressEn;
  String? commercialRegisterNumber;
  String? personNameAr;
  String? personNameEn;
  String? personTaxNumber;
  String? personAddressAr;
  String? personAddressEn;
  double? balance;
  bool? isCreditor;
  int? personStatus;
  String? personResponsibleAr;
  String? personResponsibleEn;
  String? personPhone;
  String? personFax;
  String? personEmail;
  double? personCreditLimit;
  int? salesManId;
  String? salesManNameAr;
  String? salesManNameEn;
  int? employeeId;
  String? employeeNameAr;
  String? employeeNameEn;
  String? browserName;
  int? code;
  String? invoiceType;
  double? serialize;
  double? virualPaid;
  int? paymentType;
  double? totalPaymentsMethod;
  bool? activeDiscount;
  bool? canDeleted;
  var balanceBarcode;
  bool? isCollectionReceipt;
  bool? isReturn;
  bool? isDiscountRatio;
  bool returnInvoices=false;
  String? parentInvoiceCod;
  List<dynamic>? otherAdditionList;
  //double? net;




  InvoiceData(
      {this.invoiceDate, this.storeId, this.notes, this.personId, this.totalDiscountValue, this.totalDiscountRatio,
        this.paid, this.discountType, this.applyVat, this.priceWithVat, this.parentInvoiceCode, this.isOtherPayment,
        this.invoiceDetails, this.paymentsMethods, this.invoiceId, this.invoiceCode, this.personNameEn, this.totalPrice,
        this.invoiceSubTypesId, this.invoiceTypeId,this.paymentType,this.personNameAr,this.invoiceType,this.virualPaid,
        this.balanceBarcode, this.net,this.remain,this.totalVat,this.activeDiscount,this.balance,this.bookIndex,this.branchAddressAr,
        this.branchAddressEn,this.branchId,this.branchNameAr,this.branchNameEn,this.branchPhoneNumber,this.browserName,this.canDeleted,
        this.code,this.commercialRegisterNumber,this.employeeId,this.employeeNameAr,this.employeeNameEn,
        this.isAccredited, this.isCreditor,this.isDeleted,this.personAddressAr,this.personAddressEn,
        this.personCreditLimit, this.personEmail, this.personFax,this.personPhone,this.personResponsibleAr,this.personResponsibleEn,
        this.personStatus,this.personTaxNumber, this.qrCode,this.roundNumber,this.salesManId,this.salesManNameAr,this.salesManNameEn,
        this.serialize,this.storeIdTo, this.storeNameAr, this.storeNameEn,this.storeStatus,this.storeToNameAr,this.storeToNameEn,
        this.totalAfterDiscount,this.totalPaymentsMethod,this.isCollectionReceipt,this.isReturn,this.isDiscountRatio,this.parentInvoiceCod,
        this.otherAdditionList
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['InvoiceId'] = invoiceId;
    data['InvoiceDate'] = invoiceDate;
    data['storeId'] = storeId;
    data['Notes'] = notes;
    data['PersonId'] = personId;
    data['TotalDiscountValue'] = totalDiscountValue;
    data['TotalDiscountRatio'] = totalDiscountRatio;
    data['Paid'] = paid;
    data['net'] =net;
    data['DiscountType'] = discountType;
    data['ApplyVat'] = applyVat;
    data['PriceWithVat'] = priceWithVat;
    data['ParentInvoiceCode'] = parentInvoiceCode;
    data['isOtherPayment'] = isOtherPayment;
    data['isDiscountRatio'] = isDiscountRatio;
    data["otherAdditionList"] = otherAdditionList;

    if (invoiceDetails != null) {
      data['InvoiceDetails'] =
          invoiceDetails!.map((v) => v.toJson(this.returnInvoices)).toList();
    }
    if (paymentsMethods != null) {
      data['PaymentsMethods'] =
          paymentsMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
 factory InvoiceData.fromJson(Map<String, dynamic> json) {
    InvoiceData invoiceData=InvoiceData();
    invoiceData.invoiceId = json['invoiceId'];
    invoiceData.invoiceCode = json['invoiceCode'];
    invoiceData.parentInvoiceCode = json['parentInvoiceCode'];
    invoiceData.invoiceTypeId = json['invoiceTypeId'];
    invoiceData.invoiceSubTypesId = json['invoiceSubTypesId'];
    invoiceData.qrCode = json['qrCode'];
    invoiceData.bookIndex = json['bookIndex'];
    invoiceData.invoiceDate = json['invoiceDate'];
    invoiceData.storeId = json['storeId'];
    invoiceData.storeIdTo = json['storeIdTo'];
    invoiceData.storeNameAr = json['storeNameAr'];
    invoiceData.storeNameEn = json['storeNameEn'];
    invoiceData.storeToNameAr = json['storeToNameAr'];
    invoiceData.storeToNameEn = json['storeToNameEn'];
    invoiceData.storeStatus = json['storeStatus'];
    invoiceData.notes = json['notes'];
    invoiceData.branchId = json['branchId'];
    invoiceData.branchNameAr = json['branchNameAr'];
    invoiceData.branchNameEn = json['branchNameEn'];
    invoiceData.branchPhoneNumber = json['branchPhoneNumber'];
    invoiceData.branchAddressAr = json['branchAddressAr'];
    invoiceData.branchAddressEn = json['branchAddressEn'];
    invoiceData.commercialRegisterNumber = json['commercialRegisterNumber'];
    invoiceData.personId = json['personId'];
    invoiceData.personNameAr = json['personNameAr'];
    invoiceData.personNameEn = json['personNameEn'];
    invoiceData.personTaxNumber = json['personTaxNumber'];
    invoiceData.personAddressAr = json['personAddressAr'];
    invoiceData.personAddressEn = json['personAddressEn'];
    invoiceData.balance = json['balance'];
    invoiceData.isCreditor = json['isCreditor'];
    invoiceData.personStatus = json['personStatus'];
    invoiceData.personResponsibleAr = json['personResponsibleAr'];
    invoiceData.personResponsibleEn = json['personResponsibleEn'];
    invoiceData.personPhone = json['personPhone'];
    invoiceData.personFax = json['personFax'];
    invoiceData.personEmail = json['personEmail'];
    invoiceData.personCreditLimit = json['personCreditLimit'];
    invoiceData.salesManId = json['salesManId'];
    invoiceData.salesManNameAr = json['salesManNameAr'];
    invoiceData.salesManNameEn = json['salesManNameEn'];
    invoiceData.employeeId = json['employeeId'];
    invoiceData.employeeNameAr = json['employeeNameAr'];
    invoiceData.employeeNameEn = json['employeeNameEn'];
    invoiceData.browserName = json['browserName'];
    invoiceData.code = json['code'];
    invoiceData.invoiceType = json['invoiceType'];
    invoiceData.serialize = json['serialize'];
    invoiceData.totalPrice = json['totalPrice'];
    invoiceData.totalDiscountValue = json['totalDiscountValue'];
    invoiceData.totalDiscountRatio = json['totalDiscountRatio'];
    invoiceData.net = json['net'];
    invoiceData.paid = json['paid'];
    invoiceData.remain = json['remain'];
    invoiceData.virualPaid = json['virualPaid'];
    invoiceData.totalAfterDiscount = json['totalAfterDiscount'];
    invoiceData.totalVat = json['totalVat'];
    invoiceData.applyVat = json['applyVat'];
    invoiceData.priceWithVat = json['priceWithVat'];
    invoiceData.discountType = json['discountType'];
    invoiceData.paymentType = json['paymentType'];
    invoiceData.totalPaymentsMethod = json['totalPaymentsMethod'];
    invoiceData.activeDiscount = json['activeDiscount'];
    invoiceData.canDeleted = json['canDeleted'];
    invoiceData.isDeleted = json['isDeleted'];
    invoiceData.isAccredited = json['isAccredited'];
    invoiceData.roundNumber = json['roundNumber'];
    invoiceData.balanceBarcode = json['balanceBarcode'];
    invoiceData.isCollectionReceipt=json['isCollectionReceipt'];
    invoiceData.isReturn=json['isReturn'];
    invoiceData.parentInvoiceCod=json['parentInvoiceCod'];// i use this in return invoice only
    invoiceData.isDiscountRatio=json["isDiscountRatio"];
    invoiceData.otherAdditionList=json["otherAdditionList"] == null ? [] :json["otherAdditionList"];
    if (json['invoiceDetails'] != null) {
      invoiceData.invoiceDetails = <InvoiceDetails>[];
      json['invoiceDetails'].forEach((v) {
        print(v);
        invoiceData.invoiceDetails!.add(new InvoiceDetails.fromJson(v));
      });
    }
    if (json['paymentsMethods'] != null) {
      invoiceData.paymentsMethods = <PaymentsMethods>[];
      json['paymentsMethods'].forEach((v) {
        invoiceData.paymentsMethods!.add(new PaymentsMethods.fromJson(v));
      });
    }
    else{
      invoiceData.invoiceDetails=[];
      invoiceData.paymentsMethods=[];
    }


    return invoiceData;
  }
}





class InvoiceDetails {
  int? itemId;
  String? itemCode;
  int? unitId;
  double? quantity;
  double? price;
  String? expireDate;
  double? discountValue;
  double? discountRatio;
  double? vatRatio;
  bool? isBalanceBarcode;
  String? balanceBarcode;
  List<String>? listSerials;
  int? id;
  int? invoiceId;
  String? itemNameAr;
  String? itemNameEn;
  String? unitNameAr;
  String? unitNameEn;
  double? serialNumbers;
  double? oldQuantity;
  double? total;
  int? signal;
  int? itemTypeId;
  double? vatValue;
  double? transQuantity;
  double? returnQuantity;
  int? statusOfTrans;
  double? splitedDiscountValue;
  double? splitedDiscountRatio;
  double? avgPrice;
  double? cost;
  double? autoDiscount;
  int? priceList;
  double? minimumPrice;
  double? conversionFactor;
  int? indexOfItem;
  bool? canDelete;
  bool? applyVat;
  Null? storeSerialDtos;
  Null? transferSerialDtos;
  List<String>? invoiceSerialDtos;
  List<Unit> units =[];
  bool? isDiscountRatioItem;

  //bool? isBalanceBarcode;

  InvoiceDetails(
      {
        this.itemId,
        this.itemCode,
        this.unitId,
        this.quantity,
        this.price,
        this.expireDate,
        this.discountValue,
        this.discountRatio,
        this.vatRatio,
        this.isBalanceBarcode,
        this.balanceBarcode,
        this.listSerials,this.id,this.invoiceId,this.total,this.serialNumbers,this.itemTypeId,this.applyVat,this.vatValue,this.autoDiscount,
        this.avgPrice,this.canDelete,this.conversionFactor,this.cost,this.indexOfItem,this.itemNameAr,this.itemNameEn,
        this.minimumPrice,this.oldQuantity,this.priceList,this.returnQuantity,this.signal,this.splitedDiscountRatio,this.splitedDiscountValue,
        this.statusOfTrans,this.storeSerialDtos,this.transferSerialDtos,this.transQuantity,this.unitNameAr,this.unitNameEn,this.invoiceSerialDtos,
        this.isDiscountRatioItem
        //this.units
      });

  Map<String, dynamic> toJson(bool returnInvoices) {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['ItemId'] = itemId;
    data['ItemCode'] = itemCode;
    data['UnitId'] = unitId;
    data['Quantity'] = quantity;
    data['Price'] = price;
    data['ExpireDate'] = expireDate;
    data['DiscountValue'] = discountValue;
    data['DiscountRatio'] = discountRatio;
    data['VatRatio'] = vatRatio;
    data['isBalanceBarcode'] = isBalanceBarcode;
    data['balanceBarcode'] = balanceBarcode;
    data['itemTypeId'] = itemTypeId;
    data['isDiscountRatioItem'] = isDiscountRatioItem;
    //data["indexOfItem"]=indexOfItem;
    if(returnInvoices ==true){
      data["indexOfItem"]=indexOfItem; // i wwill use this in return only becase it make other payment to conflict and return bad request
    }
    if (listSerials != null) {
      data['ListSerials'] = listSerials;/// sending list of string to converting it to json
    }
    return data;
  }

   factory InvoiceDetails.fromJson(Map<String, dynamic> json) {
    InvoiceDetails invoiceDetails=InvoiceDetails();
    invoiceDetails.id = json['id'];
    invoiceDetails.invoiceId = json['invoiceId'];
    invoiceDetails.itemId = json['itemId'];
    invoiceDetails.itemCode = json['itemCode'];
    invoiceDetails.itemNameAr = json['itemNameAr'];
    invoiceDetails.itemNameEn = json['itemNameEn'];
    invoiceDetails.unitId = json['unitId'];
    invoiceDetails.unitNameAr = json['unitNameAr'];
    invoiceDetails.unitNameEn = json['unitNameEn'];
    invoiceDetails.serialNumbers = json['serialNumbers'];
    invoiceDetails.quantity = json['quantity'];
    invoiceDetails.oldQuantity = json['oldQuantity'];
    invoiceDetails.price = json['price'];
    invoiceDetails.total = json['total'];
    invoiceDetails.expireDate = json['expireDate'];
    invoiceDetails.signal = json['signal'];
    invoiceDetails.itemTypeId = json['itemTypeId'];
    invoiceDetails.discountValue = json['discountValue'];
    invoiceDetails.discountRatio = json['discountRatio'];
    invoiceDetails.vatRatio = json['vatRatio'];
    invoiceDetails.vatValue = json['vatValue'];
    invoiceDetails.transQuantity = json['transQuantity'];
    invoiceDetails.returnQuantity = json['returnQuantity'];
    invoiceDetails.statusOfTrans = json['statusOfTrans'];
    invoiceDetails.splitedDiscountValue = json['splitedDiscountValue'];
    invoiceDetails.splitedDiscountRatio = json['splitedDiscountRatio'];
    invoiceDetails.avgPrice = json['avgPrice'];
    invoiceDetails.cost = json['cost'];
    invoiceDetails.autoDiscount = json['autoDiscount'];
    invoiceDetails.priceList = json['priceList'];
    invoiceDetails.minimumPrice = json['minimumPrice'];
    invoiceDetails.conversionFactor = json['conversionFactor'];
    invoiceDetails.indexOfItem = json['indexOfItem'];
    invoiceDetails.canDelete = json['canDelete'];
    invoiceDetails.applyVat = json['applyVat'];
    invoiceDetails.isBalanceBarcode = json['isBalanceBarcode'];
    invoiceDetails.balanceBarcode = json['balanceBarcode'];
    invoiceDetails.storeSerialDtos = json['storeSerialDtos'];
    invoiceDetails.transferSerialDtos = json['transferSerialDtos'];
    invoiceDetails.isDiscountRatioItem =json['isDiscountRatioItem'];
    List<Unit> temp=[];
    if(json['itemUnits'] !=null){
      for (var c in json['itemUnits']) {
        temp.add(Unit.fromjson(c));
      }
    }
    invoiceDetails.units=temp;
    if(json['invoiceSerialDtos'] != null){
      invoiceDetails.invoiceSerialDtos=[];
      for(var v in json['invoiceSerialDtos']){
        invoiceDetails.invoiceSerialDtos!.add(v["serialNumber"].toString());
      }
    }
    else{
      invoiceDetails.invoiceSerialDtos=[];
    }
    return invoiceDetails;
  }

}
class InvoiceSerialDtos{
  int? itemId;
  String? serialNumber;
  bool? canDelete;
  InvoiceSerialDtos({this.itemId,this.canDelete,this.serialNumber});
  factory InvoiceSerialDtos.fromJson(Map<String, dynamic> json) {
    InvoiceSerialDtos invoiceSerialDtos =InvoiceSerialDtos();
    invoiceSerialDtos.serialNumber=json["serialNumber"];
    invoiceSerialDtos.itemId=json["itemId"];
    invoiceSerialDtos.canDelete=json["canDelete"];
    return invoiceSerialDtos;
  }

}

class PaymentsMethods {
  int? paymentMethodId;
  double? value ;
  String? cheque;
  String? paymentNameAr;
  String? paymentNameEn;

  PaymentsMethods({this.paymentMethodId, this.value, this.cheque,this.paymentNameAr,this.paymentNameEn});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['PaymentMethodId'] = paymentMethodId;
    data['Value'] = value;
    data['Cheque'] = cheque;
    return data;
  }
 factory PaymentsMethods.fromJson(Map<String, dynamic> json) {
    PaymentsMethods paymentsMethods=PaymentsMethods();
    paymentsMethods.paymentMethodId = json['paymentMethodId'];
    paymentsMethods.paymentNameAr = json['paymentNameAr'];
    paymentsMethods.paymentNameEn = json['paymentNameEn'];
    paymentsMethods.value = json['value'];
    paymentsMethods.cheque = json['cheque'];
    return paymentsMethods;
  }
}