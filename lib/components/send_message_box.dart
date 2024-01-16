import 'package:anjali/util/global_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessageBox extends StatefulWidget {
  const SendMessageBox({super.key});

  @override
  State<SendMessageBox> createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  final TextEditingController _textEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const  RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      title: TextField(
        minLines: null,
        textAlignVertical: TextAlignVertical.center,
        controller: _textEditingController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 13, 71, 161),
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 13, 71, 161),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          alignLabelWithHint: true,
          hintText: 'Send your love, start typing...',
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 13, 71, 161),
          ),
          suffix: SizedBox(
            width: 100,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 13, 71, 161),
                foregroundColor: Colors.blue[100],
              ),
              child: const Text("Send!"),
              onPressed: () => _sendMessage(),
            ),
          ),
        ),
        style: const TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 13, 71, 161),
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25,
        ),
        autocorrect: true,
        textCapitalization: TextCapitalization.sentences,
        enableSuggestions: true,
      ),
    );
  }

  void _sendMessage() async {
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('messages').add({
          'text': text,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toInt(),
          'sender': _auth.currentUser?.displayName,
        });
        _textEditingController.clear();
      } catch (e) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 2000),
            closeIconColor: Colors.white,
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            content: Text(
              'Failed to send message. Please try again.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        );
      }
    }
  }
}
