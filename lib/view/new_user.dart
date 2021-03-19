import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast_example/providers/user_provider.dart';
import 'package:sembast_example/model/user.dart';
import 'package:sembast_example/view/home_screen.dart';

class NewUserScreen extends StatefulWidget {

  final User _user;

  NewUserScreen(this._user);

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _switchValue = false;

  TextEditingController _userIdController;
  TextEditingController _userNameController;
  TextEditingController _userEmailController;
  TextEditingController _userPhoneController;

  @override
  void initState() {
    _userIdController = TextEditingController();
     _userNameController = TextEditingController();
     _userEmailController = TextEditingController();
     _userPhoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget._user != null){
      _userIdController.text = widget._user.userId.toString();
      _userNameController.text = widget._user.name;
      _userEmailController.text = widget._user.email;
      _userPhoneController.text = widget._user.phone;
      _switchValue = widget._user.isAdmin;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('New user'),
        actions: [
          Padding(
            padding:  EdgeInsets.only(right :16.0),
            child: InkWell(
              child: Icon(
                Icons.add,
                size: 24,
                color: Colors.white,
              ),
              onTap: () {
                if(_formKey.currentState.validate()){
                  (widget._user == null)?_storeUser():_updateUser();
                }
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _userIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'User iD',
                    hintText: 'User ID',
                  ),
                  validator: (value){
                    if(value.length == 0){
                      return 'User ID is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _userNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'User name',
                    hintText: 'User name',
                  ),
                  validator: (value){
                    if(value.length == 0){
                      return 'User name is required';
                    }else if(value.length <= 3){
                      return 'Name given is short';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _userEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'User email',
                    hintText: 'User email',
                  ),
                  validator: (value){
                    if(value.length == 0){
                      return 'User email is required';
                    }else if(value.length <= 3){
                      return 'Email given is short';
                    }else if(! value.contains('@') || ! value.contains('.com')){
                      return 'Email is invalid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8,),
                TextFormField(
                  controller: _userPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'User phone',
                    hintText: 'User phone',
                  ),
                  validator: (value){
                    if(value.length == 0){
                      return 'User phone is required';
                    }else if(value.length < 10){
                      return 'Phone given is short';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('User is admin' ,style: TextStyle(fontSize: 16),),
                    Switch(value: _switchValue, onChanged: (value){
                      setState(() {
                        _switchValue = value;
                      });
                    })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _storeUser()async {

    int userID = int.tryParse(_userIdController.text);
    String userName = _userNameController.text;
    String userEmail = _userEmailController.text;
    String userPhone = _userPhoneController.text;
    bool userIsAdmin = _switchValue;
    User user = User(userId: userID, name: userName, email: userEmail, phone: userPhone, isAdmin: userIsAdmin);
    Provider.of<UserProvider>(context,listen: false).insert(user);
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User is add with success')));
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _updateUser()async {

    int userID = int.tryParse(_userIdController.text);
    String userName = _userNameController.text;
    String userEmail = _userEmailController.text;
    String userPhone = _userPhoneController.text;
    print( _userIdController.text);
    bool userIsAdmin = _switchValue;
    User user = User(userId: userID, name: userName, email: userEmail, phone: userPhone, isAdmin: userIsAdmin);
    Provider.of<UserProvider>(context,listen: false).update(widget._user.id , user);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User is updated with success')));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
