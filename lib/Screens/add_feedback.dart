import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedback_collector_app/Constant/colors.dart';
import 'package:feedback_collector_app/Constant/device_info.dart';
import 'package:feedback_collector_app/Constant/font_size.dart';
import 'package:feedback_collector_app/Widgets/text1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFeedback extends StatefulWidget {
  const AddFeedback({super.key});

  @override
  State<AddFeedback> createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
 final TextEditingController titleController = TextEditingController();
final TextEditingController descController = TextEditingController();
int rating = 0;

Future<void> submitFeedback() async {
  final String user = FirebaseAuth.instance.currentUser!.uid.toString();
  final String title = titleController.text.trim();
  final String description = descController.text.trim();

  if (title.isEmpty || description.isEmpty || rating == 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all fields and give a rating."),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  try {
    // Reference to Firestore collection
    final feedbackCollection =
        FirebaseFirestore.instance.collection('feedbacks');

    // Add new feedback document
    await feedbackCollection.add({
      'userId':user,
      'title': title,
      'description': description,
      'rating': rating,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Clear the fields
    titleController.clear();
    descController.clear();
    setState(() {
      rating = 0;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Feedback submitted successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back to home screen
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    backgroundColor: primary,
    centerTitle: true,
    foregroundColor: whiteColor,
    title: Text1(fontColor: whiteColor, fontSize: 22, text: "Add Feedback",weight: FontWeight.bold),
  ),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight*0.05,),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: "Feedback Title",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: descController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: "Feedback Description",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        Text("Rate Us", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () => setState(() => rating = index + 1),
            );
          }),
        ),
        SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: submitFeedback,
          icon: Icon(Icons.send),
          label: Text1(fontColor: whiteColor, fontSize: header6, text: "Submit Feedback"),
          style: ElevatedButton.styleFrom(
            iconColor: whiteColor,
            backgroundColor: primary,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    ),
  ),
);

  }
}