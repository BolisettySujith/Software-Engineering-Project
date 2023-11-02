import '../model/course.dart';
import '../repository/attendance_sheets_repository.dart';

class AttendanceSheetViewModel {
    static Future setUpSheet(ClassCourse classCourse) async {
      await AttendanceSheetsApi.init(classCourse);
    }

    static Future<List<String>> getClassStudentsNames() async {
      List<String> studentsList = await AttendanceSheetsApi.getClassStudentsNames();
      return studentsList;
    }

    static List<String> getCurrentAttendance(String absentees) {
      return AttendanceSheetsApi.getCurrentAttendance(absentees);
    }

    static Future insert(List<String> absentList, String attendanceDate) async {
      await AttendanceSheetsApi.insert(absentList, attendanceDate);
    }
}