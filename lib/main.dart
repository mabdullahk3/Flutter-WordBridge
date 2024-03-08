import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:translator/translator.dart';

GoogleTranslator translator = GoogleTranslator();

String getLanguageCode(String language) {
  Map<String, String> languageCodes = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Italian': 'it',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Chinese': 'zh-CN',
    'Russian': 'ru',
    'Arabic': 'ar',
    'Portuguese': 'pt',
    'Bengali': 'bn',
    'Dutch': 'nl',
    'Turkish': 'tr',
    'Swedish': 'sv',
    'Danish': 'da',
    'Finnish': 'fi',
    'Norwegian': 'no',
    'Greek': 'el',
    'Urdu': 'ur'
  };

  return languageCodes[language] ?? 'Invalid language';
}

Future<String> translateText(String text, String from, String to) async {
  String fromCode = getLanguageCode(from);
  String toCode = getLanguageCode(to);

  Translation translation =
      await translator.translate(text, from: fromCode, to: toCode);

  return translation.text;
}

bool _isRightToLeft(String language) {
  List<String> rtlLanguages = ['ar', 'ur'];
  return rtlLanguages.contains(getLanguageCode(language));
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = '';
  String translatedfrom = 'English';
  String translatedto = 'English';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Center(
              child: Text(
                "WordBridge",
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
            ),
            toolbarHeight: 70,
            backgroundColor: Colors.black,
          ),
          body: SafeArea(
              child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                      decoration: const InputDecoration(
                        hintText: 'Enter text',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 25),
                        border: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.only(left: 15),
                      ),
                      onChanged: (value) {
                        setState(() {
                          text = '';
                        });
                      },
                      onSubmitted: (value) async {
                        String translatedText = await translateText(
                            value, translatedfrom, translatedto);
                        setState(() {
                          text = translatedText;
                        });
                      },
                    ),
                    const SizedBox(height: 150),
                    Center(
                      child: Container(
                        width: 350,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const Divider(
                            height: 10,
                            thickness: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          text,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25),
                          textAlign: TextAlign.start,
                          textDirection: _isRightToLeft(translatedto)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LanguageSelection();
                              },
                            ),
                          );
                          setState(() {
                            translatedfrom = result ?? translatedfrom;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(130, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          translatedfrom,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                    const SizedBox(width: 35),
                    const Icon(
                      Icons.repeat_rounded,
                    ),
                    const SizedBox(width: 30),
                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () async {
                          final result2 = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const TranslateTo();
                              },
                            ),
                          );
                          setState(() {
                            translatedto = result2 ?? translatedto;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(130, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          elevation: 5,
                        ),
                        child: Text(translatedto,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }),
                  ],
                ),
              )
            ],
          )),
        ));
  }
}

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({Key? key}) : super(key: key);

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "Translate from",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          toolbarHeight: 70,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "All languages",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('English',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'English');
                      },
                    ),
                    ListTile(
                      title: const Text('Spanish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Spanish');
                      },
                    ),
                    ListTile(
                      title: const Text('French',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'French');
                      },
                    ),
                    ListTile(
                      title: const Text('German',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'German');
                      },
                    ),
                    ListTile(
                      title: const Text('Italian',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Italian');
                      },
                    ),
                    ListTile(
                      title: const Text('Japanese',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Japanese');
                      },
                    ),
                    ListTile(
                      title: const Text('Korean',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Korean');
                      },
                    ),
                    ListTile(
                      title: const Text('Russian',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Russian');
                      },
                    ),
                    ListTile(
                      title: const Text('Arabic',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Arabic');
                      },
                    ),
                    ListTile(
                      title: const Text('Urdu',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Urdu');
                      },
                    ),
                    ListTile(
                      title: const Text('Portuguese',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Portuguese');
                      },
                    ),
                    ListTile(
                      title: const Text('Bengali',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Bengali');
                      },
                    ),
                    ListTile(
                      title: const Text('Dutch',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Dutch');
                      },
                    ),
                    ListTile(
                      title: const Text('Turkish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Turkish');
                      },
                    ),
                    ListTile(
                      title: const Text('Swedish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Swedish');
                      },
                    ),
                    ListTile(
                      title: const Text('Danish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Danish');
                      },
                    ),
                    ListTile(
                      title: const Text('Finnish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Finnish');
                      },
                    ),
                    ListTile(
                      title: const Text('Norwegian',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Norwegian');
                      },
                    ),
                    ListTile(
                      title: const Text('Greek',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Greek');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TranslateTo extends StatefulWidget {
  const TranslateTo({super.key});

  @override
  State<TranslateTo> createState() => _TranslateToState();
}

class _TranslateToState extends State<TranslateTo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "Translate to",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          toolbarHeight: 70,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "All languages",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('English',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'English');
                      },
                    ),
                    ListTile(
                      title: const Text('Spanish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Spanish');
                      },
                    ),
                    ListTile(
                      title: const Text('French',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'French');
                      },
                    ),
                    ListTile(
                      title: const Text('German',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'German');
                      },
                    ),
                    ListTile(
                      title: const Text('Italian',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Italian');
                      },
                    ),
                    ListTile(
                      title: const Text('Japanese',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Japanese');
                      },
                    ),
                    ListTile(
                      title: const Text('Korean',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Korean');
                      },
                    ),
                    ListTile(
                      title: const Text('Russian',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Russian');
                      },
                    ),
                    ListTile(
                      title: const Text('Arabic',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Arabic');
                      },
                    ),
                    ListTile(
                      title: const Text('Urdu',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Urdu');
                      },
                    ),
                    ListTile(
                      title: const Text('Portuguese',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Portuguese');
                      },
                    ),
                    ListTile(
                      title: const Text('Bengali',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Bengali');
                      },
                    ),
                    ListTile(
                      title: const Text('Dutch',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Dutch');
                      },
                    ),
                    ListTile(
                      title: const Text('Turkish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Turkish');
                      },
                    ),
                    ListTile(
                      title: const Text('Swedish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Swedish');
                      },
                    ),
                    ListTile(
                      title: const Text('Danish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Danish');
                      },
                    ),
                    ListTile(
                      title: const Text('Finnish',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Finnish');
                      },
                    ),
                    ListTile(
                      title: const Text('Norwegian',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Norwegian');
                      },
                    ),
                    ListTile(
                      title: const Text('Greek',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      onTap: () {
                        Navigator.pop(context, 'Greek');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
