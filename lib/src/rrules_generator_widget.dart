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
  final textStyle;
  const RRuleGenerator({
    this.textStyle = const TextStyle(color: Color(0xFF969696), fontSize: 16),
    this.titleStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.padding = const EdgeInsets.all(20),
    Key? key,
  }) : super(key: key);

  @override
  State<RRuleGenerator> createState() => _RRuleGeneratorState();
}

class _RRuleGeneratorState extends State<RRuleGenerator> {
  final TextEditingController _endAfterController = TextEditingController();
  final TextEditingController _startDateContoller = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _everyController = TextEditingController();

  RecurrenceMeta selectedMeta = RecurrenceMeta.onThe;
  List<String> selectedWeekDayShort = [];

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  
  String selectedFrequency = CString.yearly;
  String selectedWeekDay = CString.monday;
  String selectedOrdinal = CString.first;
  String selectedMonth = CString.jan;
  String selectedEnd = CString.never;
  String selectedDay = "1";
  String finalRRule = "";
  String everyText = "0";
  String endAfter = "0";

  @override
  void initState() {
    super.initState();
    _startDateContoller.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _endDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _endAfterController.text = "0";
    _everyController.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      color: const Color(0xFFf8f8f8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildStartSection(),
            const SizedBox(height: 20),
            _buildMeta(),
            const SizedBox(height: 30),
            _buildEndSection()
          ],
        ),
      ),
    );
  }

  Widget _buildEndOnDate() {
    return buildColumn(CString.onDate, _endDateTextField());
  }

  Widget _endAfterTextField() {
    return Row(
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
      ],
    );
  }

  Widget _buildEndAfter() {
    return buildColumn(CString.executions, _endAfterTextField());
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
    return cContainer(
      vPadding: 20,
      child: Row(
        children: [
          buildColumn("End", endDropDown()),
          const SizedBox(width: 10),
          _buildEndMeta(),
        ],
      ),
    );
  }

  Widget _buildHourlyMeta() {
    return Column(
      children: [
        cContainer(
          child: Row(
            children: [
              buildColumn("Every", _buildEveryTextField(CString.hours))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyMeta() {
    return Column(
      children: [
        cContainer(
          child: Row(
            children: [
              buildColumn("Every", _buildEveryTextField(CString.days))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDaySelector() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: List.generate(
                7,
                (index) => Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (selectedWeekDayShort
                              .contains(weekDayShort[index])) {
                            selectedWeekDayShort.remove(weekDayShort[index]);
                          } else {
                            selectedWeekDayShort.add(weekDayShort[index]);
                          }
                          setState(() {});
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.only(right: 2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: selectedWeekDayShort
                                      .contains(weekDayShort[index])
                                  ? const Color(0xFF0359DA)
                                  : const Color(0xFF0359DA).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            weekDayShort[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )),
          ),
        )
      ],
    );
  }

  Widget _buildWeeklyMeta() {
    return Column(
      children: [
        cContainer(
          child: Row(
            children: [
              buildColumn("Every", _buildEveryTextField(CString.week))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        _buildWeekDaySelector(),
      ],
    );
  }

  Widget buildMonthlyRepeatOn() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Row(
          children: [
            buildColumn("Date", monthDropDown()),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildMonthlyRepeatOnThe() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Row(
          children: [
            buildColumn("Ordinal No.", ordinalDropDown()),
            const SizedBox(width: 10),
            buildColumn("Day", weekDayDropDown()),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildMonthlyMeta() {
    return Column(
      children: [
        cContainer(
          child: Row(
            children: [
              buildColumn("Every", _buildEveryTextField(CString.month))
            ],
          ),
        ),
        const SizedBox(height: 20),
        cSwitchTile(
            CString.onday, buildMonthlyRepeatOn(), RecurrenceMeta.onDay),
        const SizedBox(height: 20),
        cSwitchTile(
            CString.onThe, buildMonthlyRepeatOnThe(), RecurrenceMeta.onThe),
      ],
    );
  }

  Widget buildYearlyRepeatOnThe() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Row(
          children: [
            buildColumn("Ordinal No.", ordinalDropDown()),
            const SizedBox(width: 10),
            buildColumn("Day", dayDropDown()),
          ],
        ),
        const SizedBox(height: 15),
        Row(children: [buildColumn("Of Month", monthDropDown())]),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildYearlyRepeatOn() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Row(
          children: [
            buildColumn("Month", monthDropDown()),
            const SizedBox(width: 10),
            buildColumn("Date", dayDropDown()),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildYearlyMeta() {
    return Column(
      children: [
        cSwitchTile(CString.on, buildYearlyRepeatOn(), RecurrenceMeta.on),
        const SizedBox(height: 20),
        cSwitchTile(
            CString.onThe, buildYearlyRepeatOnThe(), RecurrenceMeta.onThe),
      ],
    );
  }

  Widget _buildMeta() {
    switch (selectedFrequency) {
      case CString.yearly:
        return _buildYearlyMeta();
      case CString.monthly:
        return _buildMonthlyMeta();
      case CString.weekly:
        return _buildWeeklyMeta();
      case CString.daily:
        return _buildDailyMeta();
      case CString.hourly:
        return _buildHourlyMeta();
    }

    return Container();
  }

  Widget _buildStartSection() {
    return cContainer(
      child: Row(
        children: [
          buildColumn(CString.start, _startDateTextField()),
          const SizedBox(width: 10),
          buildColumn(CString.repeat, _buildFrequencyDropdown()),
        ],
      ),
    );
  }

  Widget buildColumn(title, cwidget) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: widget.titleStyle),
          const SizedBox(height: 10),
          cwidget,
        ],
      ),
    );
  }

  Widget cContainer(
      {required Widget child, double? hPadding, double? vPadding}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: hPadding ?? 15, vertical: vPadding ?? 15),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 20),
      ]),
      child: child,
    );
  }

  Widget cSwitchTile(
    String title,
    Widget child,
    RecurrenceMeta type,
  ) {
    return cContainer(
      hPadding: 15,
      vPadding: 5,
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: widget.titleStyle),
              const Spacer(),
              Switch(
                  activeColor: Colors.green,
                  value: type == selectedMeta,
                  onChanged: (value) {
                    if (value) {
                      setState(() {
                        selectedMeta = type;
                      });
                    }
                  })
            ],
          ),
          if (type == selectedMeta) child,
        ],
      ),
    );
  }

  //============================================================================

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
      style: widget.textStyle,
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
      style: widget.textStyle,
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
        style: widget.textStyle,
        list: weekDay,
        value: selectedWeekDay,
        onChanged: (val) {
          setState(() {
            selectedWeekDay = val!;
          });
        },
        padding: const EdgeInsets.only(left: 8, right: 0));
  }

  Widget ordinalDropDown() {
    return _buildDropDown(
        style: widget.textStyle,
        list: ordinal,
        value: selectedOrdinal,
        onChanged: (val) {
          setState(() {
            selectedOrdinal = val!;
          });
        },
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
      style: widget.textStyle,
      padding: const EdgeInsets.only(left: 8, right: 0),
    );
  }

  Widget _endDateTextField() {
    return GestureDetector(
        onTap: _onEndDateTap,
        child: CTextField(
          textStyle: widget.textStyle,
          controller: _endDateController,
          enabled: false,
          placeholder: "End Date",
        ));
  }

  Widget _buildFrequencyDropdown() {
    return _buildDropDown(
        list: repeatOn,
        value: selectedFrequency,
        style: widget.textStyle,
        onChanged: (value) {
          setState(() {
            selectedFrequency = value!;
            selectedMeta = RecurrenceMeta.onThe;
          });
        });
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
          border: Border.all(color: Colors.black),
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
          onChanged: onChanged,
          // icon:const Icon(Icons.arrow_drop_down_circle_sharp),
        ),
      ),
    );
  }

  Widget _startDateTextField() {
    return GestureDetector(
        onTap: _onStartDateTap,
        child: CTextField(
          controller: _startDateContoller,
          enabled: false,
          textStyle: widget.textStyle,
          placeholder: "Start Date",
        ));
  }
}
