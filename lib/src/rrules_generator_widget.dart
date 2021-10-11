import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rrules_generator/src/components/text_field.dart';
import 'package:rrules_generator/src/constant.dart';
import 'package:rrules_generator/src/themes/themes.dart';

class RRuleGenerator extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final padding;
  // ignore: prefer_typing_uninitialized_variables
  final titleStyle;
  const RRuleGenerator({
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
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _everyController = TextEditingController();
  final TextEditingController _endAfterController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String selectedFrequency = CString.yearly;
  RecurrenceMeta selectedMeta = RecurrenceMeta.onThe;
  String selectedMonth = CString.jan;
  String selectedDay = "1";
  String selectedWeekDay = CString.monday;
  String selectedOrdinal = CString.first;
  String selectedEnd = CString.never;
  String everyText = "0";
  String endAfter = "0";
  List<String> selectedWeekDayShort = [];
  String finalRRule = "";

  @override
  void initState() {
    super.initState();
    _startDateContoller.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _endDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _everyController.text = "0";
    _endAfterController.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        children: [
          _buildRow(CString.start, _startDateTextField()),
          const Divider(height: 40, color: Colors.grey),
          _buildRepeatSection(),
          const Divider(height: 40, color: Colors.grey),
          _buildEndSection(),
          const Divider(height: 40, color: Colors.grey),
          Text(finalRRule)
        ],
      ),
    );
  }

  _onStartDateTap() {
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
  }

  _onEndDateTap() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2050, 12, 31))
        .then((value) {
      if (value != null) {
        endDate = value;
        _endDateController.text = DateFormat('dd-MM-yyyy').format(value);
      }
    });
  }

  int _getMonthDayCount(String selectedMonth) {
    switch (selectedMonth) {
      case CString.jan:
        return 31;
      case CString.feb:
        return 30;
      case CString.mar:
        return 31;
      case CString.apr:
        return 30;
      case CString.may:
        return 31;
      case CString.jun:
        return 30;
      case CString.jul:
        return 31;
      case CString.aug:
        return 31;
      case CString.oct:
        return 30;
      case CString.nov:
        return 31;
      case CString.dec:
        return 30;
    }
    return 30;
  }

  Widget _buildEveryTextField(suffix) {
    return Row(
      children: [
        const Text(CString.every),
        const SizedBox(width: 10),
        Expanded(
          child: CTextField(
            controller: _everyController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (val) {
              if (val.isEmpty) {
                everyText = "0";
              } else {
                everyText = val;
              }

              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 10),
        Text(suffix),
      ],
    );
  }

  Widget monthDropDown() {
    return _buildDropDown(
      list: months,
      value: selectedMonth,
      onChanged: (val) {
        setState(() {
          selectedMonth = val!;
          selectedDay = "1";
        });
      },
    );
  }

  Widget dayDropDown({int? count}) {
    return _buildDropDown(
      list: List.generate(count ?? _getMonthDayCount(selectedMonth),
          (index) => (index + 1).toString()),
      value: selectedDay,
      onChanged: (val) {
        setState(() {
          selectedDay = val!;
        });
      },
    );
  }

  Widget weekDayDropDown() {
    return _buildDropDown(
        list: weekDay,
        value: selectedWeekDay,
        onChanged: (val) {
          setState(() {
            selectedWeekDay = val!;
          });
        },
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          overflow: TextOverflow.clip,
        ),
        padding: const EdgeInsets.only(left: 8, right: 0));
  }

  Widget ordinalDropDown() {
    return _buildDropDown(
        list: ordinal,
        value: selectedOrdinal,
        onChanged: (val) {
          setState(() {
            selectedOrdinal = val!;
          });
        },
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          overflow: TextOverflow.clip,
        ),
        padding: const EdgeInsets.only(left: 8, right: 0));
  }

  Widget endDropDown() {
    return _buildDropDown(
        list: endDropdownList,
        value: selectedEnd,
        onChanged: (val) {
          setState(() {
            selectedEnd = val!;
          });
        },
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          overflow: TextOverflow.clip,
        ),
        padding: const EdgeInsets.only(left: 8, right: 0));
  }

  Widget _endDateTextField() {
    return GestureDetector(
        onTap: _onEndDateTap,
        child: CTextField(
          controller: _endDateController,
          enabled: false,
          placeholder: "End Date",
        ));
  }

  Widget _buildEndOnDate() {
    return _buildRow("", _endDateTextField());
  }

  Widget _buildEndAfter() {
    return _buildRow(
        "",
        Row(
          children: [
            Expanded(
              child: CTextField(
                controller: _endAfterController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (val) {
                  if (val.isEmpty) {
                    endAfter = "0";
                  } else {
                    endAfter = val;
                  }
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 10),
            const Text(CString.executions),
          ],
        ));
  }

  Widget _buildEndMeta() {
    switch (selectedEnd) {
      case CString.after:
        return _buildEndAfter();
      case CString.onDate:
        return _buildEndOnDate();
    }
    return Container();
  }

  Widget _buildEndSection() {
    return Column(
      children: [
        _buildRow("End", endDropDown()),
        const SizedBox(height: 20),
        _buildEndMeta(),
      ],
    );
  }

  Widget _buildHourlyRepeatOn() {
    return _buildEveryTextField(CString.hours);
  }

  Widget _buildDailyRepeatOn() {
    return _buildEveryTextField(CString.days);
  }

  Widget _buildWeekDaySelection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
              7,
              (index) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (selectedWeekDayShort
                            .contains(weekDayShort[index])) {
                          setState(() {
                            selectedWeekDayShort.remove(weekDayShort[index]);
                          });
                        } else {
                          setState(() {
                            selectedWeekDayShort.add(weekDayShort[index]);
                          });
                        }
                      },
                      child: Container(
                        color:
                            selectedWeekDayShort.contains(weekDayShort[index])
                                ? Themes.primaryColor
                                : Themes.primaryColor.withOpacity(0.8),
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(weekDayShort[index],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ))),
    );
  }

  Widget _buildWeeklyRepeatOn() {
    return Column(children: [
      _buildRow("", _buildEveryTextField(CString.week)),
      const SizedBox(height: 15),
      _buildWeekDaySelection(),
    ]);
  }

  Widget _buildMonthlyOnDay() {
    return dayDropDown(count: 31);
  }

  Widget _buildMonthlyOnThe() {
    return Row(
      children: [
        Expanded(child: ordinalDropDown()),
        const SizedBox(width: 10),
        Expanded(child: weekDayDropDown()),
      ],
    );
  }

  Widget _buildMonthlyMeta() {
    switch (selectedMeta) {
      case RecurrenceMeta.on:
        return Container();
      case RecurrenceMeta.onThe:
        return _buildRow("", _buildMonthlyOnThe());
      case RecurrenceMeta.onDay:
        return _buildRow("", _buildMonthlyOnDay());
    }
  }

  Widget _buildMonthlyRepeatOn() {
    return Column(
      children: [
        _buildRow("", _buildEveryTextField(CString.month)),
        _buildRow(
          "",
          _buildRadioListTile(
            title: CString.onday,
            value: RecurrenceMeta.onDay,
            groupValue: selectedMeta,
          ),
        ),
        _buildRow(
          "",
          _buildRadioListTile(
            title: CString.onThe,
            value: RecurrenceMeta.onThe,
            groupValue: selectedMeta,
          ),
        ),
        const SizedBox(height: 15),
        _buildMonthlyMeta()
      ],
    );
  }

  Widget _buildYealyOnThe() {
    return Row(
      children: [
        Expanded(child: ordinalDropDown()),
        const SizedBox(width: 10),
        Expanded(child: weekDayDropDown()),
        const SizedBox(width: 10),
        const Text("of"),
        const SizedBox(width: 10),
        Expanded(child: monthDropDown()),
      ],
    );
  }

  Widget _buildYealyOn() {
    return Row(
      children: [
        Expanded(child: monthDropDown()),
        const SizedBox(width: 10),
        Expanded(child: dayDropDown()),
      ],
    );
  }

  Widget _buildYearlyMeta() {
    switch (selectedMeta) {
      case RecurrenceMeta.on:
        return _buildRow("", _buildYealyOn());
      case RecurrenceMeta.onThe:
        return _buildYealyOnThe();
      case RecurrenceMeta.onDay:
        break;
    }

    return Container();
  }

  Widget _buildRadioListTile(
      {required String title,
      required RecurrenceMeta value,
      required RecurrenceMeta groupValue}) {
    return RadioListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: (RecurrenceMeta? val) {
        setState(() {
          selectedMeta = val!;
        });
      },
    );
  }

  Widget _buildYearlyRepeatOn() {
    return Column(
      children: [
        _buildRow(
          "",
          _buildRadioListTile(
            title: CString.on,
            value: RecurrenceMeta.on,
            groupValue: selectedMeta,
          ),
        ),
        _buildRow(
          "",
          _buildRadioListTile(
            title: CString.onThe,
            value: RecurrenceMeta.onThe,
            groupValue: selectedMeta,
          ),
        ),
        const SizedBox(height: 15),
        _buildYearlyMeta()
      ],
    );
  }

  Widget _buildSubRepeatSaction() {
    switch (selectedFrequency) {
      case CString.yearly:
        return _buildYearlyRepeatOn();
      case CString.monthly:
        return _buildMonthlyRepeatOn();
      case CString.weekly:
        return _buildWeeklyRepeatOn();
      case CString.daily:
        return _buildRow("", _buildDailyRepeatOn());
      case CString.hourly:
        return _buildRow("", _buildHourlyRepeatOn());
    }

    return Container();
  }

  Widget _buildDropDown(
      {required List<String> list,
      required String value,
      required Function(String?)? onChanged,
      padding = const EdgeInsets.only(left: 20, right: 5),
      double? width,
      TextStyle? style}) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(7)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            style: style,
            isExpanded: true,
            items: list.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: value,
            onChanged: onChanged),
      ),
    );
  }

  Widget _buildRepeatOnDropdown() {
    return _buildDropDown(
        list: repeatOn,
        value: selectedFrequency,
        onChanged: (value) {
          setState(() {
            selectedFrequency = value!;
          });
        });
  }

  Widget _buildRepeatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(CString.repeat, _buildRepeatOnDropdown()),
        const SizedBox(height: 20),
        _buildSubRepeatSaction(),
      ],
    );
  }

  Widget _startDateTextField() {
    return GestureDetector(
        onTap: _onStartDateTap,
        child: CTextField(
          controller: _startDateContoller,
          enabled: false,
          placeholder: "Start Date",
        ));
  }

  Widget _buildRow(String title, Widget cwidget) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: widget.titleStyle,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(flex: 3, child: cwidget)
      ],
    );
  }
}
