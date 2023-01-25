// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, unused_field

import 'package:chat_app/custom%20widgets/connectivity/network_indicator.dart';
import 'package:chat_app/custom%20widgets/safe_area/page_container.dart';
import 'package:chat_app/custom%20widgets/small%20text/small_text.dart';
import 'package:chat_app/provider/select%20contact/select_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';

class SelectContactScreen extends StatefulWidget {
  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  bool initialRun = true;

  Future<List<Contact>>? _contactsList;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initialRun) {
      _contactsList = Provider.of<SelectContactProvider>(context, listen: false)
          .getContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NetworkIndicator(
      child: PageContainer(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Select contact'),
            actions: [
              IconButton(
                onPressed: () {},
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
          body: FutureBuilder<List<Contact>>(
              future: _contactsList,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: SmallText(text: "non"),
                    );

                  case ConnectionState.active:
                    return Text("");

                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return SmallText(text: "text");
                    else {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Provider.of<SelectContactProvider>(context,
                                        listen: false)
                                    .selectContact(
                                  snapshot.data![index],
                                  context,
                                );
                              },
                              child: ListTile(
                                title: Text(
                                  snapshot.data![index].displayName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                leading: snapshot.data![index].photo == null
                                    ? null
                                    : CircleAvatar(
                                        backgroundImage: MemoryImage(
                                            snapshot.data![index].photo!),
                                        radius: 30,
                                      ),
                              ),
                            );
                          });
                    }
                }
              }),
        ),
      ),
    );
  }
}
