import 'package:fend/data.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {

  Chat({super.key, required this.index});

  int index;

  @override
  State<Chat> createState() {
    return _ChatScreen();
  }
}

class _ChatScreen extends State<Chat> {
  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print(widget.index);
    return Scaffold(
      appBar: AppBar(
        title:  Text(Data().imageDictionary.keys.toList()[widget.index]),
        centerTitle: true,
        // backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Row(
                    mainAxisAlignment: message.isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!message.isSentByMe)
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/characters/${Data().imageDictionary.values.toList()[widget.index]}'),
                          radius: 20,
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: message.isSentByMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(color: message.isSentByMe ? Colors.white : Colors.black),
                        ),
                      ),
                      if (message.isSentByMe)
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Text(
                            'M',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  );
                },
        
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.insert(0, Message(messageController.text, true));        
        messages.insert(0, Message("Need to connect it to the backend soon", false)); 
      });
      messageController.clear();
    }
  }
}

class Message {
  String text;
  bool isSentByMe;

  Message(this.text, this.isSentByMe);
}