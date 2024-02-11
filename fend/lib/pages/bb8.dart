import 'package:fend/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/scheduler.dart';

class BB8 extends StatefulWidget {
  const BB8({super.key});

  @override
  State<BB8> createState() {
    return _BB8();
  }
}

class _BB8 extends State<BB8> {
  FilePickerResult? result;
  TextEditingController textEditingController = TextEditingController();
  String fileNames = '';

  final snackBar = SnackBar(
    content: const Text('IMPORTANT!!!!   Enter all the details and then add a pdf'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 86, 86),
        title: const Text("BB-8"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 100.0,
            backgroundImage: AssetImage('assets/BB-8.png'),
          ),
          SizedBox(
            height: 30.0,
            width: MediaQuery.of(context).size.width,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'A skittish but loyal astromech, BB-8 accompanied Poe Dameron on many missions for the Resistance, helping to keep his X-wing in working order. When Poe’s mission to Jakku ended with his capture by the First Order, BB-8 fled into the desert with a vital clue to the location of Luke Skywalker. He rejoined Poe in time for the attack on Starkiller Base, then helped Rey locate Skywalker’s planet of exile. As the Resistance rebuilt its forces after the Battle of Crait, BB-8 helped both Poe and Rey.',
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  cursorColor: const Color.fromARGB(255, 240, 107, 107),
                  controller: textEditingController,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 240, 107, 107)),
                  decoration: const InputDecoration(
                    labelText:
                        'Enter job role, description and responsibilities',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 240, 107, 107)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 240, 107,
                              107)), // Change border color when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 240, 107,
                              107)), // Change border color when enabled
                    ),
                    hoverColor: Color.fromARGB(255, 240, 107, 107),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    result = await FilePicker.platform
                        .pickFiles(allowMultiple: true);
                    if (result == null) {
                      print("No file selected");
                    } else {
                      setState(() {
                        fileNames =
                            result!.files.map((file) => file.name).join(', ');
                      });
                      if (result != null &&
                          textEditingController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chat(ai: 'BB-8'),
                          ),
                        );
                        textEditingController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 240, 107, 107)),
                  ),
                  child: const Text(
                    "Add your PDFs",
                    style: TextStyle(color: Color.fromARGB(255, 240, 107, 107)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  fileNames.isNotEmpty
                      ? 'Files added: $fileNames'
                      : 'No files selected',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
