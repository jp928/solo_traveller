import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:solo_traveller/widgets/outline_text_field.dart';
import 'package:solo_traveller/widgets/years_picker.dart';

class CreateProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _firstNameController = TextEditingController();

    final _createProfileForm = GlobalKey<FormState>();
    // DateTime dt = new DateTime.now();
    void _showYearsPicker() {
      showModalBottomSheet(
          // backgroundColor: beachRed[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          context: context,
          builder: (context) => YearsPicker(
            onChange: (year) => {
              print(year)
            },
          )).whenComplete(() {
        // setState(() {});
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF4F4F4),
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color.fromRGBO(74, 90, 247, 1), //change your color here
          ),
        ),
        backgroundColor: Color(0xffF4F4F4),
        body: SafeArea(
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Container(
                      // height: 500,
                      height: 800,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Create a profile',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Text(
                                'Having a profile means you know this is a sage place to connect with people!',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    child: Form(
                                        key: _createProfileForm,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              OutlineTextField(
                                                controller:
                                                    _firstNameController,
                                                hintText: 'Your first name',
                                              ),
                                               CountryCodePicker(
                                                  onChanged: print,
                                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                  initialSelection: 'AU',
                                                  // favorite: ['+39','FR'],
                                                  // optional. Shows only country name and flag
                                                  showCountryOnly: true,
                                                  // optional. Shows only country name and flag when popup is closed.
                                                  showOnlyCountryWhenClosed: true,
                                                  // optional. aligns the flag and the Text left
                                                  alignLeft: true,
                                                  showFlag: false,
                                                  showFlagDialog: true,
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromRGBO(170, 175, 190, 1)
                                                  ),
                                                  builder: (countryCode) => Container(
                                                    height: 56,
                                                    width: double.infinity,
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(6),
                                                        border: Border.all(
                                                          width: 1.6,
                                                          color: Color.fromRGBO(218, 218, 236, 1),
                                                        )
                                                    ),
                                                    child: countryCode == null ? Text('Country you\'re from') : Text(countryCode.name.toString())
                                                  ),
                                               ),

                                                Container(
                                                    height: 56,
                                                    width: double.infinity,
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(6),
                                                        border: Border.all(
                                                          width: 1.6,
                                                          color: Color.fromRGBO(218, 218, 236, 1),
                                                        )
                                                    ),
                                                    child: TextButton(
                                                      child: Text('Year of birth', textAlign: TextAlign.left),
                                                      onPressed: () {
                                                        _showYearsPicker();
                                                      }),
                                                  ),
                                            ]))))
                          ])),
                ))));
  }
}
