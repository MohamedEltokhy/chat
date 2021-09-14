import 'dart:io';

import 'package:chat/widgets/picker/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {

  final void Function(String email,String password,
      String username,File image,bool isLogin,BuildContext ctx) submitFn;
  bool _isLoading;
  AuthForm(this.submitFn, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey =GlobalKey<FormState>();
  bool _isLogin = true;
  String _email ="";
  String _password ="";
  String _userName ="";
  File? _userImageFile;

  void _pickedImage(File pickedImage){
    _userImageFile = pickedImage;
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if( !_isLogin && _userImageFile == null){
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content:Text("Please Pick an Image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if(isValid){
      _formKey.currentState!.save();
      widget.submitFn(
          _email.trim(),_password.trim(),_userName.trim(),_userImageFile!,_isLogin,context
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  key: ValueKey('email'),
                  validator: (val){
                    if(val!.isEmpty || !val.contains('@')){
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (val)=> _email = val!,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address"),
                ),
                if(!_isLogin)
                  TextFormField(
                    autocorrect: true,
                    key: ValueKey('username'),
                    validator: (val){
                      if(val!.isEmpty || val.length < 4){
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (val)=> _userName = val!,
                    decoration: InputDecoration(labelText: "User Name"),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (val){
                    if(val!.isEmpty || val.length < 7){
                      return 'Password must be at least 7 characters';
                    }
                    return null;
                  },
                  onSaved: (val)=> _password = val!,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(height: 12,),
                if(widget._isLoading)
                  CircularProgressIndicator(),
                if(!widget._isLoading)
                RaisedButton(
                    child:Text(_isLogin ? 'Login' : 'Sign Up'),
                    onPressed: _submit
                ),
                if(!widget._isLoading)
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(_isLogin
                      ? 'Create new account'
                      : 'I ready have account'
                  ),
                  onPressed: (){
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
