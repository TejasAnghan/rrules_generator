


[example/lib/main.dart](https://github.com/TejasAnghan/rrules_generator/tree/main/example/lib/main.dart)

# example

```dart

import 'package:flutter/material.dart';
import 'package:rrules_generator/rrules_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RRules Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'RRules Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          RRuleGenerator(
            onChanged: (String rrule) => print(rrule),
            // activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

```

