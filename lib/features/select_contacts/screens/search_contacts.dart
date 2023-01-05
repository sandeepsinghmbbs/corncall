import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchContact extends SearchDelegate<String> {
  final List<Contact> names;
  late String result;
  late WidgetRef ref;

  SearchContact(this.names);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = names.where((name) {
      return name.displayName.toLowerCase().contains(query.toLowerCase());
    });

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {

          final contact = suggestions.elementAt(index);
          return InkWell(
            onTap: () => selectContact(ref, contact, context),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                title: Text(
                  contact.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                leading: contact.photo == null
                    ? null
                    : CircleAvatar(
                  backgroundImage: MemoryImage(contact.photo!),
                  radius: 30,
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = names.where((name) {
      return name.displayName.toLowerCase().contains(query.toLowerCase());
    });

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {

          final contact = suggestions.elementAt(index);
          return InkWell(
            onTap: () => selectContact(ref, contact, context),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                title: Text(
                  contact.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                leading: contact.photo == null
                    ? null
                    : CircleAvatar(
                  backgroundImage: MemoryImage(contact.photo!),
                  radius: 30,
                ),
              ),
            ),
          );
        });
  }

  selectContact(WidgetRef ref, contact, BuildContext context) {}
}