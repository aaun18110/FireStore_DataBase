import 'dart:io';
import 'package:firestore_database/Services/error_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../Model/button.dart';
import 'package:firebase_database/firebase_database.dart';

class ImageUploadViewMode extends StatefulWidget {
  const ImageUploadViewMode({super.key});

  @override
  State<ImageUploadViewMode> createState() => _ImageUploadViewModeState();
}

class _ImageUploadViewModeState extends State<ImageUploadViewMode> {
  firebase_storage.FirebaseStorage storageImage =
      firebase_storage.FirebaseStorage.instance;
  final dataBaseRef = FirebaseDatabase.instance.ref('Post');

  bool loading = false;
  File? image;
  final imagePicker = ImagePicker();

  Future getImage() async {
    final pickIamge = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickIamge != null) {
        image = File(pickIamge.path);
        if (kDebugMode) {
          print("Image picked");
        }
      } else {
        if (kDebugMode) {
          print("No image picked");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Image"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: InkWell(
            onTap: () {
              getImage();
            },
            child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lime.shade300, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                child: image != null
                    ? Image.file(
                        image!.absolute,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Icon(
                        Icons.image_outlined,
                        size: 30,
                      ))),
          )),
          const SizedBox(
            height: 20,
          ),
          Button(
            title: "Upload",
            loading: loading,
            onpress: () {
              String id = DateTime.now().microsecondsSinceEpoch.toString();
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref('/ImageFolder/+$id');
              firebase_storage.UploadTask uploadTask =
                  ref.putFile(image!.absolute);
              setState(() {
                loading = true;
              });
              Future.value(uploadTask).then((value) async {
                var urlRef = await ref.getDownloadURL();
                dataBaseRef
                    .child(id)
                    .set({'id': id, 'title': urlRef.toString()}).then((value) {
                  setState(() {
                    loading = false;
                  });
                  ErrorMessage.toastMessage("Upload Sucessfully");
                }).onError((error, stackTrace) {
                  ErrorMessage.toastMessage(error.toString());
                });
              }).onError((error, stackTrace) {
                setState(() {
                  loading = false;
                });
                ErrorMessage.toastMessage(error.toString());
              });
            },
          ),
        ],
      ),
    );
  }
}
