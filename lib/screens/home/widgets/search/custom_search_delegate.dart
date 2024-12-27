import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:shop_fire/screens/home/widgets/search/search_result.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ''; // clear query
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //back btn
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // if (query.isEmpty) {
    //   return const Center(
    //     child: Text('start to type!'),
    //   );
    // }
    return SearchResult(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('start to type!'),
      );
    }
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final suggestions = snapshot.data!.docs;
        if (suggestions.isEmpty) {
          return const Center(
            child: Text('no results found!'),
          );
        }
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final document = suggestions[index];
            return ListTile(
              title: Text(document['title']),
              onTap: () {
                query = document['title'];
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
