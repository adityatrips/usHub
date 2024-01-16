import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key, required this.messages});

  final List<QueryDocumentSnapshot<Object?>> messages;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    var messages = widget.messages;
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          var message = messages[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: ListTile(
              shape: const  RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              tileColor: Colors.blue[100],
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message['text'].toString(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 13, 71, 161),
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 8,
                  right: 8,
                ),
                child: Column(
                  children: [
                    Text(
                      "${message['sender']} sent this on",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 13, 71, 161),
                      ),
                    ),
                    Text(
                      "${DateFormat('MMM dd, yyyy (hhmm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          message['timestamp'],
                        ),
                      )} hours)",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 13, 71, 161),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
