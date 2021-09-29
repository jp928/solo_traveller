import 'dart:io';
import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/constants/colors.dart';
import 'package:solo_traveller/futures/create_connectycube_session_future.dart';
import 'package:solo_traveller/futures/get_my_profile_future.dart';
import 'package:solo_traveller/futures/update_profile_future.dart';
import 'package:solo_traveller/futures/upload_profile_image_future.dart';
import 'package:solo_traveller/models/profile.dart';
import 'package:solo_traveller/models/settings.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/widgets/outline_text_field.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class EditMyProfileScreen extends StatefulWidget {
  const EditMyProfileScreen({Key? key}) : super(key: key);

  @override
  _EditMyProfileScreenState createState() => _EditMyProfileScreenState();
}

class _EditMyProfileScreenState extends State<EditMyProfileScreen> {
  DateTime? selectedDate;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final _createProfileForm = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Country? _country;

  Profile? _myProfile;

  _imgFromCamera() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      // imageQuality: 50,
      maxHeight: 200,
      maxWidth: 200,
    );

    setState(() {
      _image = image!;
    });
  }

  _imgFromGallery() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      // imageQuality: 50,
      maxHeight: 200,
      maxWidth: 200,
    );

    setState(() {
      _image = image!;
    });

    Navigator.of(context).pop();
  }

  void _saveProfile(BuildContext context) async {
    final isValid = _createProfileForm.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (_country == null) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('No country selected'),
                content: Text('Please select a country you are from.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));

      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    bool result = false;
    try {
      MyCubeUser user = context.read<MyCubeUser>();
      user.setName(_firstNameController.text);
      CubeUser? _cUser = user.user;
      if (_cUser == null) {
        _cUser = await createConnectyCubeSession(context);
      }

      String? profileImgUrl;
      if (_image != null) {
        profileImgUrl = await uploadProfileImage(File(_image!.path), context);
        user.setProfileImage(profileImgUrl);
      }

      Profile profile = Profile(
        _firstNameController.text,
        DateFormat('yyyy-MM-dd').format(selectedDate!),
        _country!.countryCode,
        _cUser!.id.toString(),
        _aboutController.text, // about
        profileImgUrl,
      );
      result = await updateProfile(profile);
    } on Exception catch (e) {
      Navigator.pop(context);
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Failed'),
                content: Text(e.toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    }

    // If success
    if (result) {
      Navigator.pop(context);
    }
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

  void _showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _getMyProfile() async {
    Profile profile = await getMyProfile();

    setState(() {
      _myProfile = profile;
      _firstNameController.text = profile.firstName;
      _aboutController.text = profile.about ?? '';
      if (_myProfile?.countryCode != null) {
        _country = CountryParser.parseCountryCode(_myProfile!.countryCode!);
      }

      if (_myProfile?.dateOfBirth != null) {
        selectedDate = DateTime.parse(_myProfile!.dateOfBirth);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    MyCubeUser user = context.watch<MyCubeUser>();

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
            child: GestureDetector(onTap: () {
          FocusScope.of(context).unfocus();
        }, child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
                // constraints: BoxConstraints(minHeight: constraint.maxHeight),
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showImagePicker(context);
                                },
                                child: CircleAvatar(
                                  radius: 52,
                                  backgroundColor:
                                      Color.fromRGBO(79, 152, 248, 1),
                                  child: _image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.file(
                                            File(_image!.path),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )
                                      :
                                      (
                                          user.profileImage == null ?
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50)),
                                              width: 100,
                                              height: 100,
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                                color: Colors.grey[800],
                                              ),
                                            )
                                          :
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            child: Image.network(
                                              user.profileImage!,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          )
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Add profile pic'),
                                    Text(
                                        'Adding a photo will help to verify your profile',
                                        softWrap: true,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 10,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          )),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Form(
                                  key: _createProfileForm,
                                  child: IntrinsicHeight(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                        OutlineTextField(
                                          controller: _firstNameController,
                                          hintText: 'Your first name',
                                          validator: (text) {
                                            if (text == null || text.isEmpty)
                                              return 'Please enter a name.';

                                            return null;
                                          },
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 8)),
                                        TextFormField(
                                          controller: _aboutController,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Short description about yourself',
                                          ),
                                          minLines: 1,
                                          maxLines: 5,
                                          validator: (text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Please enter description.';
                                            }
                                            return null;
                                          },
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 8)),
                                        GestureDetector(
                                          onTap: () {
                                            showCountryPicker(
                                              context: context,
                                              //Optional. Shows phone code before the country name.
                                              showPhoneCode: false,
                                              onSelect: (Country country) {
                                                setState(() {
                                                  _country = country;
                                                });
                                              },
                                              // Optional. Sets the theme for the country list picker.
                                              countryListTheme:
                                                  CountryListThemeData(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0),
                                                ),
                                                // Optional. Styles the search field.
                                                inputDecoration:
                                                    InputDecoration(
                                                  labelText: 'Search',
                                                  hintText:
                                                      'Start typing to search',
                                                  prefixIcon:
                                                      const Icon(Icons.search),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: const Color(
                                                              0xFF8C98A8)
                                                          .withOpacity(0.2),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                              height: 56,
                                              width: double.infinity,
                                              alignment: Alignment.centerLeft,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    width: 1.6,
                                                    color: Color.fromRGBO(
                                                        218, 218, 236, 1),
                                                  )),
                                              child: Text(_country == null
                                                  ? 'Country you\'re from'
                                                  : _country!
                                                      .displayNameNoCountryCode)),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 8)),
                                        Container(
                                            height: 56,
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
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
                                                        selectedDate == null
                                                            ? 'Year of birth'
                                                            : DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(
                                                                    selectedDate!),
                                                        style: TextStyle(
                                                            // textBaseline: TextBaseline.alphabetic,
                                                            color:
                                                                placeholderGrey,
                                                            fontFamily:
                                                                'Roboto',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _showDatePicker(context);
                                                })),
                                        Padding(padding: EdgeInsets.only(top: 16)),
                                        RoundedGradientButton(
                                          buttonText: 'Save',
                                          width: 300,
                                          onPressed: () =>
                                              _saveProfile(context),
                                        )
                                      ]) // end of Column
                                      ))))
                    ])),
          ); // end of scroll
        }))));
  }
}
