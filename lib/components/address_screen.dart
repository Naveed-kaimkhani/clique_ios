


import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:clique/components/address_list.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view_model/address_controller.dart';
import 'package:clique/view_model/order_view_model.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatelessWidget {
  final AddressController controller = Get.put(AddressController());
  final OrderViewModel orderViewModel = Get.put(OrderViewModel());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

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
              // // cityDropDown(context),
              cityDropDown(context),
              
              stateDropDown(context),
              // customTextField("state Code", stat, TextInputType.number),
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
                            if (zipController.text.isEmpty || zipController.text.length != 5) {
                              Utils.showCustomSnackBar(
                                "Warning",
                                "Invalid ZIP Code.",
                                ContentType.warning,
                              );
                              return;
                            }
                             if (orderViewModel.stateCode.isEmpty ) {
                              Utils.showCustomSnackBar(
                                "Warning",
                                "Invalid state Code.",
                                ContentType.warning,
                              );
                              return;
                            }
                            if (orderViewModel.city.isEmpty ) {
                              Utils.showCustomSnackBar(
                                "Warning",
                                "Invalid City.",
                                ContentType.warning,
                              );
                              return;
                            }



                            controller.address1.value = address1Controller.text;
                            controller.address2.value = address2Controller.text;
                            controller.stateCode.value = stateController.text;
                            controller.countryCode.value = countryController.text;
                            controller.zipCode.value = zipController.text;

                            Utils.showCustomSnackBar(
                              "Info",
                              "Calculating Shipping Cost. Please Wait..",
                              ContentType.success,
                            );

                            isLoading.value = true;

                            await controller.saveAddressToPrefs(orderViewModel.stateCode.value,orderViewModel.city.value);
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
// Widget stateDropDown(BuildContext context) {
//   return Obx(() => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: TextFormField(
//           readOnly: true,
//           controller: stateController
//             ..text = controller.stateCode.value
//             ..selection = TextSelection.fromPosition(
//               TextPosition(offset: controller.stateCode.value.length),
//             ),
//           decoration: InputDecoration(
//             labelText: "State Code",
//             border: OutlineInputBorder(),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey),
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(Icons.arrow_drop_down),
//               onPressed: () => _showStateDropdown(context),
//             ),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return "Please select a state";
//             }
//             return null;
//           },
//         ),
//       ));
// }

Widget stateDropDown(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      readOnly: true,
      controller: stateController,
      decoration: InputDecoration(
        labelText: "State Code",
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.arrow_drop_down),
          onPressed: () => _showStateDropdown(context),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select a state";
        }
        return null;
      },
    ),
  );
}



  Widget cityDropDown(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller:cityController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "City",
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () => _showCityDropdown(context),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select a city";
              }
              return null;
            },
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

void _showStateDropdown(BuildContext context) {
  DropDownState<String>(
    dropDown: DropDown<String>(
      data: usStateCodes.map((state) => SelectedListItem<String>(data: state)).toList(),
      onSelected: (selectedItems) {
        if (selectedItems.isNotEmpty) {
          final selected = selectedItems.first.data;
          stateController.text = selected;
          controller.stateCode.value = selected;
          orderViewModel.stateCode.value = selected;
          log("Selected State: $selected");
        }
      },
    ),
  ).showModal(context);
}

  void _showCityDropdown(BuildContext context) {
    DropDownState<String>(
      dropDown: DropDown<String>(
        data: usCities.map((city) => SelectedListItem<String>(data: city)).toList(),
        onSelected: (selectedItems) {
          if (selectedItems.isNotEmpty) {
            cityController.text=selectedItems.first.data;
            orderViewModel.city.value = selectedItems.first.data;
          }
        },
      ),
    ).showModal(context);
  }
}
