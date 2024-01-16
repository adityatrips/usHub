import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
              tileColor: const Color.fromARGB(255, 255, 163, 26),
              isThreeLine: true,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message['text'].toString(),
                  style: const TextStyle(
                    color: Color(0xff1b1b1b),
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 9,
                  right: 8,
                ),
                child: Text(
                  message['sender'].toString(),
                  style: const TextStyle(
                    color: Color(0xff1b1b1b),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
/* Text(
  message['text'].toString().toUpperCase(),
  style: const TextStyle(
    color: Color.fromARGB(255, 255, 163, 26),
    fontSize: 10,
    fontWeight: FontWeight.w900,
  ),
),
Text(
  message['sender'].toString().toUpperCase(),
  style: const TextStyle(
    color: Color.fromARGB(255, 255, 163, 26),
    fontSize: 10,
    fontWeight: FontWeight.w900,
  ),
),
Text(
  DateFormat('d-MM-y').add_jm().format(
    DateTime.fromMillisecondsSinceEpoch(
      message['timestamp'],
    ),
  ),
  style: const TextStyle(
    color: Color.fromARGB(255, 255, 163, 26),
    fontSize: 10,
    fontWeight: FontWeight.w900,
  ),
) */
