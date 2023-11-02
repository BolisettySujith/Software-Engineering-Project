import '../repository/attendance_sheets_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class CreateSheetsPage extends StatefulWidget {
  const CreateSheetsPage({super.key});

  @override
  State<CreateSheetsPage> createState() => _CreateSheetsPageState();
}

class _CreateSheetsPageState extends State<CreateSheetsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Save Data To Sheets"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Center(
          child: TextButton(
            onPressed: () async {
              final absentList = ["P", "P","A", "P","A", "P","A","A", "P", "P"];
              await AttendanceSheetsApi.insert(absentList,"");
            },
            child: const Text("Save"),
          ),
        ),
      ),
    );
  }
}
