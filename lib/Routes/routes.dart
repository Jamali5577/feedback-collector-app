import 'package:flutter/material.dart';

import '../Screens/login_screen.dart';
import '../Screens/signup_screen.dart';

class AppRoutes{
  static const String loginPage = "/login";
 
  static const String signupScreen = '/signup';
 


  static Map<String, WidgetBuilder> getRoutes(){
    return {
      loginPage :(context) => LoginScreen(),
   
    
      signupScreen :(context)=> SignupScreen(),
     
    };
  }
}