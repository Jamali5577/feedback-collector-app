import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetails extends ChangeNotifier {
  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String? userId;
  String? FName;
  String? LName;
  String? email;
  String? password;
  String? picUrl;
  String? address;
  String? contact;
  String? department;
  String? date;
  int? role;

  void setUsersDetails(DataSnapshot snapshot) {
    if (snapshot.value != "" && snapshot.value != null) {
      userId = snapshot.child('userId').value.toString();
      FName = snapshot.child('fName').value.toString();
      LName = snapshot.child('lName').value.toString();
      email = snapshot.child('email').value.toString();
      password = snapshot.child('password').value.toString();
      address = snapshot.child('address').value.toString();
      contact = snapshot.child('contact').value.toString();
      department = snapshot.child('department').value.toString();
      date = snapshot.child('date').value.toString();
      
      role = int.parse(snapshot.child("role").value.toString());
      picUrl = snapshot.child('picture').value.toString();

      notifyListeners();
      //here we store the preferences of bthe user
      setUserPreferences();
      // getUsersDetailsFromPref();
    }
  }

  void getUsersDetailsFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id');
    FName = prefs.getString('fName');
    LName = prefs.getString('lName');
    email = prefs.getString('email');
    address = prefs.getString('address');
    contact = prefs.getString('contact');
    department = prefs.getString('department');
    date = prefs.getString('date');
    
    role = prefs.getInt('role');
    picUrl = prefs.getString('picture');

    
    notifyListeners();
  }

  void setUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email!);
    prefs.setString('id', userId!);
    prefs.setString('fName', FName!);
    prefs.setString('lName', LName!);
    prefs.setString('address', address!);
    prefs.setString('contact', contact!);
    prefs.setString('department', department!);
    prefs.setString('date', date!);
    
    prefs.setInt('role', int.parse(role.toString()));
    prefs.setString('picture', picUrl!);

    notifyListeners();
  }

  void updateUserPreferences(String username, LName,  String contact, String department) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fName', username);
    prefs.setString('lName', LName);
    //prefs.setString('picture', savedImage);
   
    prefs.setString('contact', contact);
     prefs.setString('department',department);
     getUsersDetailsFromPref();

   

    notifyListeners();
  }

  

  

 
}
