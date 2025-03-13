import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  late TextEditingController businessAdressController,
      operatingHoursController;

  Uint8List? businessLicenseImage;
  Uint8List? idProofImage;

  @override
  void initState() {
    super.initState();
    businessAdressController = TextEditingController();
    operatingHoursController = TextEditingController();
  }

  @override
  void dispose() {
    businessAdressController.dispose();
    operatingHoursController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source, bool isLicense) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        if (isLicense) {
          businessLicenseImage = imageBytes;
        } else {
          idProofImage = imageBytes;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                "Add Business Details",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: businessAdressController,
                decoration: InputDecoration(
                  labelText: "Business Address",
                  hintText: "Enter your business address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: operatingHoursController,
                decoration: InputDecoration(
                  labelText: "Operating Hours",
                  hintText: "e.g., 9 AM - 9 PM",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Upload Business License",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => pickImage(ImageSource.gallery, true),
                child: businessLicenseImage == null
                    ? uploadContainer()
                    : Image.memory(businessLicenseImage!,
                        width: double.infinity, height: 100, fit: BoxFit.cover),
              ),
              const SizedBox(height: 15),
              Text(
                "Upload ID Proof",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => pickImage(ImageSource.gallery, false),
                child: idProofImage == null
                    ? uploadContainer()
                    : Image.memory(idProofImage!,
                        width: double.infinity, height: 100, fit: BoxFit.cover),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Sign Up", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadContainer() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: Icon(Icons.upload, size: 40)),
    );
  }
}
