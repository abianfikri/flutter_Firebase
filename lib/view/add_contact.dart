import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_firebase/controller/contact_controller.dart';
import 'package:project_firebase/model/contact_model.dart';
import 'package:project_firebase/view/contact.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  var contatcController = ContactController();
  final formkey = GlobalKey<FormState>();

  String? name;
  String? phone;
  String? email;
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Phone'),
                  onChanged: (value) {
                    phone = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Email'),
                  onChanged: (value) {
                    email = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Address'),
                  onChanged: (value) {
                    address = value;
                  },
                ),
                ElevatedButton(
                  child: const Text('Add Contact'),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      ContactModel cm = ContactModel(
                          name: name!,
                          phone: phone!,
                          email: email!,
                          address: address!);
                      contatcController.addContact(cm);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contact Added')));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Contact()));
                    }
                  },
                )
              ],
            )),
      ),
    );
  }
}
