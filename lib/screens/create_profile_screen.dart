import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solo_traveller/constants/colors.dart';
import 'package:solo_traveller/widgets/outline_text_field.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';
import 'package:intl/intl.dart';


class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  // String selectedYear = 'Year of birth';
  DateTime? selectedDate;

  final TextEditingController _firstNameController = TextEditingController();
  final _createProfileForm = GlobalKey<FormState>();
  RangeValues _currentRangeValues = const RangeValues(16, 80);

  void _saveProfile(context) async {
    // final isValid = _registerForm.currentState!.validate();
    // if (!isValid) {
    //   return;
    // }
    //
    // bool result = false;
    // try {
    //   result = await register(_emailController.text, _passwordController.text);
    // } on Exception catch (e) {
    //   showDialog<String>(
    //       context: context,
    //       builder: (BuildContext context) => AlertDialog(
    //         title: const Text('Failed'),
    //         content: Text(e.toString()),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () => Navigator.pop(context, 'Cancel'),
    //             child: const Text('Cancel'),
    //           ),
    //           TextButton(
    //             onPressed: () => Navigator.pop(context, 'OK'),
    //             child: const Text('OK'),
    //           ),
    //         ],
    //       ));
    // }
    //
    // // If success
    // if (result) {
    //   Navigator.push(
    //       context,
    //       new MaterialPageRoute(
    //           builder: (context) => new CreateProfileScreen()));
    // }
  }

  void _showDatePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              initialDateTime: DateTime(DateTime.now().year - 16),
              minimumYear: DateTime.now().year - 80,
              maximumYear: DateTime.now().year - 16,
            ),
          );
        });
  }




  @override
  Widget build(BuildContext context) {
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
                      height: 600,
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
                                                color: Color.fromRGBO(
                                                    170, 175, 190, 1)),
                                            builder: (countryCode) =>
                                                Container(
                                                    height: 56,
                                                    width: double.infinity,
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    decoration:
                                                        BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6),
                                                            border: Border.all(
                                                              width: 1.6,
                                                              color: Color.fromRGBO(218, 218, 236, 1),
                                                            )
                                                        ),
                                                    child: countryCode == null
                                                        ? Text('Country you\'re from')
                                                        : Text(countryCode.name.toString())
                                                ),
                                          ),
                                          Container(
                                              height: 56,
                                              width: double.infinity,
                                              padding: const EdgeInsets
                                                  .symmetric(horizontal: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6),
                                                  border: Border.all(
                                                    width: 1.6,
                                                    color: Color.fromRGBO(
                                                        218, 218, 236, 1),
                                                  )),
                                              child: TextButton(
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            selectedDate == null ? 'Year of birth' : DateFormat('yyyy-MM-dd').format(selectedDate!),
                                                            style: TextStyle(
                                                                // textBaseline: TextBaseline.alphabetic,
                                                                color: placeholderGrey,
                                                                fontFamily:'Roboto',
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 16
                                                            ),
                                                          )
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _showDatePicker(context);
                                                  })),
                                          Container(
                                            height: 96,
                                            width: double.infinity,
                                            alignment: Alignment.centerLeft,
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        6),
                                                border: Border.all(
                                                  width: 1.6,
                                                  color: Color.fromRGBO(218, 218, 236, 1),
                                                )),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Show age range in feed',
                                                  style: TextStyle(color: placeholderGrey),
                                                ),
                                                RangeSlider(
                                                  values: _currentRangeValues,
                                                  min: 16,
                                                  max: 80,
                                                  divisions: 10,
                                                  labels: RangeLabels(
                                                    _currentRangeValues.start.round().toString(),
                                                    _currentRangeValues.end.round().toString(),
                                                  ),
                                                  onChanged: (RangeValues values) {
                                                    setState(() {
                                                      _currentRangeValues = values;
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          RoundedGradientButton(
                                            buttonText: 'Save',
                                            width: 300,
                                            onPressed: () => _saveProfile(context),
                                          )
                                        ]
                                      )
                                    )
                                  )
                                )
                          ])),
                ))));
  }
}
