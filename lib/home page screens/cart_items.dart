//import 'dart:math';
import 'dart:math';

import 'package:apex/models/general_setting.dart';
import 'package:apex/models/general_setting_actdiscount.dart';
import 'package:flutter/cupertino.dart';
import '../models/get_invoice_api.dart';
import '../models/invoice_data_object.dart';
import '../models/items.dart';
import '../models/other_general_setting.dart';

class Cart_Items with ChangeNotifier {

final  List<Item> _myItems = [];
  bool isEdite=false;
  double _price = 0.0;
  double discount = 0.0;
  String radioDiscount = "fixed";
  double get price => _price;
  double totalVat =0;
  bool returnInvoice=false;
  PersonInvoiceDropDown personId= PersonInvoiceDropDown(id: 2,latinName: "Cash Customer" ,arabicName: "عميل نقدي") ;//(id: 2,latinName: "Cash Customer" ,arabicName: "عميل نقدي")

  late GeneralSetting dataSetting ;
  late GeneralSettingActiveDis dataDisVat;
  late OtherGeneralSetting otherSettingData;
   setting settingGeneral =setting();

int counterDiscountCheek =0;
  bool isDiscountOnItem= false;
  InvoiceData invoiceData=InvoiceData();


  void add_item(Item item) {

    double unitPrice=item.priceGenrel  ;

    if (_myItems.isEmpty &&item.itemTypeId!=3 &&item.itemTypeId!=2) {
      _myItems.add(item);
      _price += unitPrice * item.qty;
      notifyListeners();
    } else {
      int founded = _myItems.indexWhere((element) => element.id == item.id);
      if(item.itemTypeId==3){
        int expiryIndex = _myItems.indexWhere((element) => element.expiryItemDate !=null && element.expiryItemDate==item.expiryItemDate);
        if(expiryIndex!=-1){
          _myItems[expiryIndex]=item;
          notifyListeners();
        }
        else{
          _myItems.add(item);
          _price += unitPrice  * item.qty;
          notifyListeners();
        }

      }
      else if(item.itemTypeId==2){
        if(founded !=-1){
          item.qty = item.selectedSerialItems.isNotEmpty ?item.selectedSerialItems.length.toDouble() : 1.0;
          _myItems[founded]=item;
          _price += unitPrice  * item.qty;
          notifyListeners();
        }
        else{
          item.qty= item.selectedSerialItems.isNotEmpty ? item.selectedSerialItems.length.toDouble() : 1.0;
          _myItems.add(item);
          _price += unitPrice  * item.qty;
          notifyListeners();
        }

      }
     else{
        if (founded != -1) {
          _myItems[founded]=item;
          notifyListeners();
        } else {
          _myItems.add(item);
          _price += unitPrice  * item.qty;
          notifyListeners();
        }
      }
    }
  }
double getTotalwitoutDiscount()
{
  double total =0;
  for(Item item in _myItems){
    total+= getItemTotalPrice(item);
  }
  return roundDouble(total,settingGeneral.roundNumG!) ;
}
  void  updat() {
   notifyListeners();
  }


