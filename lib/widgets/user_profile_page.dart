import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage(this.user, this.googleUser, this.signOut);
  final FirebaseUser user;
  final GoogleSignInAccount googleUser;
  final signOut;

  static const String routeName = 'user_profile';

  @override
  Widget build(BuildContext context) {
    print("Firebase user: "+user.toString());
    return Scaffold(
      appBar: AppBar(title: Text("User Profile") ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TODO: Cache profile photo
            Image.network(user.photoUrl),
            // TODO: Create display widgets for user attributes
            Text(user.displayName),
            Text("Email: "+user.email+
                (user.isEmailVerified?" (verified)":"(not verified)")
            ),
            Text("Phone Number: "+(user.phoneNumber!=null?user.phoneNumber:"none")),
            Text("Firebase uid: "+user.uid, textAlign: TextAlign.center,),
            Text("Identity Provider: "+user.providerData[0].providerId),
            Text("uid: "+user.providerData[0].uid),
            RaisedButton(
              child: Text("Sign Out"),
              onPressed: (){
                signOut();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}

