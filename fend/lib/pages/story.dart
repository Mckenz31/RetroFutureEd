import 'package:flutter/material.dart';

class GameDialoguePage extends StatelessWidget {
  void _onDialogueOptionTap(BuildContext context, String option) {
    // TODO: Implement your dialogue option tap logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You selected: $option'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Replace with your own background image
          Image.asset(
            'assets/characters/stephen_hawking.jpg',
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: DialogueCard(
              characterName: "KENNA RYS",
              dialogue: "Let me say...",
              options: [
                DialogueOption(
                  text: "Congratulations, Mother.",
                  onTap: () => _onDialogueOptionTap(context, "Congratulations, Mother."),
                ),
                DialogueOption(
                  text: "This is a mistake.",
                  onTap: () => _onDialogueOptionTap(context, "This is a mistake."),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DialogueCard extends StatelessWidget {
  final String characterName;
  final String dialogue;
  final List<DialogueOption> options;

  const DialogueCard({
    Key? key,
    required this.characterName,
    required this.dialogue,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              characterName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              dialogue,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            ...options,
          ],
        ),
      ),
    );
  }
}

class DialogueOption extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const DialogueOption({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.blue.shade300,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