  int get_cart_count() {
    return _myItems.length;
  }
  double roundDouble(double value, int places){
    double mod = pow(10.0, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
    // double roundedNumber = double.parse(value.toStringAsFixed(places));
    // return roundedNumber;
  }


  double get_total_price() {
    double x = 0;
    //totalVat=0;

    for (int i = 0; i < _myItems.length; i++) {
      _myItems[i].isEdite=false;
      if (_myItems[i].itemDisccount != 0) {
        _myItems[i].splitValue =0;
        x += itemDiscountFn(_myItems[i].itemDisccountType,
            _myItems[i].itemDisccount, _myItems[i]);

      } else {
        x += getItemTotalPrice(_myItems[i]);
        //_myItems[i].splitValue =0;
      }
      //totalVat +=_myItems[i].vatValue!;
      calculateVat(_myItems[i]);
    }
    _price = roundDouble(x,settingGeneral.roundNumG!);
    return roundDouble(_price,settingGeneral.roundNumG!);
  }

  double getTotalPriceDiscount(bool checkDisccount) {
    discountTotalPrice(radioDiscount, discount, checkDisccount);
    return roundDouble(_price,settingGeneral.roundNumG!);
  }

  void discountTotalPrice(String discountType, double discountAmount, bool val)
  {
    if(discount !=0){
      spliteDiscount(discountType,discountAmount);
    }
    double totalPrice =get_total_price();
    if(settingGeneral.activeDiscountG!){
      if (discountType == "percentage") {
        _price = roundDouble(discountAmount == 0.0
            ? totalPrice
            : totalPrice - (totalPrice * discountAmount / 100), settingGeneral.roundNumG!);
      } else if (discountType == "fixed") {
        _price = roundDouble(totalPrice - discountAmount, settingGeneral.roundNumG!);
      }
      //totalVat +=_myItems[i].vatValue!;
    }

    if (val) {
      notifyListeners();
    }
  }

  void remove_item(Item item) {
    item.qty = 1;
    item.itemDisccount = 0.0;
    item.oldPrice = 0;
    item.updatePrice = 0;
    item.splitValue=0;
    item.vatValue=0;
    _myItems.remove(item);
    notifyListeners();
  }

  void remove_all_items() {
    for (var item in _myItems) {
      item.qty = 1;
      item.itemDisccount = 0.0;
      item.oldPrice = 0;
      item.updatePrice = 0;
     item.splitValue=0;
     item.vatValue=0;
     item.selectedSerialItems.clear();
    }
    discount = 0.0;
    _myItems.clear();
    notifyListeners();
  }

  List<Item> get bascet_item {
    return _myItems;
  }

  double itemDiscountFn(String discountType, double discountAmount, Item item) {
    double value =0.0;
    if(settingGeneral.activeDiscountG!) {
      if (discountType == "percentage") {
        //item.discountValue =getItemdiscount(item);
         value= roundDouble(discountAmount == 0.0
             ? getItemTotalPrice(item)
             : getItemTotalPrice(item) -
             (getItemTotalPrice(item) * discountAmount / 100), settingGeneral.roundNumG!);
        return value;
      } else if (discountType == "fixed") {
        //item.discountValue=discountAmount;
         value= roundDouble(getItemTotalPrice(item) - discountAmount, settingGeneral.roundNumG!);
         return value;
      }
    }
    return 0.0;
  }

  double getItemTotalPrice(Item item) {
    //double unitPrice =item.dropDownValue ==null ?item.units[0].salePrice1! : item.dropDownValue!.salePrice1!;
    double unitPrice=item.priceGenrel;
    var itemTotal=0.0;
    if (item.oldPrice == 0) {
      itemTotal= roundDouble((item.qty * unitPrice), settingGeneral.roundNumG!);

    } else {
      itemTotal = roundDouble((item.qty * item.updatePrice), settingGeneral.roundNumG!);

    }
    //calculateVat(item);
    return itemTotal;
  }

  double  totalCartQty() {
    double totalCount = 0;
    for(var item in _myItems){
      totalCount += item.qty ;
    }
    return totalCount;
  }

  void spliteDiscount( String discountType, double discountAmount)
 {
    if (discountType == "percentage") {
      for(Item item in _myItems){
        item.splitValue=
            (getItemTotalPrice(item) * discountAmount / 100);
        //calculateVat(item);
      }
    } else if (discountType == "fixed") {
      double discountRatio= (discountAmount / get_total_price())*100;
      for(Item item in _myItems){
        item.splitValue=
            (getItemTotalPrice(item) * discountRatio / 100);
        //calculateVat(item);
      }
    }
  }
  void calculateVat(Item item){
    //double unitPrice =item.dropDownValue ==null ? item.units[0].salePrice1! : item.dropDownValue!.salePrice1!;
    //make update here
    double unitPrice=item.priceGenrel;
    if(!settingGeneral.applyvatG!){
      return ;
    }
    if(!item.applyVate!){
      return;
    }
    double itemTotal= 0;
    double price=0;
    if(item.oldPrice==0){
      price=unitPrice ;
    }
    else{
      price=item.updatePrice;
    }
    itemTotal=(item.qty * price)- item.splitValue- item.discountValue;

    if(settingGeneral.priceIncludVat!){
      item.vatValue =(itemTotal / (100 + item.vatRatioe!) * item.vatRatioe!);
    }
    else{
      item.vatValue =(itemTotal /100)*item.vatRatioe!;
      print(item.vatRatioe!);

    }

  }

  double getTotalVat(){
    double totalResult=0;
    for(Item item in _myItems){
      totalResult +=item.vatval!;
    }
    return roundDouble(totalResult, 6);
    //notifyListeners();
  }
  double getTotalDiscountValue(){
    double total = 0.0;
    if(discount==0){
      for(Item item in _myItems) {
        if(item.itemDisccountType=="percentage"){
          total +=
          item.itemDisccount == 0.0 ? 0.0
              : ((item.itemDisccount * getItemTotalPrice(item)) / 100);
        }
        else{
          total +=item.itemDisccount;
        }
      }
    }
    else{
      total= get_total_price() - getTotalPriceDiscount(false);
    }
    return roundDouble(total, settingGeneral.roundNumG!) ;
  }
  double getItemdiscount(Item item) {
    double discountValue=0;
    if(item.itemDisccountType=="percentage"){
      discountValue =
      item.itemDisccount == 0.0 ? 0.0
          : ((item.itemDisccount * 100) / getItemTotalPrice(item));
    }
    else{
      discountValue =item.itemDisccount;
    }
    return discountValue;
  }

  double getTotalItemDiscountValue(){
    double total = 0.0;
    if(discount==0){
      for(Item item in _myItems) {
        total+= getItemdiscount(item);

      }

    }
    else{
      total= get_total_price() - getTotalPriceDiscount(false);
    }
    return roundDouble(total,settingGeneral.roundNumG! ) ;
    }
int x=1;
  totalResult getTotals( bool checkDiscount){

    totalResult total=totalResult();
    if(isEdite==false){

      total.totalPrice=get_total_price() ;
      total.totalDiscount =roundDouble(getTotalPriceDiscount(checkDiscount), settingGeneral.roundNumG!) ;
      total.totalVatShowing=getTotalVat();
      // total.totalVat=0.0;
      if(settingGeneral.applyvatG!){
        if(!settingGeneral.priceIncludVat!){
          total.totalVat= getTotalVat();
        }
        else{
          total.totalVat=0.0;
        }
      }
      else{
        total.totalVat=0.0;
      }

      double totalDiscount = discount == 0 ? 0 : getTotalItemDiscountValue();

      total.net=  roundDouble(total.totalPrice! - totalDiscount + total.totalVat!,settingGeneral.roundNumG!);

      return total;
    }
    else{
      //print("in else if of the get total");
      total.net=invoiceData.net;
      total.totalVat=invoiceData.totalVat;
      total.totalVatShowing=invoiceData.totalVat;
      total.totalDiscount= discount;// invoiceData.totalDiscountValue;
      total.totalPrice=invoiceData.totalPrice;
      return total;
    }

  }

}
class totalResult{
  //double? itemTotal;

