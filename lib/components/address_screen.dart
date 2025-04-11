


import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view_model/address_controller.dart';
import 'package:clique/view_model/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatelessWidget {
  final AddressController controller = Get.put(AddressController());
  final OrderViewModel orderViewModel = Get.put(OrderViewModel());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text("Enter Shipping Address"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              customTextField("Address 1", address1Controller, TextInputType.text),
              customTextField("Address 2", address2Controller, TextInputType.text),
              customTextField("City", cityController, TextInputType.text),
              customTextField("State Code", stateController, TextInputType.text),
              customTextField("Country Code", countryController, TextInputType.text),
              customTextField("ZIP Code", zipController, TextInputType.number),
              SizedBox(height: 20),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: isLoading.value
                        ? null
                        : () async {
                            if (countryController.text.isEmpty) {
                              Utils.showCustomSnackBar(
                                "Error",
                                "Please Enter Address.",
                                ContentType.warning,
                              );
                              return;
                            }

                            if (countryController.text.trim().length != 2) {
                              Utils.showCustomSnackBar(
                                "Invalid Country Code",
                                "Country code must be exactly 2 characters (e.g., US, NJ).",
                                ContentType.warning,
                              );
                              return;
                            }

                            controller.address1.value = address1Controller.text;
                            controller.address2.value = address2Controller.text;
                            controller.city.value = cityController.text;
                            controller.stateCode.value = stateController.text;
                            controller.countryCode.value = countryController.text;
                            controller.zipCode.value = zipController.text;

                            Utils.showCustomSnackBar(
                              "Info",
                              "Calculating Shipping Cost. Please Wait..",
                              ContentType.success,
                            );

                            isLoading.value = true;

                            await controller.saveAddressToPrefs();
                            await orderViewModel.submitOrder();

                            isLoading.value = false;

                            Get.back(); // Navigate back to the previous screen
                          },
                    child: isLoading.value
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            "Save Address",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(String label, TextEditingController controller, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
