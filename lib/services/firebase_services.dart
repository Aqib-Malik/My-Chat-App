import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/services/some_methods/someMethods.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth/Screens/start_up/start_up.dart';

// ignore: camel_case_types
class authServices {
  static String message;
  SharedPreferences prefs;

  ///****Create Account on firebase******/
  static Future<bool> createStuwithemailandpass(
      Map userData, String pass, String email) async {
    try {
      //UserCredential userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .set(userData);
        SomeMethods.toastShow('Congragulation you successfully SignUp');
        return true;

        //_users.id=userCredential.user[uid];
      });
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        SomeMethods.toastShow('The password provided is too weak.');
        //print('The password provided is too weak.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        SomeMethods.toastShow('The account already exists for that email.');
        return false;
        //print('The account already exists for that email.');
      }
    } catch (e) {
      SomeMethods.toastShow('e.toString()');

      print(e);
      return null;
    }
    return null;
  }

  ///****Sign in with Email and Password on firebase******/
  // ignore: missing_return
  static Future<bool> signinwithemailandpass(String email, String pass) async {
    try {
      //UserCredential userCredential =
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((value) async {
        SomeMethods.toastShow('Congragulation you successfully SignIn');

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('email', email);

        return;
      });
      finalemail = email;
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        SomeMethods.toastShow('No user found for that email.');

        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        SomeMethods.toastShow('Wrong password provided for that user.');

        print('Wrong password provided for that user.');
        return false;
      }
    }
  }

  ///****Sign Out on firebase******/
  static Future<void> signout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut().then((value) {
          SomeMethods.toastShow('Log out');
          finalemail = null;
        });
      } on FirebaseAuthException catch (e) {
        SomeMethods.toastShow(e.message.toString());
      }
    }
  }

  ///****Sign in with Google account on firebase******/
  static Future<void> googleSignin() async {
    //List arr;
    String _name;
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      List<String> splitList = googleUser.displayName.split(' ');
      ////checking user name is valid or not
      if (SomeMethods.splitUserName(splitList) != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(googleUser.email)
            .set({
          'name': googleUser.displayName,
          'email': googleUser.email,
          'photoUrl': googleUser.photoUrl,
          'searchIndex': SomeMethods.splitUserName(splitList), //indexList,
          'status': 'online',
        });
        finalemail = googleUser.email;
      } else {
        _name = googleUser.displayName.replaceAll(' ', '');

        ///for removing spaces
        List<String> nsplitList = _name.split(' ');
        FirebaseFirestore.instance
            .collection('users')
            .doc(googleUser.email)
            .set({
          'name': _name,
          'email': googleUser.email,
          'photoUrl': googleUser.photoUrl,
          'searchIndex': SomeMethods.splitUserName(nsplitList), //indexList,
          'status': 'online',
        });
        finalemail = googleUser.email;
      }
    });
  }

  ///****Deleteuser Account on firebase******/

  static Future<void> deleteAccount(String email) async {
    await FirebaseAuth.instance.currentUser.delete().then((value) {
      FirebaseFirestore.instance.collection('users').doc(finalemail).delete();
    });
  }

  ///****Update userU on firebasae******/
  static void update(String sts, String email) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(finalemail)
        .update({
      'status': sts,
    });
  }

  ///****Update userPic on firebasae******/
  static void updatePhoto(String url, String email) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(finalemail)
        .update({'photoUrl': url});
  }

  ///check internet connection
  static Future<bool> checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      SomeMethods.toastShow("make sure your internet is connected");
      return false;
    } else if (result == ConnectivityResult.mobile) {
      //toastShow("You are using mobile data");
      return true;
    } else if (result == ConnectivityResult.wifi) {
      //toastShow("You are using Wifi");
      return true;
    }
    return null;
  }

  ///****Update userName on firebasae******/
  static void updateName(String name, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'name': name,
    }).then((value) => SomeMethods.toastShow("User Name updated successfully"));
  }
}

























































// ignore: camel_case_types
// class authServices {
//   static String message;
//   SharedPreferences prefs;

//   ///****Create Account on firebase******/
//   static Future<bool> createStuwithemailandpass(
//       Map userData, String pass, String email) async {
//     try {
//       //UserCredential userCredential =
//       await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: pass)
//           .then((value) async {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(email)
//             .set(userData);
//         SomeMethods.toastShow('Congragulation you successfully SignUp');
//         return true;

