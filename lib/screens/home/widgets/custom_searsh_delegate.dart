import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: const [
        ListTile(
          title: Text('results'),
        )
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');

        final results = snapshot.data!.docs.where(
          (element) =>
              element['title']
                  .toString()
                  .contains(query.trim().toLowerCase()) &&
              query.isNotEmpty,
        );

        return ListView(
          children: results
              .map<Widget>(
                (el) => ListTile(
                  title: Text(el['title']),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
