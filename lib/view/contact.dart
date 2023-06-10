import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_firebase/controller/contact_controller.dart';
import 'package:project_firebase/model/contact_model.dart';
import 'package:project_firebase/view/add_contact.dart';
import 'package:project_firebase/view/login.dart';
import 'package:project_firebase/view/update_contact.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  var cc = ContactController();

  @override
  void initState() {
    super.initState();
    cc.getContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Username',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 18)),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(fontSize: 18),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Contact List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: cc.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final List<DocumentSnapshot> data = snapshot.data!;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateContact(
                                          beforenama:
                                              data[index]['name'].toString(),
                                          beforephone:
                                              data[index]['phone'].toString(),
                                          beforeemail:
                                              data[index]['email'].toString(),
                                          beforeaddress:
                                              data[index]['address'].toString(),
                                          id: data[index]['id'].toString(),
                                        )));
                          },
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  data[index]['name']
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(data[index]['name']),
                              subtitle: Text(data[index]['phone']),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  cc
                                      .deleteContact(
                                          data[index]['id'].toString())
                                      .then((value) {
                                    setState(() {
                                      cc.getContact();
                                    });
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Contact Deleted')));
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddContact()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
