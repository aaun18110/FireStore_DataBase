import 'package:firestore_database/Services/error_services.dart';
import 'package:flutter/material.dart';
import '../../Model/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostViewModel extends StatefulWidget {
  const AddPostViewModel({super.key});

  @override
  State<AddPostViewModel> createState() => _AddPostViewModelState();
}

class _AddPostViewModelState extends State<AddPostViewModel> {
  final docFireStore = FirebaseFirestore.instance.collection('Post');
  final addPostController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    addPostController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: TextFormField(
                maxLines: 4,
                controller: addPostController,
                decoration: InputDecoration(
                    hintText: "what's in your mind?",
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.lime,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please fill this field";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Button(
              title: "Add Post",
              loading: loading,
              onpress: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  docFireStore.doc(id).set({
                    'title': addPostController.text.toString(),
                    "id": id,
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    addPostController.clear();
                    ErrorMessage.toastMessage("Post Add sucessfully");
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    ErrorMessage.toastMessage(error.toString());
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
