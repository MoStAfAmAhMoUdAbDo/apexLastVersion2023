
class PaymentMethods{
  int paymentMethodId;
  String latinName;
  String arabicName;
  PaymentMethods(this.paymentMethodId ,this.latinName ,this.arabicName);
  factory PaymentMethods.fromJson(Map<String, dynamic> json) {
    return PaymentMethods(
        json["paymentMethodId"],
      json["latinName"],
      json["arabicName"]
    );
  }
}