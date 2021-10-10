import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrules_generator/src/components/text_field.dart';

class RRuleGenerator extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final padding;
  // ignore: prefer_typing_uninitialized_variables
  final titleStyle;
  RRuleGenerator({
    this.titleStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    this.padding = const EdgeInsets.all(20),
    Key? key,
  }) : super(key: key);

  @override
  State<RRuleGenerator> createState() => _RRuleGeneratorState();
}

class _RRuleGeneratorState extends State<RRuleGenerator> {
  final TextEditingController _startDateContoller = TextEditingController();

  DateTime? startDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Start",
                style: widget.titleStyle,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2050, 12, 31))
                            .then((value) {
                          if (value != null) {
                            startDate = value;
                            _startDateContoller.text = DateFormat('dd-MM-yyyy').format(value);
                          }
                        });
                      },
                      child: CTextField(
                        controller: _startDateContoller,
                        enabled: false,
                        placeholder: "Start Date",
                      )))
            ],
          )
        ],
      ),
    );
  }
}