  double? totalPrice ;
  double? totalDiscount;
  double? totalVat;
  double? net;
  double? totalVatShowing;
  //totalResult(this.totalPrice,this.totalDiscount,this.totalVat,this.net);
}
class setting{
  bool editeInvoice=false;
  bool returnInvoice=false;
   GeneralSetting? dataSetting ;
   GeneralSettingActiveDis? dataDisVat;
   OtherGeneralSetting? otherSettingData;
   bool? applyVat;
   bool? activeDiscount;
   int? roundNum;
   bool? priceIncludeVat;
   bool? modifyPrice;
  bool? get applyvatG{
    //bool? temp =;
    return (editeInvoice == true  || returnInvoice ==true? applyVat :dataSetting!.vatActive);
  }
  bool? get activeDiscountG{
    //bool? temp =;
    return (returnInvoice==true ? activeDiscount : dataDisVat!.activeDiscount);
   // return dataDisVat!.activeDiscount;
  }
  int? get roundNumG{
    //bool? temp =;
    return (editeInvoice == true || returnInvoice ==true ? roundNum : otherSettingData!.decimalNumber);
  }
  bool? get priceIncludVat{
    //bool? temp =;
    return (editeInvoice == true || returnInvoice == true ? priceIncludeVat :dataDisVat!.priceIncludeVat);
  }
}