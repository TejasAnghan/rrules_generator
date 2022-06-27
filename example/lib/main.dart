import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:rrules_generator/rrules_generator.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<RRuleGeneratorState> globalKey = GlobalKey<RRuleGeneratorState>();

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

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String rrule = "";
  String viewRule = '';
  var stringToRrule = RecurrenceRule.fromString(
    "FREQ=DAILY;UNTIL=20221230T183000Z;DTSTART=20220629T183000Z;INTERVAL=2",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 15, 8, 0),
              child: Text(
                "Generate R Rule",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            RRuleGenerator(
              onChanged: (String? val) {
                if (val != null) {
                  setState(() {
                    rrule = val;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Text(viewRule),
            InkWell(
              onTap: () {
                setState(() {
                  viewRule = rrule;
                  log(viewRule);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4186E4),
                  border: Border.all(color: Colors.white, width: .4),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Text("Generate R Rule"),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                setState(() {
                  stringToRrule = RecurrenceRule.fromString(
                    viewRule,
                  );
                  log(stringToRrule.toString());
                  globalKey.currentState?.updateRrule(stringToRrule);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4186E4),
                  border: Border.all(color: Colors.white, width: .4),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Text("Edit R Rule"),
              ),
            ),
            RRuleGenerator(
              key: globalKey,
              rrule: stringToRrule,
              onChanged: (String? val) {
                if (val != null) {
                  setState(() {
                    // rrule = val;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
