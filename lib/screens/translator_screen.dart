import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:langify/utils/color_utils.dart';

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
         backgroundColor: hexStringToColor("132D46"),
         foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: 'Enter text',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
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
                ),
                IconButton(
                  icon: Icon(Icons.swap_horiz, size: 32, color: Colors.blueGrey),
                  onPressed: () {
                    // Logic to swap languages
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _translateText,
                child: Text('Translate'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Translated Text:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _translatedText,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}