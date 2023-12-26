  import 'package:apex/home%20page%20screens/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api_directory/add_return_invoice_api.dart';
import '../../api_directory/invoice_details_api.dart';
import '../../api_directory/update_invoice_payment.dart';
import '../../model.dart';
import '../../models/invoice_data_object.dart';
import '../../models/items.dart';
import '../../models/login_data.dart';
import '../cart_items.dart';

class SendPaymentMethods {

  dynamic sendingInvoiceDataToApi(BuildContext context, double payment,
      bool isOtherPayment, List<PaymentsMethods> paymentMethods ) async {//,[String parentInvoiceCode=""]
    var providerCart = Provider.of<Cart_Items>(context, listen: false);
    InvoiceData invoiceData = InvoiceData();
    List<InvoiceDetails> invoiceDetails = [];
    if(providerCart.returnInvoice == false){
      invoiceData.totalDiscountValue =
      providerCart.getTotals(false).totalDiscount!;
      invoiceData.paid = payment;
      invoiceData.applyVat = providerCart.settingGeneral.applyvatG;
      invoiceData.invoiceDate =providerCart.invoiceData.edit ==false ? DateTime.now().toString() : providerCart.invoiceData.invoiceDate;
      invoiceData.priceWithVat = providerCart.settingGeneral.priceIncludVat;
      invoiceData.storeId =providerCart.invoiceData.edit ==false ? 1 : providerCart.invoiceData.storeId;
      //invoiceData.personId =providerCart.invoiceData.edit == false ? providerCart.personId.id : providerCart.invoiceData.personId;
      invoiceData.personId = providerCart.personId.id ;
      // if(providerCart.invoiceData.edit == false && providerCart.personId !=null){
      //   invoiceData.personId = providerCart.personId.id;
      // }
      // else{
      //
      // }
      invoiceData.isOtherPayment = isOtherPayment;
      invoiceData.paymentsMethods = paymentMethods;
      // if(providerCart.invoiceData.edit ==false){
      //   invoiceData.parentInvoiceCode =providerCart.invoiceData.returnInvoices ==false ? "" : providerCart.invoiceData.parentInvoiceCode;
      // }
      // else{
      //   invoiceData.parentInvoiceCode = providerCart.invoiceData.parentInvoiceCode;
      // }
      invoiceData.parentInvoiceCode =providerCart.invoiceData.edit ==false ? "" : providerCart.invoiceData.parentInvoiceCode;
      invoiceData.invoiceId =providerCart.invoiceData.edit ==false? 0 :providerCart.invoiceData.invoiceId;

      //invoiceData.totalDiscountValue =providerCart.
      if (providerCart.radioDiscount == "fixed") {
        invoiceData.totalDiscountValue = providerCart.discount;
        invoiceData.isDiscountRatio=false;
        invoiceData.totalDiscountRatio = 0.0;
      } else if (providerCart.radioDiscount == "percentage") {
        invoiceData.totalDiscountRatio = providerCart.discount;
        invoiceData.isDiscountRatio=true;
        invoiceData.totalDiscountValue = 0;
      }

      if (providerCart.counterDiscountCheek >  0) {
        invoiceData.discountType = 1;//change the value for test // the discount in the item
      } else if (providerCart.isDiscountOnItem) {
        invoiceData.discountType = 2;//change the value for test // that mean discount in all invoice
      } else {
        invoiceData.discountType = 0;
      }

// hena invoice detales
      int i=0;
      for (Item item in providerCart.bascet_item) {
        InvoiceDetails invoice = InvoiceDetails();
        invoice.price = item.priceGenrel;
        invoice.discountValue = item.discountValue;
        invoice.vatRatio = item.vatRatioe;
        invoice.discountRatio = item.discountRatio;
        invoice.itemCode = item.itemCode;
        invoice.itemTypeId=item.itemTypeId;
        invoice.itemId = item.id;
        invoice.quantity = double.parse(item.qty.toString());
        if (item.itemDisccountType == "fixed") {
          // invoiceData.totalDiscountValue = providerCart.discount;
          // invoiceData.totalDiscountRatio = 0.0;
          invoice.isDiscountRatioItem=false;
          invoice.discountValue=item.discountValue;
          invoice.discountRatio=0;
        } else if (item.itemDisccountType == "percentage") {
          // invoiceData.totalDiscountRatio = providerCart.discount;
          // invoiceData.totalDiscountValue = 0;
          invoice.isDiscountRatioItem=true;
          invoice.discountValue=0;
          invoice.discountRatio=item.discountRatio;
        }
        //invoice.discountValue=item.discountValue;
        // invoice.balanceBarcode =providerCart.invoiceData.edit == false? "" : providerCart.invoiceData.invoiceDetails![i].balanceBarcode;
        // invoice.isBalanceBarcode =providerCart.invoiceData.edit ==false? false :providerCart.invoiceData.invoiceDetails![i].isBalanceBarcode;
        if(providerCart.settingGeneral.editeInvoice== true){
          // print(providerCart.invoiceData.invoiceDetails!.length);
          if(i< providerCart.invoiceData.invoiceDetails!.length){
            invoice.balanceBarcode = providerCart.invoiceData.invoiceDetails![i].balanceBarcode;
            invoice.isBalanceBarcode =providerCart.invoiceData.invoiceDetails![i].isBalanceBarcode;
            invoice.unitId= item.dropDownValue ==null ? providerCart.invoiceData.invoiceDetails![i].unitId :
            item.dropDownValue!.unitId;
          }
          else{
            invoice.balanceBarcode = "" ;
            invoice.isBalanceBarcode = false;
            invoice.unitId = item.dropDownValue == null
                ? item.units[0].unitId
                : item.dropDownValue!.unitId;
          }
        }
        else{
          invoice.balanceBarcode = "" ;
          invoice.isBalanceBarcode = false;
          invoice.unitId = item.dropDownValue == null
              ? item.units[0].unitId
              : item.dropDownValue!.unitId;
        }

        if(item.selectedSerialItems.isNotEmpty){
          invoice.listSerials =item.selectedSerialItems;
        }
        else{
          invoice.listSerials = [];
        }
        if(item.itemTypeId==3&&item.expiryItemDate != null){
          invoice.expireDate=item.expiryItemDate;
        }
        else{
          invoice.expireDate = "";
        }
        invoiceDetails.add(invoice);
        i++;
      }
      invoiceData.notes =Provider.of<menuProviderOptions>(context,listen: false).note;

      //invoiceData.invoiceDetails?.addAll(invoiceDetails);
      invoiceData.invoiceDetails = invoiceDetails;
      invoiceData.applyVat=false;
      invoiceData.net=payment;
      invoiceData.otherAdditionList=[];
    }
    else{
    invoiceData =  setDataReturnInvoice( context, payment,
          isOtherPayment,  paymentMethods );
    }
    Map<String , dynamic> invoiceJson = invoiceData.toJson();
    bool isArabic = Provider.of<modelprovider>(context,listen: false).applocal ==const Locale("ar")? true :false;

    // hena ba7wel el data l json

    LoginData result=LoginData();
    if(providerCart.settingGeneral.editeInvoice==false && providerCart.returnInvoice==false){
      result  = await InvoiceDataApi()
          .invoiceDataApi(invoiceJson,isArabic);
    }
    else if(providerCart.returnInvoice==true){
      result=await AddReturnedInvoice().addReturnedInvoice(invoiceJson, isArabic);
    }
    else{
       result = await InvoicePaymentUpdate()
          .invoicePaymentUpdate(invoiceJson,isArabic);
    }
    return result;
  }

