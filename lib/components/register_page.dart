import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
    const RegisterPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              Text("Register",
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

}