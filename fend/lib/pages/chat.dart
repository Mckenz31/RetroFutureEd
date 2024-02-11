import 'package:fend/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chat extends StatefulWidget {
  Chat({super.key, this.index, this.ai});

  int? index;
  String? ai;

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
        title: widget.index != null
            ? Text(Data().imageDictionary.keys.toList()[widget.index!])
            : Text(widget.ai!),
        centerTitle: true,
        // backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/${widget.ai}.png'),
                fit: BoxFit.cover)),
        child: Padding(
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
                      mainAxisAlignment: message.isSentByMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!message.isSentByMe)
                          CircleAvatar(
                            backgroundImage: widget.index != null
                                ? AssetImage(
                                    'assets/characters/${Data().imageDictionary.values.toList()[widget.index!]}')
                                : AssetImage('assets/${widget.ai}.png'),
                            radius: 20,
                          ),
                        Flexible(
                          // Wrap the message container in a Flexible widget
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: message.isSentByMe
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(
                                  color: message.isSentByMe
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                        if (message.isSentByMe)
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: Text(
                              'M',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
      ),
    );
  }

  // void _sendMessage() {
  //   if (messageController.text.isNotEmpty) {
  //     setState(() {
  //       messages.insert(0, Message(messageController.text, true));
  //       var result = http.post(
  //         Uri.parse('http://localhost:5000/process_question'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(<String, String>{
  //           'question': messageController.text,
  //         }),
  //       );
  //       print(result);
  //     });
  //     messageController.clear();
  //   }
  // }

  void _sendMessage() async {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.insert(0, Message(messageController.text, true));
      });
      String temp = messageController.text;
      messageController.clear();
      // Sending HTTP POST request asynchronously and waiting for the response
      var response = await http.post(
        Uri.parse('http://localhost:5000/process_question'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'question': temp,
          'personality': widget.index != null ? Data().imageDictionary.keys.toList()[widget.index!] : widget.ai!
        }),
      );
      // Handling the response
      if (response.statusCode == 200) {
        // Parsing the JSON response
        var jsonResponse = jsonDecode(response.body);
        var responseData = jsonResponse['response'];

        // Adding the response message to the chat
        setState(() {
          messages.insert(0, Message(responseData, false));
        });
      } else {
        // Request failed
        print('Failed with status code: ${response.statusCode}');
        // You can handle the failure here, for example, show an error message
      }
    }
  }
}

class Message {
  String text;
  bool isSentByMe;

  Message(this.text, this.isSentByMe);
}
