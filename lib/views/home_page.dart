import 'package:attendance_register/views/courses_page.dart';
import 'package:attendance_register/views/image_scan_page.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int currentIndex;

  var screens = [
    const ImageScanPage(),
    const CoursesPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            if(currentIndex !=0){
              changePage(0);
              return false;
            }
            return true;
          },
          child: screens[currentIndex]
      ),
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Colors.white,
        hasNotch: true,
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        elevation: 8,
        tilesPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: ThemeData().primaryColorDark,
              icon: Icon(Icons.image, color: Colors.grey.shade800,),
              activeIcon: Icon(Icons.image, color: Colors.blue.shade800,),
              title: Text("Upload", style: TextStyle(color: Colors.blue.shade800),)
          ),
          BubbleBottomBarItem(
              backgroundColor: ThemeData().primaryColorDark,
              icon: Icon(Icons.book, color: Colors.grey.shade800,),
              activeIcon: Icon(Icons.book, color: Colors.blue.shade800,),
              title: Text("Courses", style: TextStyle(color: Colors.blue.shade800),)
          ),
        ],
      ),
    );
  }
  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }
}
