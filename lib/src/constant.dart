List<String> repeatOn = [
  CString.yearly,
  CString.monthly,
  CString.weekly,
  CString.daily,
  CString.hourly,
];

List<String> months = [
  CString.jan,
  CString.feb,
  CString.mar,
  CString.apr,
  CString.may,
  CString.jun,
  CString.jul,
  CString.aug,
  CString.sep,
  CString.oct,
  CString.nov,
  CString.dec,
];

List<String> ordinal = [
  CString.first,
  CString.second,
  CString.third,
  CString.fourth,
  CString.last,
];

List<String> weekDay = [
  CString.monday,
  CString.tuesday,
  CString.wednesday,
  CString.thrusday,
  CString.friday,
  CString.saturday,
  CString.sunday,
  CString.day,
  CString.weekDay,
  CString.weekEndDay,
];

List<String> weekDayShort = [
  CString.mon,
  CString.tue,
  CString.wed,
  CString.thu,
  CString.fri,
  CString.sat,
  CString.sun,
];

List<String> endDropdownList = [
  CString.never,
  CString.after,
  CString.onDate,
];

enum RecurrenceMeta { on, onThe, onDay }

class CString {
  static const String start = "Start";
  static const String repeat = "Repeat";
  static const String end = "end";
  static const String yearly = "Yearly";
  static const String monthly = "Monthly";
  static const String weekly = "Weekly";
  static const String daily = "Daily";
  static const String hourly = "Hourly";
  static const String on = "On";
  static const String onThe = "On the";
  static const String onday = "On day";
  static const String jan = "Jan";
  static const String feb = "Feb";
  static const String mar = "Mar";
  static const String apr = "Apr";
  static const String may = "May";
  static const String jun = "Jun";
  static const String jul = "Jul";
  static const String aug = "Aug";
  static const String sep = "Sep";
  static const String oct = "Oct";
  static const String nov = "Nov";
  static const String dec = "Dec";
  static const String sun = "Sun";
  static const String mon = "Mon";
  static const String tue = "Tue";
  static const String wed = "Wed";
  static const String thu = "Thu";
  static const String fri = "Fri";
  static const String sat = "Sat";
  static const String first = "First";
  static const String second = "Second";
  static const String third = "Third";
  static const String fourth = "Fourth";
  static const String last = "Last";
  static const String sunday = "Sunday";
  static const String monday = "Monday";
  static const String tuesday = "Tuesday";
  static const String wednesday = "Wednesday";
  static const String thrusday = "Thrusday";
  static const String friday = "Friday";
  static const String saturday = "Saturday";
  static const String day = "Day";
  static const String weekDay = "WeekDay";
  static const String weekEndDay = "WeekEndDay";
  static const String every = "every";
  static const String month = "Month(s)";
  static const String week = "Week(s)";
  static const String days = "Day(s)";
  static const String hours = "Hour(s)";
  static const String after = "After";
  static const String never = "Never";
  static const String onDate = "On Date";
  static const String executions = "Executions.";

}
