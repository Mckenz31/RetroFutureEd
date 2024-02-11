import 'package:fend/pages/character_page.dart';
import 'dart:io';
import 'package:fend/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';


class C3PO extends StatefulWidget {
  const C3PO({super.key});

  @override
  State<C3PO> createState() {
    return _C3PO();
  }
}

class _C3PO extends State<C3PO> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text("C3PO"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 100.0,
            backgroundImage: AssetImage('assets/C-3PO.png'),
          ),
          SizedBox(
            height: 30.0,
            width: MediaQuery.of(context).size.width,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "C-3PO longs for more peaceful times, but his continued service to the Resistance — and his knowledge of more than seven million forms of communication — keeps the worry-prone droid in the frontlines of galactic conflict. Programmed for etiquette and protocol, Threepio was built by a young Anakin Skywalker, and has been a constant companion to astromech R2-D2. Over the years, he was involved in some of the galaxy’s most defining moments and thrilling battles. Since the Empire’s defeat, C-3PO has served Leia Organa, head of a Resistance spy ring aimed at undermining the First Order. C3PO is willing to teach you all the information that your document",
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
          Center(
            child: ElevatedButton(
              onPressed: () async {
                result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                if (result == null) {
                  print("No file selected");
                } else {
                  // setState(() {});
                  // for (var element in result!.files) {
                  //   print(element.name);
                  // }
                  File file = File(result!.files.single.path!);
                  print(file);
                  var uri = Uri.parse('http://localhost:5000/upload');
                  var request = http.MultipartRequest('POST', uri)
                    ..files.add(await http.MultipartFile.fromPath(
                      'pdf',
                      file.path,
                      contentType: MediaType('application', 'pdf'),
                    ));

                  var response = await request.send();
                  if (response.statusCode == 200) {
                    print('PDF uploaded successfully');
                  } else {
                    print('Failed to upload PDF');
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(ai: 'C-3PO'),));
                }
              },
              child: const Text("Add your PDFs"),
            ),
          ),
        ],
      ),
    );
  }
}
