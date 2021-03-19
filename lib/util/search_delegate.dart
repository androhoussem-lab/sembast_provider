

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast_example/model/user.dart';
import 'package:sembast_example/providers/user_provider.dart';
import 'package:sembast_example/view/search_result.dart';

class ContactsSearch extends SearchDelegate{

  ContactsSearch(BuildContext context){
    getNameSuggested(context);
  }

 List<String> suggestedName = [];
  List<String> historySearch = [
    'Paysera',
    'N26',
    'Webmoney',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
   return SearchResultScreen(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Show when someone searches for something
    final suggestionList = query.isEmpty
        ? historySearch
        : suggestedName
        .where((element) => element.startsWith(query))
        .toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: (){
              query = suggestionList[index];
              showResults(context);

            },
            leading:
            query.isEmpty ? Icon(Icons.history) : Icon(Icons.shopping_bag),
            title: RichText(
              text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey)
                  )
                ],
              ),
            ),
          );
        });
  }

   getNameSuggested(BuildContext context) async {
    Future<dynamic> users = Provider.of<UserProvider>(context , listen: false).getAllSortedByName();
    for(var user in await users){
     suggestedName.add(user.name);
    }
  }
}