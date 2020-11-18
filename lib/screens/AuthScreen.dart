import 'package:KS_Stores/components/DialogBox.dart';
import 'package:KS_Stores/screens/EmailSetupScreen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/AuthProvider.dart';
import '../components/CommonButton.dart';

class AuthScreen extends StatefulWidget {
  static String routeName = "/auth-screen";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  bool _useEmail = false;
  bool _autoFocus = false;
  String verificationCode;
  String error = "";
  String otpValidationError = "";

  Future<bool> _setAutoFocusTrue() async {
    bool cStats = _useEmail;
    setState(() {
      _useEmail = !cStats;
      _autoFocus = true;
    });
    return _useEmail;
  }

  void submitForm() {
    // FocusScope.of(context).unfocus();
    _formKey.currentState.validate();
    if (error.length == 0 || error.isEmpty) {
      if (_useEmail) {
        Provider.of<AuthProvider>(context, listen: false)
            .checkIfUserAlreadyRegistered(_emailController.text)
            .then((bool userAlreadyRegistered) {
          Navigator.of(context).pushNamed(EmailSetupScreen.routeName,
              arguments: {
                "login": userAlreadyRegistered ? false : true,
                "email": _emailController.text
              });
        });
      }

      if (!_useEmail) {
        print("really from here");
        smsCodeDialog(context).then((value) => print("Signed In"));
        continueWithPhoneNo();
      }
    } else {}
  }

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  Future<bool> smsCodeDialog(BuildContext context) {
    final Color mainColor = Colors.green[900];
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Enter OTP",
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "A 6 digit code has been sent to \n+91 ${_phoneController.text}",
                style: TextStyle(color: mainColor, fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          body: Padding(
            key: UniqueKey(),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              key: UniqueKey(),
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  focusNode: focusNode,
                  maxLength: 6,
                  decoration: InputDecoration(hintText: "Enter OTP here"),
                ),
                if (otpValidationError.length > 0 ||
                    otpValidationError.isNotEmpty)
                  Container(
                    key: UniqueKey(),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    color: Colors.grey[200],
                    child: Text(
                      otpValidationError,
                      style: TextStyle(color: Colors.red, fontSize: 15),
                      key: UniqueKey(),
                    ),
                  ),
              ],
            ),
          ),
          cancelText: "Go Back",
          acceptText: "Continue",
          onPressed: () {
            AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                verificationId: verificationCode, smsCode: controller.text);
            FirebaseAuth.instance
                .signInWithCredential(phoneAuthCredential)
                .then((value) => Navigator.of(context).pop())
                .catchError((e) {
              setState(() {
                print("error");
                print("line 131");
                print(e);
              });
              if (e.code == 'invalid-phone-number') {
                setState(() {
                  otpValidationError =
                      'The provided phone number is not valid.';
                });
              } else if (e.code == "invalid-verification-code") {
                setState(() {
                  otpValidationError = 'Enter valid OTP';
                });
              } else {
                setState(() {
                  otpValidationError = e.message;
                });
              }
            });
          },
        );
      },
    );
  }

  void continueWithPhoneNo() async {
    final PhoneCodeSent phoneCodeSent = (String verId, int forceCodeResend) {
      setState(() {
        verificationCode = verId;
      });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${_phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        // print(credential);
        // print(credential.smsCode);
        // // Sign the user in (or link) with the auto-generated credential
        // _OTPController.text = credential.smsCode;
        // await Future.delayed(Duration(seconds: 1));
        // await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          print("error");
          print("line 170");
          print(e);
        });
        if (e.code == 'invalid-phone-number') {
          setState(() {
            otpValidationError = 'The provided phone number is not valid.';
          });
        } else if (e.code == "invalid-verification-code") {
          setState(() {
            otpValidationError = 'Enter valid OTP';
          });
        } else {
          setState(() {
            otpValidationError = e.message;
          });
        }
      },
      codeSent: phoneCodeSent,
      timeout: const Duration(seconds: 2),
      codeAutoRetrievalTimeout: (String verId) {
        setState(() {
          verificationCode = verId;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE74292),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/images/mall.png",
                    width: 60,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "K.S Stores",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ],
              ),
              // Spacer(flex: ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(
                              _useEmail ? _emailFocusNode : _phoneFocusNode);
                        },
                        child: Text(
                          "Mobile / Email",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 5),
                      if (_useEmail)
                        textField(
                          authType: "email",
                          context: context,
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          placeholder: "Enter Email Address",
                        ),
                      if (!_useEmail)
                        textField(
                          authType: "phone",
                          context: context,
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          placeholder: "Enter Phone No",
                        ),
                      if (error.length > 0 || error.isNotEmpty)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 5),
                          color: Colors.grey[200],
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                error = "";
                              });
                              bool stChanged = await _setAutoFocusTrue();
                              await Future.delayed(Duration(milliseconds: 500));
                              FocusScope.of(context).requestFocus(stChanged
                                  ? _emailFocusNode
                                  : _phoneFocusNode);
                            },
                            child: Text(!_useEmail ? "Use Email" : "Use Phone"),
                          )
                        ],
                      ),
                      SizedBox(height: 25),
                      CommonButton(onPressed: submitForm, btnText: "CONTINUE"),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 1,
                            color: Colors.white,
                          )),
                          SizedBox(width: 10),
                          Text(
                            "OR",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // RaisedButton(
                      //   onPressed: () async {
                      //     await FirebaseAuth.instance.signOut();
                      //   },
                      //   child: Text("Logout"),
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                          onPressed: () {
                            Provider.of<AuthProvider>(context, listen: false)
                                .continueWithGmail();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/google.svg",
                                width: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  fontFamily: "Lato",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField({
    BuildContext context,
    String authType,
    TextEditingController controller,
    FocusNode focusNode,
    String placeholder,
  }) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);
      },
      child: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 12,
          bottom: 8,
        ),
        child: TextFormField(
          autofocus: _autoFocus,
          controller: controller,
          focusNode: focusNode,
          keyboardType: authType == "email"
              ? TextInputType.emailAddress
              : TextInputType.number,
          decoration: InputDecoration.collapsed(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: placeholder,
          ),
          onChanged: (value) {
            setState(() {
              error = "";
            });
          },
          onEditingComplete: () {
            submitForm();
          },
          validator: (val) {
            String textFieldValue = val.trim();
            RegExp emailRegex = new RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
            RegExp mobileNoRegex =
                new RegExp(r"(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[789]\d{9}");
            if (_useEmail) {
              bool emailValid = emailRegex.hasMatch(textFieldValue);
              if (!emailValid) {
                setState(() {
                  error = "Please Enter valid email";
                });
              }
              if (textFieldValue.length == 0 ||
                  textFieldValue.isEmpty ||
                  textFieldValue == "") {
                setState(() {
                  error = "Please Enter email Address";
                });
              }
            }
            if (!_useEmail) {
              bool mobileNoValid = mobileNoRegex.hasMatch(textFieldValue);
              if (!mobileNoValid) {
                setState(() {
                  error = "Mobile No Invalid";
                });
              }
              if (textFieldValue.length == 0 ||
                  textFieldValue.isEmpty ||
                  textFieldValue == "") {
                setState(() {
                  error = "Please Enter Mobile No";
                });
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}
