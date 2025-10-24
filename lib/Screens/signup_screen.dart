import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import 'package:provider/provider.dart';

import '../../Widgets/custom_rounded_btn.dart';

import '../Constant/colors.dart';
import '../Constant/device_info.dart';
import '../Constant/font_size.dart';
import '../Providers/auth_provider.dart';
import '../Widgets/text1.dart';
import '../Widgets/text_field_withicon.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

 class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _farm = GlobalKey<FormState>();
  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController(); 

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController password = TextEditingController();

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
                          "SignUp Here",
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
                    
                        
                       
                          Consumer<AuthProvider>(
                            builder: (context, value, child) => 
                             customRoundedButton(title: "SignUp", loading: value.loading, on_Tap: () async{
                              if(_farm.currentState!.validate()){
                                 Provider.of<AuthProvider>(context, listen: false).signUp(context,fName.text,lName.text,_emailController.text.toString(), password.text);
                                
                                 }
                             
                                                     },),
                          ),
                       
                         SizedBox(height: screenHeight*0.022),
                    
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text1(fontColor: blackColor, fontSize: paragraph, text: "Already have an Account"),
                            TextButton(onPressed: (){
                              Navigator.pushReplacementNamed(context, '/login');

                            }, child: Text1(fontColor: Colors.blue.shade400, fontSize: paragraph, text: "login!", weight: FontWeight.bold,))
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
        textFieldWithIconWidget(widgetcontroller: fName, validatorCallback: ValidationBuilder().minLength(3).maxLength(9).build(), fieldName: "First Name", isPasswordField: false, widgeticon: Icons.person_2_outlined,),
         SizedBox(height: screenHeight*0.035,),
         textFieldWithIconWidget(widgetcontroller: lName, validatorCallback: ValidationBuilder().minLength(3).maxLength(9).build(), fieldName: "Last Name", isPasswordField: false, widgeticon: Icons.person_2_outlined,),
          SizedBox(height: screenHeight*0.035,),
        textFieldWithIconWidget(fieldName: "Email",isPasswordField: false,widgetcontroller: _emailController,widgeticon: Icons.email,validatorCallback: ValidationBuilder().email().maxLength(50).build(),),
          SizedBox(height: screenHeight*0.035,),
         textFieldWithIconWidget(widgetcontroller: password, fieldName: "password", isPasswordField: true, widgeticon: Icons.key, validatorCallback:  ValidationBuilder().minLength(6).maxLength(20).build(),)
         
          
        
        ],
      ),
    );
  }
}