//         //_users.id=userCredential.user[uid];
//       });
//       return true;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         SomeMethods.toastShow('The password provided is too weak.');
//         //print('The password provided is too weak.');
//         return false;
//       } else if (e.code == 'email-already-in-use') {
//         SomeMethods.toastShow('The account already exists for that email.');
//         return false;
//         //print('The account already exists for that email.');
//       }
//     } catch (e) {
//       SomeMethods.toastShow('e.toString()');

//       print(e);
//       return null;
//     }
//     return null;
//   }

//   //sign in
//   Future signinwithemailandpass(String email, String pass) async {
//     try {
//       // ignore: unused_local_variable
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: pass);

//       //create a new data
//       SharedPreferences sharedPreferences =
//           await SharedPreferences.getInstance();
//       sharedPreferences.setString('email', email);
//       finalemail = email;
//       SomeMethods.toastShow('Congragulation you successfully SignUp');

//       //_users.id=userCredential.user[uid];

//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         SomeMethods.toastShow('The password provided is too weak.');
//         //print('The password provided is too weak.');
//         return false;
//       } else if (e.code == 'email-already-in-use') {
//         SomeMethods.toastShow('The account already exists for that email.');
//         return false;
//         //print('The account already exists for that email.');
//       }
//     } catch (e) {
//       SomeMethods.toastShow('e.toString()');

//       print(e);
//       return null;
//     }
//     return null;
//   }

//   ///****Sign Out on firebase******/
//   static Future<void> signout() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         await FirebaseAuth.instance.signOut().then((value) {
//           SomeMethods.toastShow('Log out');
//           //finalemail = null;
//         });
//       } on FirebaseAuthException catch (e) {
//         SomeMethods.toastShow(e.message.toString());
//       }
//     }
//   }

//   ///****Sign in with Google account on firebase******/
//   static Future<void> googleSignin() async {
//     //List arr;
//     String _name;
//     final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;

//     final GoogleAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

//     await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
//       List<String> splitList = googleUser.displayName.split(' ');
//       ////checking user name is valid or not
//       if (SomeMethods.splitUserName(splitList) != null) {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(googleUser.email)
//             .set({
//           'name': googleUser.displayName,
//           'email': googleUser.email,
//           'photoUrl': googleUser.photoUrl,
//           'searchIndex': SomeMethods.splitUserName(splitList), //indexList,
//           'status': 'online',
//         });
//         //finalemail = googleUser.email;
//       } else {
//         _name = googleUser.displayName.replaceAll(' ', '');

//         ///for removing spaces
//         List<String> nsplitList = _name.split(' ');
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(googleUser.email)
//             .set({
//           'name': _name,
//           'email': googleUser.email,
//           'photoUrl': googleUser.photoUrl,
//           'searchIndex': SomeMethods.splitUserName(nsplitList), //indexList,
//           'status': 'online',
//         });
//         //finalemail = googleUser.email;
//       }
//     });
//   }

//   ///****Deleteuser Account on firebase******/

//   static Future<void> deleteAccount(String email) async {
//     await FirebaseAuth.instance.currentUser.delete().then((value) {
//       FirebaseFirestore.instance.collection('users').doc(email).delete();
//     });
//   }

  // ///****Update userName on firebasae******/
  // static void updateName(String name, String email) async {
  //   await FirebaseFirestore.instance.collection('users').doc(email).update({
  //     'name': name,
  //   }).then((value) => SomeMethods.toastShow("User Name updated successfully"));
  // }

//   ///****Update userU on firebasae******/
//   static void update(String sts, String email) async {
//     await FirebaseFirestore.instance.collection('users').doc(email).update({
//       'status': sts,
//     });
//   }

//   ///****Update userPic on firebasae******/
//   static void updatePhoto(String url, String email) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(email)
//         .update({'photoUrl': url});
//   }

//   ///check internet connection
//   static Future<bool> checkConnection() async {
//     var result = await Connectivity().checkConnectivity();
//     if (result == ConnectivityResult.none) {
//       SomeMethods.toastShow("make sure your internet is connected");
//       return false;
//     } else if (result == ConnectivityResult.mobile) {
//       //toastShow("You are using mobile data");
//       return true;
//     } else if (result == ConnectivityResult.wifi) {
//       //toastShow("You are using Wifi");
//       return true;
//     }
//     return null;
//   }
// }
