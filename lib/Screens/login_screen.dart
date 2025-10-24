import 'package:feedback_collector_app/Screens/add_feedback.dart';
import 'package:feedback_collector_app/Screens/admin_screen.dart';
import 'package:feedback_collector_app/Screens/home_screen.dart';
import 'package:feedback_collector_app/Widgets/custom_rounded_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant/colors.dart';
import '../Constant/device_info.dart';
import '../Constant/font_size.dart';
import '../Providers/user_details.dart';
import '../Widgets/text1.dart';
import '../Widgets/text_field_withicon.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

 class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _farm = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();
  String userRole='';


   Future<void> getUserData(String userId) async {
    final databaseRef = await FirebaseDatabase.instance.ref('Users');
    await databaseRef.child(userId).once().then((val) {
       //userRole = val.snapshot.child('role').value.toString();
     
      Provider.of<UserDetails>(context, listen: false)
          .setUsersDetails(val.snapshot);

      //Provider.of<UserDetails>(context).setUserPreferences();

      // print("Username :  " +
      //   Provider.of<UserDetails>(context, listen: false).userName.toString());
      // print("password :  " +
      // Provider.of<UserDetails>(context, listen: false).password.toString());
    });
  }

  bool isLogined = false;
  bool isLoading = false;
  checkIfLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final uid = pref.getString("id");
    if (uid != "" && uid != null) {
      userRole = pref.getInt('role').toString();

      setState(() {
        isLogined = true;
        Provider.of<UserDetails>(context, listen: false)
            .getUsersDetailsFromPref();
           if(userRole == '1'){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminScreen()));
           }else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
           }
         
       

      });
    }
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
 Widget build(BuildContext context) {
   
    return Scaffold(
      body: Container(
       
        decoration:  BoxDecoration(
         color: primary
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             
              Container(
                padding:  EdgeInsets.only(top: screenHeight*.055, left: screenWidth*.05, right: screenWidth*.05),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                     SizedBox(height: screenHeight*.025),
                     Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image(image: AssetImage('assets/log.png'),width: screenWidth/2,))
                    ),
                    SizedBox(height: screenHeight*.10,)
                  ],
                ),
              ),

             
              Material(
               // elevation: 6,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  height: screenHeight/1.3,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                     
                      children: [
                        
                         Text(
                          "Welcome Back",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth*0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         SizedBox(height: screenHeight*0.025),
                        const Text(
                          "Enter your details below",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                         SizedBox(height: screenHeight*0.018),
                      
                        textFieldContainer(),
                        SizedBox(height: screenHeight*0.035,),
                    
                        
                       
                          customRoundedButton(title: "Login", loading: isLoading, on_Tap: () async{
                            isLoading = true;
                            setState(() {
                              
                            });
                            
                            if(_farm.currentState!.validate()){
                             // Navigator.push(context, MaterialPageRoute(builder: (_)=>AdminNavigations()));
                              userLogin(email.text, password.text);
                                            
                                           }
                           
                         },),
                       
                         SizedBox(height: screenHeight*0.022),
                    
                       
                        TextButton(
                          onPressed: () async{
                           // Navigator.pushNamed(context, "/userNavigations");
                          //final name=  Provider.of<UserDetails>(context, listen: false).name;
                          //print("name of user $name");

                           
                           // Navigator.push(context, MaterialPageRoute(builder: (_)=> const SignUp()));

                            // Handle Forgot Password
                          },
                          child: const Text(
                            "Forgot your password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text1(fontColor: blackColor, fontSize: paragraph, text: "If Don't have an Account"),
                            TextButton(onPressed: (){
                              Navigator.pushReplacementNamed(context, '/signup');

                            }, child: Text1(fontColor: Colors.blue.shade400, fontSize: paragraph, text: "SignUP!", weight: FontWeight.bold,))
                          ],
                        )
                        
                    
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldContainer() {
    return Form(
      key: _farm,
      child: Column(
        children: [
        textFieldWithIconWidget(fieldName: "Email",isPasswordField: false,widgetcontroller: email,widgeticon: Icons.email,validatorCallback: ValidationBuilder().email().maxLength(50).build(),),
          SizedBox(height: screenHeight*0.035,),
         textFieldWithIconWidget(widgetcontroller: password, fieldName: "password", isPasswordField: true, widgeticon: Icons.key, validatorCallback:  ValidationBuilder().minLength(6).maxLength(20).build(),)
         
          
        
        ],
      ),
    );
  }

  void userLogin(String email, String password) async {
    if (email == '' || password == '') {
      setState(() {
        isLoading = true;
      });
      //UiHelper.CustomAlertBox(context, 'Enter Required Fields');
    } else {
      UserCredential? userCredential;
      try {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((val) async {
          if (val.user!.uid != "") {
           // print("Login Id = " + val.user!.uid.toString());
            await Future.value(getUserData(val.user!.uid.toString()));
             final databaseRef = await FirebaseDatabase.instance.ref('Users');
    await databaseRef.child(val.user!.uid).once().then((val) {
      String role = val.snapshot.child('role').value.toString();
      if(role == '1'){
         Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => AdminScreen()));

      }else{
         Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    });

            
          }
        }).onError(
          (error, stackTrace) {
            //UiHelper.CustomAlertBox(context, error.toString());
            setState(() {
              isLoading = false;
            });
          },
        );
      } catch (e) {
       // UiHelper.CustomAlertBox(context, e.toString());
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

