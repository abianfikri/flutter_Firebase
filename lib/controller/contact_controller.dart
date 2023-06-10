import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_firebase/model/contact_model.dart';

class ContactController {
  final contactCollection = FirebaseFirestore.instance.collection('contacts');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future addContact(ContactModel ctmodel) async {
    final contact = ctmodel.toMap();

    final DocumentReference docRef = await contactCollection.add(contact);

    final String docId = docRef.id;

    final ContactModel contactModel = ContactModel(
        id: docId,
        name: ctmodel.name,
        phone: ctmodel.phone,
        email: ctmodel.email,
        address: ctmodel.address);

    await docRef.update(contactModel.toMap());
  }

  Future getContact() async {
    final contact = await contactCollection.get();
    streamController.sink.add(contact.docs);

    return contact.docs;
  }

  Future updateContact(ContactModel contactModel) async {
    final ContactModel updateContactModel = ContactModel(
        id: contactModel.id,
        name: contactModel.name,
        phone: contactModel.phone,
        email: contactModel.email,
        address: contactModel.address);

    // final DocumentSnapshot documentSnapshot =
    //     await contactCollection.doc(docId).get();
    // if (!documentSnapshot.exists) {
    //   print('Contact with ID $docId does not exist');
    //   return;
    // }

    // final updatedContact = updateContactModel.toMap();

    await contactCollection
        .doc(contactModel.id)
        .update(updateContactModel.toMap());
    await getContact();
  }

  Future deleteContact(String id) async {
    await contactCollection.doc(id).delete();
    await getContact();
  }
}
