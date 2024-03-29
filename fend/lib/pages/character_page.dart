import 'package:fend/data.dart';
import 'package:fend/pages/chat.dart';
import 'package:fend/pages/story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CharacterPage extends StatelessWidget {
  const CharacterPage({Key? key});

  @override
  Widget build(BuildContext context) {
    // var data = Data().imageDictionary.keys.toList();
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Retro Characters'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // crossAxisSpacing: 8.0,
          // mainAxisSpacing: 8.0,
        ),
        itemCount: Data().imageDictionary.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              var result = http.post(
                Uri.parse('http://localhost:5000/members'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'name': Data().imageDictionary.keys.toList()[index],
                }),
              );
              print(result);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Chat(index: index)));
            },
            child: Container(
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.blue),
              //   color: Colors.white,
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/characters/${Data().imageDictionary.values.toList()[index]}'),
                    radius: 30.0,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    Data().imageDictionary.keys.toList()[index],
                    style: const TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
