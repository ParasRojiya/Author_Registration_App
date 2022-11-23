import 'package:author_registration/helpers/cloud_storage_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../globals/globals.dart';
import '../helpers/cloud_firestore_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Author Registration"),
        centerTitle: true,
        backgroundColor: Colors.teal.withOpacity(0.7),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('add_or_edit_author_screen');
        },
        backgroundColor: Colors.teal.withOpacity(0.7),
        child: const Icon(Icons.add),
      ),
      body: Container(
        height: height,
        width: width,
        child: StreamBuilder<QuerySnapshot>(
          stream: CloudFirestoreHelper.cloudFirestoreHelper.fetchAllRecords(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error:${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot? documents = snapshot.data;
              List<QueryDocumentSnapshot> data = documents!.docs;

              if (data.isEmpty) {
                Global.currentAuthorId = "1";
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.menu_book_outlined, size: 76),
                      SizedBox(height: 12),
                      Text(
                        "No Author Registered Yet...",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                int authorId = int.parse(data.last.id);
                authorId++;
                Global.currentAuthorId = authorId.toString();

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: data
                        .map((e) => Container(
                              height: 240,
                              margin: const EdgeInsets.all(12),
                              width: width * 0.95,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: const Offset(0, 0),
                                    ),
                                  ]),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        height: 168,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "${e['imageURL']}"),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 180,
                                        width: width * 0.55,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "${e['name']}",
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "${e['book']}",
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Global.currentUpdateId = e.id;

                                            Navigator.of(context).pushNamed(
                                                'add_or_edit_author_screen',
                                                arguments: e);
                                          },
                                          icon: const Icon(Icons.edit),
                                          color: Colors.blue),
                                      IconButton(
                                        onPressed: () async {
                                          await CloudStorageHelper
                                              .cloudStorageHelper
                                              .deleteImage(name: e['book']);
                                          await CloudFirestoreHelper
                                              .cloudFirestoreHelper
                                              .deleteRecord(id: e.id);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Author Data Deleted Successfully...")),
                                          );
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
