import 'package:feedback_collector_app/Constant/colors.dart';
import 'package:feedback_collector_app/Providers/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


class AuthProvider extends ChangeNotifier {
  bool isLoading=false;
  bool get loading => isLoading;
  Future<void> signUp(BuildContext context,String fName, lName, String email, String password) async {
    isLoading = true;
    notifyListeners();
   
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
          addUser(context,userCredential.user!.uid.toString(), fName, lName, email, password);

      floatingSnackBar(message: "User Signed Up Successfuly!", context: context, backgroundColor: greenColor, textColor: whiteColor);
     
    } catch (e) {
      floatingSnackBar(message: "User Signed Up Failed!", context: context, backgroundColor: primary, textColor: whiteColor);
    
      // You can add error handling here, like showing a snackbar or dialog
    }
    isLoading =false;
    notifyListeners();
  }

  // Add Users Function

   final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
   Future<void> addUser(
      BuildContext context,String userid, String fName, lName, String email, String password) async {
        isLoading = true;
        notifyListeners();
    try{
      await dbRef.child('Users/$userid').set({
      'userId': userid,
      'fName': fName,
      'lName': lName,
      'email': email,
      'password': password,
      'contact':'',
      'address': '',
      'department':'',
      'date':'',
      'picture': '',
      'role': 2,
      'status': 0
    });
    floatingSnackBar(message: "User Added Successfuly!", context: context, backgroundColor: greenColor, textColor: whiteColor);
    }catch(err){
      floatingSnackBar(message: "User Added Successfuly!", context: context, backgroundColor: primary, textColor: whiteColor);
      
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(BuildContext context,String userId, String fName, String lName, String contact,String department)async{
    isLoading = true;
    notifyListeners();
    try {
      
     await dbRef.child("Users/$userId").update({
      'fName':fName,
      'lName':lName,
      'contact':contact,
      'department':department,
     });
     Provider.of<UserDetails>(context, listen: false).updateUserPreferences(fName, lName, contact,department);
     floatingSnackBar(message: "Profile Updated Successfully!", context: context, backgroundColor: greenColor, textColor: whiteColor);
     



    }catch(err){
      floatingSnackBar(message: "$err", context: context);


    }
    isLoading= false;
    notifyListeners();
   
  }

  

}
