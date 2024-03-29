import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OurStory extends StatefulWidget {
  const OurStory({super.key});

  @override
  State<OurStory> createState() => _OurStoryState();
}

class _OurStoryState extends State<OurStory> {
  late List<String> poems;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("poems").get();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("poems").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {}

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final poems = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: poems.length,
              itemBuilder: (context, index) {
                final poem = poems[index];

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: ListTile(
                        shape: const  RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        tileColor: Colors.blue[100],
                        isThreeLine: true,
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            poem['poem'].toString(),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 13, 71, 161),
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                          ),
                          child: Text(
                            'With love, \n${poem["addedBy"]}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 13, 71, 161),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
                // return Container(
                //   margin: const EdgeInsets.only(bottom: 10),
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Color.fromARGB(255, 13, 71, 161),
                //     ),
                //     // color:
                //     borderRadius: const BorderRadius.all(
                //       Radius.circular(16),
                //     ),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(16),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: [
                //         Text(
                //           poem['poem'].toString(),
                //           style: const TextStyle(
                //             fontSize: 14,
                //             color: Color.fromARGB(255, 13, 71, 161),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(top: 16),
                //           child:
                //         )
                //       ],
                //     ),
                //   ),
                // );
              },
            );
          },
        ),
      ),
    );
  }
}
