import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/providers/auth_provider.dart';
import 'package:taskbuddy/views/constants.dart';
import 'package:taskbuddy/views/otp.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String phoneNo = "";

  var isLoading = false;
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneController.text = "";
  }

  Future _sendOtp(BuildContext ctx) async {
    final isValid = _form.currentState!.validate();
    isLoading = true;
    _form.currentState!.save();
    if (isValid) {
      await Provider.of<Auth>(ctx, listen: false)
          .authenticate(phoneNo)
          .catchError((e) {
        Fluttertoast.showToast(
          msg: e,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }).then((value) {
        Fluttertoast.showToast(
          msg: "OTP Sent Successfully !",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => OtpScreen(
              phoneNo: phoneNo,
            ),
          ),
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: "Enter A Valid Number !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: SizedBox(
                height: 200.0,
                child: Image.asset(
                  'assets/images/loading.gif',
                  fit: BoxFit.contain,
                ),
              ),
            )
          : LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Container(
                    color: Colors.blue,
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.30,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 40,
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                    ),
                                  ),
                                  Text('Login', style: kTextPopB24),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(children: [
                                Form(
                                  key: _form,
                                  child: IntlPhoneField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                      hintText: 'Phone Number',
                                      hintStyle: const TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.number.isEmpty) {
                                        return 'Please Enter Valid Number!';
                                      }
                                      return null;
                                    },
                                    initialCountryCode: 'IN',
                                    onChanged: (phone) {
                                      setState(() {
                                        phoneNo =
                                            phone.completeNumber.toString();
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  child: Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(200, 50)),
                                        maximumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(400, 50)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side:
                                                BorderSide(color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                      onPressed: () => _sendOtp(context),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Generate OTP',
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // ElevatedButton(
                                //   onPressed: () => _sendOtp(context),
                                //   style: ElevatedButton.styleFrom(
                                //       fixedSize: const Size(300, 50),
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(10)),
                                //       backgroundColor: kprimaryColor,
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 20, vertical: 10),
                                //       textStyle: const TextStyle(
                                //         fontSize: 18,
                                //       )),
                                //   child: const Text('Generate OTP'),
                                // ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
    );
  }
}
