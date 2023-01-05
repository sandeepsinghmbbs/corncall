import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/common/widgets/error.dart';
import 'package:corncall/common/widgets/loader.dart';
import 'package:corncall/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/select-contact';
  const SelectContactsScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<SelectContactsScreen> createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends ConsumerState<SelectContactsScreen> {
  final TextEditingController searchTextController = TextEditingController();
  final searchTypeProvider = StateProvider<bool>((ref) => false);
  final searchStringProvider = StateProvider<String>((ref) => "");


  void selectContact(WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context) {
    final isSearchingW = ref.watch(searchTypeProvider);
    final query = ref.watch(searchStringProvider);

    return Scaffold(
      appBar: AppBar(
        title: isSearchingW == false ? const Text('Select contact') : TextField(controller: searchTextController,decoration: const InputDecoration(
            hintText: 'Search Here',

          ),
            onChanged: (text) {
          print('First text field: $text');
          ref.read(searchStringProvider.state).state = text;
          // searchContact(ref, text, context);
  },
        ) ,
        actions: [
          IconButton(
            onPressed: () {
              print("1111111111111111");
              ref.read(searchTypeProvider.state).state = !isSearchingW;
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body:ref.watch(getContactsProvider ).when(
            data: (contactList) =>
              ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {

                  final contact = contactList[index];

                  if(contact.displayName.toLowerCase().contains(query.toLowerCase())) {
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
                  }
                  else
                    {
                      return Container();
                    }


                }),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
