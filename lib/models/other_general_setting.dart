class OtherGeneralSetting {
int decimalNumber;
bool? other_ConfirmeCustomerPhone;
OtherGeneralSetting(this.decimalNumber,this.other_ConfirmeCustomerPhone);
  factory OtherGeneralSetting.fromJson(Map<String, dynamic> json) {
    return OtherGeneralSetting(
        json["other_Decimals"],
        json["other_ConfirmeCustomerPhone"]
    );

  }
}