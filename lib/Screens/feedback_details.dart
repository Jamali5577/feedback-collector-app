import 'package:feedback_collector_app/Constant/colors.dart';
import 'package:feedback_collector_app/Constant/font_size.dart';
import 'package:feedback_collector_app/Widgets/text1.dart';
import 'package:flutter/material.dart';

class FeedbackDetails extends StatefulWidget {
 final String title, description;
 final int rating;
 
  const FeedbackDetails({super.key, required this.title, required this.description, required this.rating,});

  @override
  State<FeedbackDetails> createState() => _FeedbackDetailsState();
}

class _FeedbackDetailsState extends State<FeedbackDetails> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
  appBar: AppBar(
    centerTitle: true,
    backgroundColor: primary,
    foregroundColor: whiteColor,
    title: Text1(fontColor: whiteColor, fontSize: 22, text: "Feedback Details", weight: FontWeight.bold,),
    ),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
      
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurStyle: BlurStyle.outer,
              offset: Offset(2, 2)
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              
              SizedBox(height: 10),
              Text(widget.description, style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(5, (i) => Icon(
                      i < widget.rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    )),
                    
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);

  }
}