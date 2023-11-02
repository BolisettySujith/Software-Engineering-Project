import 'package:attendance_register/model/course.dart';
import 'package:attendance_register/res/components/show_toast_widget.dart';
import 'package:attendance_register/view_model/attendance_sheets_view_model.dart';
import 'package:flutter/material.dart';
import '../res/components/loading_widget.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key, required this.studentsList, required this.currentAttendanceList, required this.attendanceDate, required this.course});

  final ClassCourse course;
  final List<String> studentsList;
  final List<String> currentAttendanceList;
  final String attendanceDate;

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {

  bool isAttendanceUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Attendance List"),
        elevation: 5,
        backgroundColor: ThemeData().primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              children: [
                const Text(
                  "Google Sheets Title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(widget.course.spreadGSheetTitle, maxLines: 2),
                const Text(
                  "Sheet Name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(widget.course.sheetName),
                const SizedBox(height: 10,),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "Roll Number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.attendanceDate,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ]
                    ),
                    for(int i =0; i < widget.studentsList.length; i++) TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            widget.studentsList[i],
                            style: TextStyle(
                                color: widget.currentAttendanceList[i] == "A" ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                              widget.currentAttendanceList[i],
                            style: TextStyle(
                              color: widget.currentAttendanceList[i] == "A" ? Colors.red : Colors.black
                            ),
                          ),
                        ),
                      ]
                    )
                  ],
                ),

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isAttendanceUploading ? ThemeData().primaryColor : ThemeData().primaryColorDark,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.grey[100],
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    isAttendanceUploading = true;
                  });
                  AttendanceSheetViewModel.insert(widget.currentAttendanceList, widget.attendanceDate).then((value) {
                    showToastMessage(
                        "Successfully Attendance Recorded!",
                        Colors.green
                    );
                    Navigator.pop(context);
                  });
                },
                child: const Wrap(
                  spacing: 5,
                  children: [
                    Icon(Icons.upload),
                    Text("Upload Attendance"),
                  ],
                ),
              ),
            ),
          ),
          if(isAttendanceUploading) const LoadingWidget(description: "We are uploading attendance\nto your Google Sheet",)
        ],
      ),
    );
  }
}
