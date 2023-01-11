import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ios_doc_scanner/flutter_ios_doc_scanner.dart';
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String>? _filePaths;
  final _plugin = FlutterIOSDocScanner();
  bool _processing = false;
  PlatformException? _exception;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_processing == false)
              TextButton(
                onPressed: () async {
                  setState(() => _processing = true);
                  try {
                    //
                    _filePaths?.clear();

                    final files = await _plugin.pickDocument("");

                    setState(() {
                      _filePaths = files;
                    });
                  } on PlatformException catch (e) {
                    setState(() {
                      _exception = e;
                    });
                  }

                  setState(() => _processing = false);

                  //
                },
                child: const Text('Scan'),
              )
            else
              const Center(child: CircularProgressIndicator()),
            if (_exception != null) ...[
              const Text('Exception'),
              Text(_exception?.code ?? 'code'),
              Text(_exception?.message ?? 'message')
            ],
            if (_filePaths != null)
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      cacheExtent: 100,
                      addAutomaticKeepAlives: true,
                      restorationId: "as",
                      itemCount: _filePaths?.length,
                      itemBuilder: (context, index) => NewWidget(
                          key: ObjectKey(index.toString()),
                          filePaths:
                              _filePaths?[index].replaceFirst('file://', '') ??
                                  '')))
          ],
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
    required String filePaths,
  })  : _filePaths = filePaths,
        super(key: key);

  final String _filePaths;

  @override
  Widget build(BuildContext context) {
    return Image(key: key, image: FileImage(File(_filePaths), scale: 0.5));
  }
}
