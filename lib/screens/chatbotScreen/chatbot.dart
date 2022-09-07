import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bike_cafe/services/api.dart';
import 'package:bike_cafe/widget/config.dart';
import 'package:hive/hive.dart';

class ChatBotPage extends StatefulWidget {
  ChatBotPage({Key? key, this.orderId}) : super(key: key);

  String? orderId;

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  Box? box1;

  @override
  void initState() {
    super.initState();
    createBox();
    if (widget.orderId != null) {
      serviceOrOrderIdController.value =
          TextEditingValue(text: widget.orderId.toString());
      queryType = "Orders";
    }
  }

  void createBox() async {
    box1 = await Hive.openBox('logindata');
    setState(() {});
  }

  APIService service = APIService();

  List<String> query = ["Account", "Services", "Orders"];

  DropdownMenuItem<String> options(String i) => DropdownMenuItem(
        value: i,
        child: Text(i),
      );

  String? queryType;
  TextEditingController serviceOrOrderIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController queryTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      service
          .sendQueryApi(
              queryType: queryType.toString(),
              serviceOrOrderId: serviceOrOrderIdController.text.toString(),
              emailId: emailController.text.toString(),
              mobileNumber: mobileNumberController.text.toString(),
              queryText: queryTextController.text.toString())
          .then((value) {
        if (value?.success == 1) {
          Get.back();
        }
      });
      return true;
    }
    return false;
  }

  formDecor(String hint) {
    return InputDecoration(
      // border: InputBorder.none,
      hintText: hint,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      fillColor: containerColor,
      filled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/img/bike_cafe_logo.png",
              width: 45,
              height: 45,
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Bike cafe",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Online",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Icon(
                      Icons.fiber_manual_record,
                      color: Colors.green,
                      size: 14,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: DropdownButtonFormField<String>(
                    items: query.map(options).toList(),
                    onChanged: (value) => setState(() {
                      queryType = value;
                      debugPrint(queryType);
                    }),
                    value: queryType,
                    iconSize: 22,
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    isExpanded: true,
                    hint: const Text('Query related to'),
                    decoration: formDecor(""),
                    validator: (input) {
                      if (input == null) {
                        return "Select query type";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: TextFormField(
                      controller: serviceOrOrderIdController,
                      decoration: formDecor("Service / Order Id"),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: TextFormField(
                    controller: emailController,
                    decoration: formDecor("Email Address *"),
                    validator: (input) {
                      if (input == '') {
                        return 'Enter email address';
                      } else {
                        bool _isEmailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(input!);
                        if (!_isEmailValid) {
                          return 'Invalid email.';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: TextFormField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.number,
                    decoration: formDecor("Mobile Number *"),
                    validator: (input) {
                      if (input == '') {
                        return 'Enter Mobile Number';
                      } else {
                        bool _isNumberValid =
                            RegExp(r"^[6-9][0-9]{9}").hasMatch(input!);
                        if (!_isNumberValid) {
                          return 'Invalid phone number';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: TextFormField(
                    controller: queryTextController,
                    minLines: 3,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: formDecor("Write query *"),
                    validator: (input) {
                      if (input == '') {
                        return 'Enter query';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          serviceOrOrderIdController.clear();
                          emailController.clear();
                          mobileNumberController.clear();
                          queryTextController.clear();
                        });
                      },
                      child: const Text("Clear"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        validateAndSave();
                      },
                      child: const Text("Submit"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Config.Height * 0.2),
                Column(
                  children: const [
                    Text("Thanks for being with us."),
                    Text("Your query will answered within 12-24 hrs")
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
