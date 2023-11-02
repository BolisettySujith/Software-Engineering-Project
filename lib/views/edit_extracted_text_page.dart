import 'dart:io';
import 'package:attendance_register/res/constants/courses.dart';
import 'package:attendance_register/view_model/attendance_sheets_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../model/course.dart';
import '../res/components/show_toast_widget.dart';
import 'attendance_list_page.dart';

class EditExtractedTextPage extends StatefulWidget {
  const EditExtractedTextPage({super.key, required this.imageFile, required this.extractedText});

  final XFile imageFile;
  final String extractedText;

  @override
  State<EditExtractedTextPage> createState() => _EditExtractedTextPageState();
}

class _EditExtractedTextPageState extends State<EditExtractedTextPage> {

  bool isAttendanceLoading = false;
  DateTime selectedDate = DateTime.now();
  ClassCourse selectedClassCourse = Courses.coursesList.first;
  var formatter = DateFormat('dd-MM-yyyy');

  TextEditingController scannedTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scannedTextEditingController.text = widget.extractedText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Roll Numbers"),
        elevation: 5,
        backgroundColor: ThemeData().primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Center(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.width / 1.5,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Image.file(File(widget.imageFile.path))
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Extracted Absentees Roll Numbers",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const Text(
                            "*Update the roll numbers in case of inaccuracy",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                hintStyle: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10
                                ),
                                hintText: scannedTextEditingController.text.isNotEmpty ? "" :"*No Absentees (or) Click to enter numbers manually"
                            ),
                            controller: scannedTextEditingController,
                          ),
                          const SizedBox(height: 2,),
                          const Text(
                            "*Make sure you have the numbers separated by ',' (comma)",
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      _chooseClassCourse(),
                      const SizedBox(height: 4,),
                      _date(),
                      const SizedBox(height: 30,),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeData().primaryColor,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.grey[100],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: !isAttendanceLoading ? () async {
                            setState(() {
                              isAttendanceLoading = true;
                            });
                            await AttendanceSheetViewModel.setUpSheet(selectedClassCourse);
                            List<String> studentsList = await AttendanceSheetViewModel.getClassStudentsNames();
                            List<String> currentAttendance = AttendanceSheetViewModel.getCurrentAttendance(scannedTextEditingController.text.toString());

                            setState(() {
                              isAttendanceLoading = false;
                            });

                            if (currentAttendance.isNotEmpty && studentsList.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    AttendanceList(
                                      studentsList: studentsList,
                                      currentAttendanceList: currentAttendance,
                                      attendanceDate: formatter.format(selectedDate),
                                      course: selectedClassCourse,
                                    )),
                              );
                            }
                          } : () {
                            showToastMessage(
                                "Please wait, processing your request",
                                Colors.white,
                                toastTextColor: Colors.black
                            );
                          },

                          child: !isAttendanceLoading
                            ? const Text("Generate Attendance")
                            : Container(
                              padding: const EdgeInsets.all(2),
                              height: 25,
                              width: 25,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              )
                          )
                      ),
                      const SizedBox(height: 40,),
                    ],
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
  Widget _date(){
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Attendance Date",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Colors.grey.shade800,
                  size: 16,
                ),
                const SizedBox(width: 5,),
                Text(
                  "${selectedDate.day} ${DateFormat('MMM').format(DateTime(0,selectedDate.month))} ${selectedDate.year}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14
                  ),
                  maxLines: 2,
                ),
                const Spacer(flex: 1,),
                FittedBox(
                  child: GestureDetector(
                      onTap: _selectDate,
                      child: Text(
                        "Change",
                        style: TextStyle(
                            color: ThemeData().primaryColor,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _chooseClassCourse(){
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Choose Class Course",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.class_sharp,
                  color: Colors.grey.shade800,
                  size: 16,
                ),
                const SizedBox(width: 5,),
                Text(
                  selectedClassCourse.sheetName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14
                  ),
                  maxLines: 2,
                ),
                const Spacer(flex: 1,),
                PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    onSelected: (course) {
                      for (var cc in Courses.coursesList) {
                        if(cc.sheetName==course) {
                          selectedClassCourse = cc;
                        }
                      }

                      setState(() {});
                    },
                    itemBuilder: (BuildContext context){
                      return Courses.coursesList.map((ClassCourse choice){
                        return PopupMenuItem<String>(
                          value: choice.sheetName,
                          child: Text(
                            choice.sheetName,
                            style: TextStyle(
                                color: selectedClassCourse.sheetName == choice.sheetName ? ThemeData().primaryColorDark : Colors.black
                            ),
                          ),);
                      }).toList();
                    }
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
