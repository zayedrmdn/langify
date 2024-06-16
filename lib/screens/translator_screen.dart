import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final translator = GoogleTranslator();
  final TextEditingController _inputController = TextEditingController();
  String _translatedText = "";
  String _selectedLanguageCode = 'es'; // Default language code
  final List<Map<String, String>> _languages = [
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'English', 'code': 'en'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'German', 'code': 'de'},
    {'name': 'Italian', 'code': 'it'},
    {'name': 'Japanese', 'code': 'ja'},
    {'name': 'Korean', 'code': 'ko'},
    {'name': 'Russian', 'code': 'ru'},
    {'name': 'Chinese', 'code': 'zh'},
    {'name': 'Arabic', 'code': 'ar'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Portuguese', 'code': 'pt'},
    {'name': 'Dutch', 'code': 'nl'},
    {'name': 'Swedish', 'code': 'sv'},
    {'name': 'Turkish', 'code': 'tr'},
    {'name': 'Polish', 'code': 'pl'},
    {'name': 'Romanian', 'code': 'ro'},
    {'name': 'Hebrew', 'code': 'he'},
    {'name': 'Indonesian', 'code': 'id'},
    {'name': 'Vietnamese', 'code': 'vi'},
    {'name': 'Thai', 'code': 'th'},
    {'name': 'Malay', 'code': 'ms'},
    
    // Add more languages and their codes here
  ];

  void _translateText() async {
    final inputText = _inputController.text;
    if (inputText.isNotEmpty) {
      final translation = await translator.translate(inputText, to: _selectedLanguageCode);
      setState(() {
        _translatedText = translation.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedLanguageCode,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguageCode = newValue!;
                });
              },
              items: _languages.map<DropdownMenuItem<String>>((Map<String, String> language) {
                return DropdownMenuItem<String>(
                  value: language['code'],
                  child: Text(language['name']!),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate'),
            ),
            SizedBox(height: 20),
            Text(
              'Translated Text:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _translatedText,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}