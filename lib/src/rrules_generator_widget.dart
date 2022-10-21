import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';
import 'package:rrules_generator/src/components/text_field.dart';
import 'package:rrules_generator/src/constant.dart';
import 'package:rrule/src/by_week_day_entry.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

final df = DateFormat('yyyyMMddTHHmmss');

// ignore: must_be_immutable
class RRuleGenerator extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final padding;

  // ignore: prefer_typing_uninitialized_variables
  final titleStyle;

  // ignore: prefer_typing_uninitialized_variables
  final textStyle;

  RecurrenceRule? rrule;

  Color activeSwitchColor;

  final Function(String?) onChanged;

  RRuleGenerator({
    required this.onChanged,
    this.rrule,
    this.activeSwitchColor = Colors.green,
    this.textStyle = const TextStyle(color: Color(0xFF969696), fontSize: 16),
    this.titleStyle = const TextStyle(color: Colors.black, fontSize: 16),
    this.padding = const EdgeInsets.all(20),
    Key? key,
  }) : super(key: key);

  @override
  State<RRuleGenerator> createState() => RRuleGeneratorState();
}

class RRuleGeneratorState extends State<RRuleGenerator> {
  //controllers
  final TextEditingController _endAfterController = TextEditingController();
  final TextEditingController _startDateContoller = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _everyController = TextEditingController();

  //
  RecurrenceMeta selectedMeta = RecurrenceMeta.onThe;
  List<String> selectedWeekDayShort = [];

  // Date variables
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  // String variables
  String selectedFrequency = CString.yearly;
  String selectedWeekDay = CString.monday;
  String selectedOrdinal = CString.first;
  String selectedMonth = CString.jan;
  String selectedEnd = CString.never;
  String selectedDay = "1";
  String finalRRule = "";
  String? everyText = "1";
  String? endAfter = "1";
  String rruleText = "";

  @override
  void initState() {
    super.initState();
    _everyController.text = "1";
    if (widget.rrule != null) {
      updateRrule(widget.rrule!);
    }
    _startDateContoller.text = DateFormat('dd-MM-yyyy HH : mm').format(startDate);
    _endDateController.text = DateFormat('dd-MM-yyyy').format(endDate);
    _endAfterController.text = "1";
  }

