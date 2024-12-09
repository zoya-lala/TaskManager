import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/screens/home.dart';
import 'package:task_manager/screens/homeTab.dart';
import 'package:task_manager/screens/profileTab.dart';
import 'package:task_manager/screens/settingsTab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text(
          'Task Manager',
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeTab()),
                );
              },
              leading: Icon(
                Icons.house_sharp,
              ),
              title: Text('Home'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileTab()),
                );
              },
              leading: Icon(
                Icons.person,
              ),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsTab()),
                );
              },
              leading: Icon(
                Icons.settings,
              ),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
