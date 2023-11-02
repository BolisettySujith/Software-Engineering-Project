import 'package:attendance_register/model/course.dart';
import 'package:attendance_register/res/constants/courses.dart';
import 'package:flutter/material.dart';

import '../res/components/show_toast_widget.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {

  TextEditingController sheetTitleController = TextEditingController();
  TextEditingController sheetNameController = TextEditingController();
  TextEditingController sheetIdController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        elevation: 5,
        backgroundColor: ThemeData().primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: Courses.coursesList.length,
        itemBuilder: (context, index) {
          ClassCourse course = Courses.coursesList[index];
          return ListTile(
            title: Text(course.spreadGSheetTitle.replaceAll("-", " ")),
            subtitle: Text(course.sheetName.replaceAll("-", " ")),
            leading: CircleAvatar(
              backgroundColor: ThemeData().primaryColor.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                      Icons.table_view_sharp,
                    color: ThemeData().primaryColorDark,
                  ),
                )
            ),
            trailing: editClassCourseButton(course, index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeData().primaryColorLight,
        onPressed: () {
          addClassCourseWidget();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget editClassCourseButton(ClassCourse course, int index) {
    return GestureDetector(
      onTap: (){
        editClassCourseWidget(course, index);
      },
        child: const Icon(Icons.edit)
    );
  }

  Future addClassCourseWidget() {
    sheetTitleController.clear();
    sheetIdController.clear();
    sheetNameController.clear();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "New Class Course",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Google Spread Sheet Title",
                style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10
                    ),
                    hintText: "Enter Spread Sheet Title"
                ),
                controller: sheetTitleController,
              ),

              const SizedBox(height: 20,),
              const Text(
                "Sheet Name",
                style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold
                ),
              ),
              Text(
                "*Make sure you enter the same sheet name which was present in Google Sheet at the bottom",
                style: TextStyle(
                    fontSize: 10,
                    color: ThemeData().primaryColor
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10
                    ),
                    hintText: "Enter Sheet Name"
                ),
                controller: sheetNameController,
              ),

              const SizedBox(height: 20,),
              const Text(
                "Google Spread Sheet ID",
                style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold
                ),
              ),
              Text(
                "*Make sure you enter the correct sheet id, you can get the sheet id from the Google Sheet URL.",
                style: TextStyle(
                    fontSize: 10,
                    color: ThemeData().primaryColor
                ),
              ),
              Text(
                "Example: https://docs.google.com/spreadsheets/d/SPREAD_SHEET_ID/",
                style: TextStyle(
                    fontSize: 8,
                    color: ThemeData().primaryColor
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10
                    ),
                    hintText: "Enter Spread Sheet ID"
                ),
                controller: sheetIdController,
              ),
              const SizedBox(height: 30,),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeData().primaryColor,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.grey[100],
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onPressed: (){
                      if(sheetTitleController.text.trim().isEmpty || sheetNameController.text.trim().isEmpty || sheetIdController.text.trim().isEmpty){
                        showToastMessage(
                            "Please Enter all the details in the above fields",
                            Colors.white,
                            toastTextColor: Colors.black
                        );
                      } else {
                        ClassCourse newCourse = ClassCourse(
                            sheetTitleController.text.trim().toString(),
                            sheetNameController.text.trim().toString(),
                            sheetIdController.text.trim().toString()
                        );
                        Courses.coursesList.add(newCourse);
                        sheetTitleController.clear();
                        sheetIdController.clear();
                        sheetNameController.clear();
                        setState(() {});
                        Navigator.pop(context);
                      }

                    },
                    child:const Text("Add Class Course")
                ),
              ),
              const SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }

  Future editClassCourseWidget(ClassCourse course, int index) {
    sheetNameController.text = course.sheetName;
    sheetIdController.text = course.gSheetId;
    sheetTitleController.text = course.spreadGSheetTitle;
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Edit Class Course",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Google Spread Sheet Title",
                style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10
                    ),
                    hintText: "Enter Spread Sheet Title"
                ),
                controller: sheetTitleController,
              ),

              const SizedBox(height: 20,),
              const Text(
                "Sheet Name",
                style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold
                ),
              ),
              Text(
                "*Make sure you enter the same sheet name which was present in Google Sheet at the bottom",
                style: TextStyle(
                    fontSize: 10,
                    color: ThemeData().primaryColor
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10
                    ),
                    hintText: "Enter Sheet Name"
                ),
                controller: sheetNameController,
              ),

              const SizedBox(height: 20,),
              const Text(
                "Google Spread Sheet ID",
                style: TextStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold
                ),
              ),
              Text(
                "*Make sure you enter the correct sheet id, you can get the sheet id from the Google Sheet URL.",
                style: TextStyle(
                    fontSize: 10,
                    color: ThemeData().primaryColor
                ),
              ),
              Text(
                "Example: https://docs.google.com/spreadsheets/d/SPREAD_SHEET_ID/",
                style: TextStyle(
                    fontSize: 8,
                    color: ThemeData().primaryColor
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 10
                    ),
                    hintText: "Enter Spread Sheet ID"
                ),
                controller: sheetIdController,
              ),
              const SizedBox(height: 30,),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeData().primaryColor,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.grey[100],
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onPressed: (){
                      if(sheetTitleController.text.trim().isEmpty || sheetNameController.text.trim().isEmpty || sheetIdController.text.trim().isEmpty){
                        showToastMessage(
                            "Please Enter all the details in the above fields",
                            Colors.white,
                            toastTextColor: Colors.black
                        );
                      } else {
                        ClassCourse newCourse = ClassCourse(
                            sheetTitleController.text.trim().toString(),
                            sheetNameController.text.trim().toString(),
                            sheetIdController.text.trim().toString()
                        );
                        Courses.coursesList.insert(index, newCourse);
                        sheetTitleController.clear();
                        sheetIdController.clear();
                        sheetNameController.clear();
                        setState(() {});
                        Navigator.pop(context);
                      }

                    },
                    child:const Text("Update Class Course")
                ),
              ),
              const SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
