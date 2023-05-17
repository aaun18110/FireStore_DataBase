import 'package:firestore_database/Services/error_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Utils/Routes/route_name.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostViewModel extends StatefulWidget {
  const PostViewModel({super.key});

  @override
  State<PostViewModel> createState() => _PostViewModelState();
}

class _PostViewModelState extends State<PostViewModel> {
  final editController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final docFireStore =
      FirebaseFirestore.instance.collection('Post').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('Post');

  @override
  void dispose() {
    super.dispose();
    editController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  ErrorMessage.toastMessage("Logout Sucessfully");
                  Navigator.pushNamed(context, RouteName.loginViewModel);
                }).onError((error, stackTrace) {
                  ErrorMessage.toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: docFireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                      child: SpinKitWaveSpinner(
                        color: Colors.lime,
                        size: 50,
                        // duration: Duration(milliseconds: 1000),
                      ),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return ErrorMessage.toastMessage(snapshot.error.toString());
                }

                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        String title =
                            snapshot.data!.docs[index]['title'].toString();
                        String id = snapshot.data!.docs[index]['id'].toString();
                        return Card(
                          child: ListTile(
                            title: Text(
                                snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(
                                snapshot.data!.docs[index]['id'].toString()),
                            trailing: Expanded(
                              child: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          updatePost(title, id);
                                        },
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {
                                          ref.doc(id).delete();
                                          ErrorMessage.toastMessage(
                                              "Delete Sucessfully");
                                        },
                                        icon: const Icon(Icons.delete_outline))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lime.shade400,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteName.addPostViewModel);
              },
              icon: const Icon(
                Icons.add_box,
                size: 36,
              )),
        ),
      ),
    );
  }

  Future<void> updatePost(String title, String? id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Post"),
            content: TextFormField(
              maxLines: 2,
              controller: editController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.lime, width: 2),
                      borderRadius: BorderRadius.circular(12))),
            ),
            actions: [
              InkWell(
                  onTap: () {
                    ref.doc(id).update({
                      "title": editController.text.toString(),
                    }).then((value) {
                      ErrorMessage.toastMessage("Update Post Sucessfully");
                      Navigator.pushNamed(context, RouteName.postViewModel);
                    }).onError((error, stackTrace) {
                      ErrorMessage.toastMessage(error.toString());
                    });
                  },
                  child: const Text("Ok")),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.postViewModel);
                  },
                  child: const Text("Cancel"))
            ],
          );
        });
  }
}
