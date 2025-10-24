import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_collector_app/Constant/colors.dart';
import 'package:feedback_collector_app/Screens/feedback_details.dart';
import 'package:feedback_collector_app/Screens/login_screen.dart';
import 'package:feedback_collector_app/Widgets/text1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant/font_size.dart';
import '../Providers/user_details.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  void clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', '');
    prefs.setString('name', '');
    prefs.setString('password', '');
    prefs.setString('id', '');
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
  appBar: AppBar(
    foregroundColor: whiteColor,
    backgroundColor: primary,
    title: Text1(fontColor: whiteColor, fontSize: 22, text: "User's Feedbacks",weight: FontWeight.bold),
    centerTitle: true,
    actions: [
      IconButton(onPressed: (){
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Text1(fontColor: blackColor, fontSize: header4, text: "Are you want to logout?"),
            //content: Text1(fontColor: blackColor, fontSize: paragraph, text: "Are you want to logout?"),
            actions: [
              TextButton(onPressed: (){
                FirebaseAuth.instance.signOut();
                clearPreferences();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

              }, child: Text1(fontColor: Colors.blue, fontSize: paragraph, text: "Yes", weight: FontWeight.bold,)),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text1(fontColor: Colors.red, fontSize: paragraph, text: "No", weight: FontWeight.bold,))
              
            ],
          );
        },);
      }, icon: Icon(Icons.logout_rounded))
    ],
  ),
  body: StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection('feedbacks')
      .orderBy('createdAt', descending: true)
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
    final feedbackDocs = snapshot.data!.docs;
    return ListView.builder(
      itemCount: feedbackDocs.length,
      itemBuilder: (context, index) {
        final data = feedbackDocs[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 8,
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedbackDetails(title: data['title'], description: data['description'], rating: data['rating'],)));
              },
               title: Padding(
                padding: const EdgeInsets.only( bottom: 8),
                child: Text1(fontColor: blackColor, fontSize: header5, text: data['title'], weight: FontWeight.bold,),
              ),
              
              subtitle: Text1(fontColor: blackColor, fontSize: paragraph, text: data['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  return Icon(
                    i < data['rating'] ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  },
),



 
);
  }
}