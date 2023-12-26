import 'package:apex/home%20page%20screens/add_user/dialog_for_more_tabe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'financial_data_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ContactInformation extends StatefulWidget {
  ContactInformation({super.key});

  @override
  State<ContactInformation> createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
  TextEditingController arabicName=TextEditingController();
  TextEditingController latinName=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController fax=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController arabicAddress=TextEditingController();
  TextEditingController latinAddress=TextEditingController();
  TextEditingController buildingNumber=TextEditingController();
  TextEditingController streetName=TextEditingController();
  TextEditingController neighborhood=TextEditingController();
  TextEditingController city=TextEditingController();
  TextEditingController country=TextEditingController();
  TextEditingController postalNumber=TextEditingController();

  FocusNode arabicFocusNode=FocusNode();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_) =>FocusScope.of(context).requestFocus(arabicFocusNode));
   arabicName.text=customerDataProvider.contactInformationModel.arabicResponsibleName;
   latinName.text=customerDataProvider.contactInformationModel.latinResponsibleName;
   phone.text=customerDataProvider.contactInformationModel.phone;
   fax.text=customerDataProvider.contactInformationModel.fax;
   email.text=customerDataProvider.contactInformationModel.email;
   arabicAddress.text=customerDataProvider.contactInformationModel.arabicAddress;
   latinAddress.text=customerDataProvider.contactInformationModel.latinAddress;
   buildingNumber.text=customerDataProvider.contactInformationModel.buildingNumber;
   streetName.text=customerDataProvider.contactInformationModel.streetName;
   neighborhood.text=customerDataProvider.contactInformationModel.neighborhood;
   city.text=customerDataProvider.contactInformationModel.city;
   country.text=customerDataProvider.contactInformationModel.country;
   postalNumber.text=customerDataProvider.contactInformationModel.postalNumber;
  }

  @override
  Widget build(BuildContext context) {
    var lang =AppLocalizations.of(context);
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller:arabicName ,
          decoration: textDecoration(lang!.arabicResponsibleName),
          focusNode: arabicFocusNode,
          autofocus: true,
          onChanged: (ch){
            customerDataProvider.contactInformationModel.arabicResponsibleName=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: latinName,
          decoration: textDecoration(lang.englishResponsibleName),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.latinResponsibleName=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: phone,
          decoration: textDecoration(lang.phone),
          keyboardType: TextInputType.number,
          onChanged: (ch){
            customerDataProvider.contactInformationModel.phone=ch;
          },

        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: fax,
          decoration: textDecoration(lang.fax),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.fax=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: email,
          decoration: textDecoration(lang.email),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.email=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: arabicAddress,
          decoration: textDecoration(lang.arabicAddress),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.arabicAddress=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: latinAddress,
          decoration: textDecoration(lang.englishAddress),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.latinAddress=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: buildingNumber,
          decoration: textDecoration(lang.buildingNumber),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.buildingNumber=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: streetName,
          decoration: textDecoration(lang.streetName),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.streetName=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: neighborhood,
          decoration: textDecoration(lang.neighborhood),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.neighborhood=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: city,
          decoration: textDecoration(lang.city),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.city=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: country,
          decoration: textDecoration(lang.country),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.country=ch;
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        TextFormField(
          controller: postalNumber,
          decoration: textDecoration(lang.postalNumber),
          onChanged: (ch){
            customerDataProvider.contactInformationModel.postalNumber=ch;
          },
        ),
      ],
    );
  }
}
