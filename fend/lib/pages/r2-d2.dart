import 'package:fend/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class R2D2 extends StatefulWidget {
  const R2D2({super.key});

  @override
  State<R2D2> createState() {
    return _R2D2();
  }
}

class _R2D2 extends State<R2D2> {
  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("R2D2"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 100.0,
            backgroundImage: AssetImage('assets/R2-D2.png'),
          ),
          SizedBox(
            height: 30.0,
            width: MediaQuery.of(context).size.width,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "A reliable and versatile astromech droid, R2-D2 has served Padmé Amidala, Anakin Skywalker, and Luke Skywalker in turn, showing great bravery in rescuing his masters and their friends from many perils. A skilled starship mechanic and fighter pilot's assistant, he has an unlikely but enduring friendship with the fussy protocol droid C-3PO.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  decorationStyle: TextDecorationStyle.solid),
            ),
          ),
          SizedBox(
            height: 15.0,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(
                color: Colors.deepPurple
              ),
              cursorColor: Colors.white,
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Attach the link you want to learn from",
                hintStyle: const TextStyle(color: Color.fromARGB(255, 95, 93, 216)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    var result = http.post(
                      Uri.parse('http://localhost:5000/handle_userinput'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        'title': messageController.text,
                      }),
                    );
                    print(result);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(ai: 'R2-D2',)));
                    messageController.clear();     
                  },            
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
