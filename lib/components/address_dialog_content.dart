import 'package:clique/view_model/address_controller.dart';
import 'package:clique/view_model/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddressDialogContent extends StatelessWidget {
  final AddressController controller = Get.put(AddressController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final OrderViewModel orderViewModel = Get.put(OrderViewModel());
  @override
  Widget build(BuildContext context) {
    return Form(
    
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            customTextField("Address 1", address1Controller),
            customTextField("Address 2", address2Controller),
            customTextField("City", cityController),
            customTextField("State Code", stateController),
            customTextField("Country Code", countryController),
            customTextField("ZIP Code", zipController),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                controller.address1.value = address1Controller.text;
                controller.address2.value = address2Controller.text;
                controller.city.value = cityController.text;
                controller.stateCode.value = stateController.text;
                controller.countryCode.value = countryController.text;
                controller.zipCode.value = zipController.text;

                controller.saveAddressToPrefs();
                //  orderViewModel.submitOrder();

                Get.back(); // Close dialog
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget customTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
