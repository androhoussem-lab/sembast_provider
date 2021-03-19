import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast_example/model/user.dart';
import 'package:sembast_example/providers/user_provider.dart';
import 'package:sembast_example/util/search_delegate.dart';
import 'package:sembast_example/view/new_user.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context,listen: false).getAllSortedByName();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Contacts'),
        actions: [
          IconButton(icon: Icon(Icons.search , color:Colors.white), onPressed: (){
            showSearch(context: context, delegate: ContactsSearch(context));

          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 16,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewUserScreen(null)));
        },
      ),
      body: Selector<UserProvider, List<User>>(
        selector: (context, userProvider) => userProvider.usersList,
        builder: (context, users, child) {
          return (users.isEmpty)
              ? Center(
                  child: Text('List of contacts is empty'),
                )
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewUserScreen(users[index])));
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          users[index].userId.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      title: Text(
                        users[index].name,
                        style: TextStyle(
                          color: (users[index].isAdmin)
                              ? Colors.redAccent
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(users[index].email),
                      trailing: IconButton(icon: Icon(Icons.delete , color: Colors.redAccent,), onPressed: (){
                        Provider.of<UserProvider>(context,listen: false).delete(users[index]);
                      }),
                    );
                  });
        },
      ),
    );
  }

}
