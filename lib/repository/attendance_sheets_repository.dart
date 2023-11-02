import 'package:attendance_register/model/attendance_fields.dart';
import 'package:attendance_register/res/components/show_toast_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/course.dart';

class AttendanceSheetsApi {
  static final String _credentials = dotenv.env['CREDENTIALS'].toString();

  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;
  static int? classStrength;

  static Future init(ClassCourse classCourse) async {
    try {
      final spreadSheet = await _gsheets.spreadsheet(classCourse.gSheetId);
      _userSheet = await _getWorkSheet(spreadSheet, title:classCourse.sheetName);
      final firstRow = AttendanceFields.getFields();
      // _userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      showToastMessage(
          "Something went wrong, please try again",
          Colors.red
      );
      if (kDebugMode) {
        print("Init Error $e");
      }
    }
  }

  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet, {
      required String title
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<String> absentList, String attendanceDate) async {
    if(_userSheet == null) return;

    int lastCol = await getColCount();
    
    bool isDateExists = await checkIfDateExists(attendanceDate);

    if(isDateExists) {
      _userSheet!.values.insertColumnByKey(attendanceDate, absentList, fromRow: 2);
    } else {
      absentList.insert(0, attendanceDate);
      _userSheet!.values.insertColumn(lastCol+1,absentList, fromRow: 1);
    }
  }

  static Future<bool> checkIfDateExists(String currentDate) async {
    if(_userSheet == null) return false;

    final colCount = await _userSheet!.values.row(1);
    bool containsDate = colCount.contains(currentDate);

    return containsDate;
  }

  static Future<int> getColCount() async {
    if(_userSheet == null) return 0;
    final colCount = await _userSheet!.values.row(1);
    return colCount.length;
  }
  
  static Future<List<String>> getClassStudentsNames() async {
    if(_userSheet == null) return [];
    List<String>? classData = [];
    try {
      classData = await _userSheet!.values.column(2);
      classData.removeAt(0);
      classStrength = classData.length;
    } catch (e) {
      showToastMessage(
          "Something went wrong, please try again",
          Colors.red
      );
      return [];
    }

    return classData;
  }

  static List<String> getCurrentAttendance(String absentees) {
    List<int> rollNumbers = [];
    if(absentees.isNotEmpty) {
      List<String> numbers = absentees.split(",");
      for (String element in numbers) {
        try {
          int number = int.parse(element.trim());
          rollNumbers.add(number);
        } catch (e) {
          showToastMessage(
              "Please verify Entered Roll Numbers",
              Colors.red
          );
          return []; // Stop and return null if a non-integer is found
        }
      }

    }

    List<String> attendance = [];
    try {
      attendance = List.generate(classStrength ?? 0, (index) => "P");
      for (var element in rollNumbers) {
        attendance[element-1] = "A";
      }
    } catch(e) {
      showToastMessage(
          "Please verify: Unknown roll number encountered",
          Colors.red
      );
      return []; // Stop and return null if an error occurred
    }
    return attendance;
  }
}