  InvoiceData setDataReturnInvoice(BuildContext context, double payment,
      bool isOtherPayment, List<PaymentsMethods> paymentMethods )  {
    //,[String parentInvoiceCode=""]
    var providerCart = Provider.of<Cart_Items>(context, listen: false);
    InvoiceData invoiceData = InvoiceData();
    List<InvoiceDetails> invoiceDetails = [];
    invoiceData.totalDiscountValue =
    providerCart.getTotals(false).totalDiscount!;
    invoiceData.paid = payment;
    invoiceData.returnInvoices=true;
    invoiceData.applyVat = providerCart.settingGeneral.applyvatG;
    invoiceData.invoiceDate = providerCart.invoiceData.invoiceDate;
    invoiceData.priceWithVat = providerCart.settingGeneral.priceIncludVat;
    invoiceData.storeId = providerCart.invoiceData.storeId;
    //invoiceData.personId =providerCart.invoiceData.edit == false ? providerCart.personId.id : providerCart.invoiceData.personId;
    invoiceData.personId = providerCart.personId.id ;
    invoiceData.isOtherPayment = isOtherPayment;
    invoiceData.paymentsMethods = paymentMethods;
    invoiceData.parentInvoiceCode = providerCart.invoiceData.parentInvoiceCode;
    invoiceData.invoiceId =providerCart.invoiceData.invoiceId;
    invoiceData.net=payment;
    invoiceData.otherAdditionList=providerCart.invoiceData.otherAdditionList == null ? [] : providerCart.invoiceData.otherAdditionList;

    //invoiceData.totalDiscountValue =providerCart.
    if (providerCart.radioDiscount == "fixed") {
      invoiceData.totalDiscountValue = providerCart.discount;
      invoiceData.isDiscountRatio=false;
      invoiceData.totalDiscountRatio = 0.0;
    } else if (providerCart.radioDiscount == "percentage") {
      invoiceData.totalDiscountRatio = providerCart.discount;
      invoiceData.isDiscountRatio=true;
      invoiceData.totalDiscountValue = 0;
    }

    if (providerCart.counterDiscountCheek >  0) {
      invoiceData.discountType = 1;//change the value for test // the discount in the item
    } else if (providerCart.isDiscountOnItem) {
      invoiceData.discountType = 2;//change the value for test // that mean discount in all invoice
    } else {
      invoiceData.discountType = 0;
    }

// hena invoice detales
    int i=0;
    for (Item item in providerCart.bascet_item) {
      InvoiceDetails invoice = InvoiceDetails();
      invoice.price = item.priceGenrel;
      invoice.discountValue = item.discountValue;
      invoice.vatRatio = item.vatRatioe;
      invoice.discountRatio = item.discountRatio;
      invoice.itemCode = item.itemCode;
      invoice.itemTypeId=item.itemTypeId;
      invoice.itemId = item.id;
      invoice.indexOfItem = item.indexOfItem;
      //invoice.
      invoice.quantity = double.parse(item.qty.toString());
      invoice.id=item.id;
      invoice.applyVat=item.applyVate;
      if (item.itemDisccountType == "fixed") {
        invoice.isDiscountRatioItem=false;
        invoice.discountValue=item.discountValue;
        invoice.discountRatio=0;
      } else if (item.itemDisccountType == "percentage") {
        invoice.isDiscountRatioItem=true;
        invoice.discountValue=0;
        invoice.discountRatio=item.discountRatio;
      }
      if(providerCart.settingGeneral.returnInvoice== true){
        // print(providerCart.invoiceData.invoiceDetails!.length);
        if(i < providerCart.invoiceData.invoiceDetails!.length){
          invoice.balanceBarcode = providerCart.invoiceData.invoiceDetails![i].balanceBarcode;
          invoice.isBalanceBarcode =providerCart.invoiceData.invoiceDetails![i].isBalanceBarcode;
          invoice.unitId= item.dropDownValue ==null ? providerCart.invoiceData.invoiceDetails![i].unitId :
          item.dropDownValue!.unitId;
        }
        else{
          invoice.balanceBarcode = "" ;
          invoice.isBalanceBarcode = false;
          invoice.unitId = item.dropDownValue == null
              ? item.units[0].unitId
              : item.dropDownValue!.unitId;
        }
      }
      else{
        invoice.balanceBarcode = "" ;
        invoice.isBalanceBarcode = false;
        invoice.unitId = item.dropDownValue == null
            ? item.units[0].unitId
            : item.dropDownValue!.unitId;
      }

      if(item.selectedSerialItems.isNotEmpty){
        invoice.listSerials =item.selectedSerialItems;
      }
      else{
        invoice.listSerials = [];
      }
      if(item.itemTypeId==3 && item.expiryItemDate != null){
        invoice.expireDate=item.expiryItemDate;
      }
      else{
        invoice.expireDate = "";
      }
      invoiceDetails.add(invoice);
      i++;
    }
    invoiceData.notes =Provider.of<menuProviderOptions>(context,listen: false).note;

    //invoiceData.invoiceDetails?.addAll(invoiceDetails);
    invoiceData.invoiceDetails = invoiceDetails;
    //invoiceData.applyVat=false;
    return invoiceData;
  }

}