  updateRrule(RecurrenceRule rrule) {
    setState(() {
      if (rrule.startDate != null) {
        startDate = rrule.startDate!.toLocal();
      }
      if (rrule.until != null) {
        endDate = rrule.until!.toLocal();
        selectedEnd = CString.onDate;
      }
      if (rrule.frequency != null) {
        if (rrule.frequency.toString() == "DAILY") {
          selectedFrequency = CString.daily;
        } else if (rrule.frequency.toString() == "YEARLY") {
          selectedFrequency = CString.yearly;
        } else if (rrule.frequency.toString() == "MONTHLY") {
          selectedFrequency = CString.monthly;
        } else if (rrule.frequency.toString() == "WEEKLY") {
          selectedFrequency = CString.weekly;
        } else if (rrule.frequency.toString() == "HOURLY") {
          selectedFrequency = CString.hourly;
        }
      }
      if (rrule.interval != null) {
        everyText = rrule.interval!.toString();
        _everyController.text = rrule.interval!.toString();
      }
      _startDateContoller.text = DateFormat('dd-MM-yyyy HH : mm').format(startDate);
      _endDateController.text = DateFormat('dd-MM-yyyy').format(endDate);
    });

    // rrule -> sdate
    // setState ( start date -> sdate )
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
            textStyle: widget.textStyle,
            controller: _endAfterController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) {
              if (val.isEmpty) {
                endAfter = null;
              } else if (val == "0") {
                endAfter = null;
              } else {
                endAfter = val;
              }
              setState(() {});
              _getRRule();
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
            children: [buildColumn("Every", _buildEveryTextField(CString.hours))],
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
            children: [buildColumn("Every", _buildEveryTextField(CString.days))],
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
                          if (selectedWeekDayShort.contains(weekDayShort[index])) {
                            selectedWeekDayShort.remove(weekDayShort[index]);
                          } else {
                            selectedWeekDayShort.add(weekDayShort[index]);
                          }
                          setState(() {});
                          _getRRule();
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.only(right: 2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: selectedWeekDayShort.contains(weekDayShort[index])
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
            children: [buildColumn("Every", _buildEveryTextField(CString.week))],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        _buildWeekDaySelector(),
      ],
    );
  }

  Widget buildMonthlyRepeatOnDay() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Row(
          children: [
            buildColumn("Date", dayDropDown(count: 31)),
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
            buildColumn(CString.on, ordinalDropDown()),
            const SizedBox(width: 10),
            buildColumn(CString.day, weekDayDropDown()),
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
            children: [buildColumn("Every", _buildEveryTextField(CString.month))],
          ),
        ),
        const SizedBox(height: 20),
        cSwitchTile(CString.onday, buildMonthlyRepeatOnDay(), RecurrenceMeta.onDay),
        const SizedBox(height: 20),
        cSwitchTile(CString.onThe, buildMonthlyRepeatOnThe(), RecurrenceMeta.onThe),
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
            buildColumn(CString.on, ordinalDropDown()),
            const SizedBox(width: 10),
            buildColumn(CString.day, weekDayDropDown()),
          ],
        ),
        const SizedBox(height: 15),
        Row(children: [buildColumn(CString.ofMonth, monthDropDown())]),
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
        cSwitchTile(CString.repeatOn, buildYearlyRepeatOn(), RecurrenceMeta.on),
        const SizedBox(height: 20),
        cSwitchTile(CString.onThe, buildYearlyRepeatOnThe(), RecurrenceMeta.onThe),
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

  Widget cContainer({required Widget child, double? hPadding, double? vPadding}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPadding ?? 15, vertical: vPadding ?? 15),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.07), spreadRadius: 5, blurRadius: 20),
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
                  activeColor: widget.activeSwitchColor,
                  value: type == selectedMeta,
                  onChanged: (value) {
                    if (value) {
                      setState(() {
                        selectedMeta = type;
                        _getRRule();
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

  // for get start date
  _onStartDateTap() async {
    //Date Picker
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      type: OmniDateTimePickerType.dateAndTime,
      isShowSeconds: false,
      startInitialDate: startDate,
      startFirstDate: DateTime.now().subtract(const Duration(days: 730)),
      startLastDate: DateTime.now().add(const Duration(days: 730)),
      borderRadius: const Radius.circular(16),
    );

    startDate = dateTime!;
    _startDateContoller.text = DateFormat('dd-MM-yyyy HH : mm').format(dateTime);
    _getRRule();
  }

  // for get end date
  _onEndDateTap() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      type: OmniDateTimePickerType.date,
      isShowSeconds: false,
      startInitialDate: endDate,
      startFirstDate: DateTime.now().subtract(const Duration(days: 730)),
      startLastDate: DateTime.now().add(const Duration(days: 730)),
      borderRadius: const Radius.circular(16),
    );

    endDate = dateTime!;
    _endDateController.text = DateFormat('dd-MM-yyyy HH : mm').format(dateTime);
    _getRRule();
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
      case CString.sep:
        return 30;
      case CString.oct:
        return 31;
      case CString.nov:
        return 30;
      case CString.dec:
        return 31;
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
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) {
              if (val == "0") {
                everyText = null;
              } else if (val.isEmpty) {
                everyText = null;
              } else {
                everyText = val;
              }
              setState(() {});
              _getRRule();
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
          _getRRule();
        });
      },
    );
  }

  Widget dayDropDown({int? count}) {
    return _buildDropDown(
      style: widget.textStyle,
      list: List.generate(count ?? _getMonthDayCount(selectedMonth), (index) => (index + 1).toString()),
      value: selectedDay,
      onChanged: (val) {
        setState(() {
          selectedDay = val!;
          _getRRule();
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
            _getRRule();
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
            _getRRule();
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
          _getRRule();
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
            _getRRule();
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
      decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(7)),
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

  //==========================================================

  // for generate rrule
  _getRRule() {
    Frequency _frequency = Frequency.yearly;
    Set<ByWeekDayEntry> byWeekDays = {};
    Set<int> bySetPositions = {};
    Set<int> byMonthDays = {};
    Set<int> byMonths = {};
    DateTime? until;
    int? interval;
    int? count;
    DateTime? startdate;

    try {
      switch (selectedFrequency) {
        case CString.yearly:
          _frequency = Frequency.yearly;
          switch (selectedMeta) {
            case RecurrenceMeta.on:
              byMonths.add(getMonthNumber());
              byMonthDays.add(int.parse(selectedDay));
              break;
            case RecurrenceMeta.onThe:
              bySetPositions.add(getSetPosition());
              byWeekDays.addAll(getWeekDay());
              byMonths.add(getMonthNumber());
              break;
            case RecurrenceMeta.onDay:
              break;
          }
          break;
        case CString.monthly:
          _frequency = Frequency.monthly;
          interval = (everyText == null ? null : int.parse(everyText!));
          switch (selectedMeta) {
            case RecurrenceMeta.on:
              break;
            case RecurrenceMeta.onThe:
              bySetPositions.add(getSetPosition());
              byWeekDays.addAll(getWeekDay());
              break;
            case RecurrenceMeta.onDay:
              byMonthDays.add(int.parse(selectedDay));
              break;
          }
          break;

        case CString.weekly:
          _frequency = Frequency.weekly;
          interval = (everyText == null ? null : int.parse(everyText!));

          for (var e in selectedWeekDayShort) {
            byWeekDays.add(getWeekDayByShortName(e));
          }
          break;

        case CString.daily:
          _frequency = Frequency.daily;
          interval = (everyText == null ? null : int.parse(everyText!));

          break;

        case CString.hourly:
          _frequency = Frequency.hourly;
          interval = (everyText == null ? null : int.parse(everyText!));

          break;
      }
      startdate = startDate.toUtc();
      switch (selectedEnd) {
        case CString.never:
          break;
        case CString.after:
          count = endAfter == null ? null : int.parse(endAfter!);
          break;
        case CString.onDate:
          until = endDate.toUtc();
          break;
      }

      final rrule = RecurrenceRule(
        startDate: startdate,
        frequency: _frequency,
        interval: interval,
        byWeekDays: byWeekDays,
        byMonthDays: byMonthDays,
        byMonths: byMonths,
        bySetPositions: bySetPositions,
        count: count,
        until: until,
      );
      widget.onChanged(rrule.toString().replaceAll("RRULE:", ""));
    } catch (e) {
      // ignore: avoid_print
      print(e);
      widget.onChanged(null);
    }
  }

  // used for get month number
  getMonthNumber() {
    switch (selectedMonth) {
      case CString.jan:
        return 1;
      case CString.feb:
        return 2;
      case CString.mar:
        return 3;
      case CString.apr:
        return 4;
      case CString.may:
        return 5;
      case CString.jun:
        return 6;
      case CString.jul:
        return 7;
      case CString.aug:
        return 8;
      case CString.sep:
        return 9;
      case CString.oct:
        return 10;
      case CString.nov:
        return 11;
      case CString.dec:
        return 12;
    }
  }

  // used for get setPosition
  getSetPosition() {
    switch (selectedOrdinal) {
      case CString.first:
        return 1;
      case CString.second:
        return 2;
      case CString.third:
        return 3;
      case CString.fourth:
        return 4;
      case CString.last:
        return -1;
    }
  }

  // used for get weekday
  getWeekDay() {
    switch (selectedWeekDay) {
      case CString.monday:
        return {ByWeekDayEntry(DateTime.monday)};
      case CString.tuesday:
        return {ByWeekDayEntry(DateTime.tuesday)};
      case CString.wednesday:
        return {ByWeekDayEntry(DateTime.wednesday)};
      case CString.thursday:
        return {ByWeekDayEntry(DateTime.thursday)};
      case CString.friday:
        return {ByWeekDayEntry(DateTime.friday)};
      case CString.saturday:
        return {ByWeekDayEntry(DateTime.saturday)};
      case CString.sunday:
        return {ByWeekDayEntry(DateTime.sunday)};

      case CString.day:
        return {
          ByWeekDayEntry(DateTime.monday),
          ByWeekDayEntry(DateTime.tuesday),
          ByWeekDayEntry(DateTime.wednesday),
          ByWeekDayEntry(DateTime.thursday),
          ByWeekDayEntry(DateTime.friday),
          ByWeekDayEntry(DateTime.saturday),
          ByWeekDayEntry(DateTime.sunday),
        };

      case CString.weekDay:
        return {
          ByWeekDayEntry(DateTime.monday),
          ByWeekDayEntry(DateTime.tuesday),
          ByWeekDayEntry(DateTime.wednesday),
          ByWeekDayEntry(DateTime.thursday),
          ByWeekDayEntry(DateTime.friday),
        };

      case CString.weekEndDay:
        return {
          ByWeekDayEntry(DateTime.saturday),
          ByWeekDayEntry(DateTime.sunday),
        };
    }
  }

  // used for get shortname of month
  getWeekDayByShortName(day) {
    switch (day) {
      case CString.mon:
        return ByWeekDayEntry(DateTime.monday);
      case CString.tue:
        return ByWeekDayEntry(DateTime.tuesday);
      case CString.wed:
        return ByWeekDayEntry(DateTime.wednesday);
      case CString.thu:
        return ByWeekDayEntry(DateTime.thursday);
      case CString.fri:
        return ByWeekDayEntry(DateTime.friday);
      case CString.sat:
        return ByWeekDayEntry(DateTime.saturday);
      case CString.sun:
        return ByWeekDayEntry(DateTime.sunday);
    }
  }
}
