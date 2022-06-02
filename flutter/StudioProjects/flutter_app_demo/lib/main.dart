import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String buttonname = 'Click';
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Title'),
        ),
        body: Center(
            child: currentIndex == 0
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Colors.orange,
                            ),
                            onPressed: () {
                              setState(() {
                                buttonname = 'Clicked';
                              });
                            },
                            child: Text(buttonname)),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                buttonname = 'Clicked';
                              });
                            },
                            child: Text(buttonname))
                      ],
                    ))
                : Image.network(
                    'https://www.bigfinish.com/image/release/2297/large.jpg')),
        // : Image.asset('images/galaxy.jpg')),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility mode',
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

// class SecondPage extends StatelessWidget {
//   const SecondPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//   }
// }