import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Hello Frontend App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var greetings = '';
  var users = [];

  Future<void> getNext(String name) async {
    try {
      final response = await http.get(Uri.parse('http://hello-marvic2.appspot.com/_ah/api/hello/v1/hello?name=$name'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        greetings = data['message'];
      } else {
        greetings = 'Error during http call';
      }
    } catch (e) {
      greetings = 'Exception: $e';
    }
    notifyListeners();
  }

  Future<void> getUsers() async {
    try {
      final response = await http.get(Uri.parse('http://hello-marvic2.appspot.com/_ah/api/hello/v1/users'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        users = data['items'];
      } else {
        greetings = 'Error during http call';
      }
    } catch (e) {
      greetings = 'Exception: $e';
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sending data'),
            SizedBox(height: 10),
            SizedBox(
              width: 350,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name:',
                ),
              ),
            ),
            SizedBox(height: 10),
        
                ElevatedButton(
                  onPressed: () {
                    appState.getNext(nameController.text.trim());
                  },
                  child: Text('say hello'),
                ),
        
            SizedBox(height: 10),
            Text(appState.greetings),

            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),

                ElevatedButton(
                  onPressed: () {
                    appState.getUsers();
                  },
                  child: Text('show users'),
                ),
            SizedBox(
              width: 350,
              height: 350,
              child: ListViewExample(users: appState.users),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewExample extends StatelessWidget {
  const ListViewExample({
      super.key,
      required this.users,
    });

  final List<dynamic> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('No users to display'));
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        if (index < users.length) {
          return ListTile(
            title: Text(users[index].toString()),
          );
        } else {
          return ListTile(title: Text('***'),);
        }
      },
    );
  }
}
