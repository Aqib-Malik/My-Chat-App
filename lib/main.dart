// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_auth/Provider/account_provder.dart';
// import 'package:flutter_auth/Provider/isloading_provider.dart';
// import 'package:flutter_auth/Screens/chat_screen/chat_Screen.dart';
// import 'package:flutter_auth/Screens/start_up/start_up.dart';
// import 'package:flutter_auth/constants.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
//   print(message.data);
//   flutterLocalNotificationsPlugin.show(
//       message.data.hashCode,
//       message.data['title'],
//       message.data['body'],
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channel.description,
//         ),
//       ));
// }

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   runApp(MultiProvider(providers: [
//     ChangeNotifierProvider(
//       create: (_) => AccountProvider(),
//     ),
//     ChangeNotifierProvider(
//       create: (_) => IsLoadingProvider(),
//     ),
//   ], child: MyApp()));
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String token;

//   @override
//   void initState() {
//     super.initState();
//     var initialzationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initialzationSettingsAndroid);

//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channel.description,
//                 icon: android?.smallIcon,
//               ),
//             ));
//       }
//     });
//     getToken();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//         routes: {'/chartscreen': (context) => chatScreen()},
//         debugShowCheckedModeBanner: false,
//         title: 'Chat App',
//         theme: ThemeData(
//           //brightness: Brightness.dark,
//           primaryColor: kPrimaryColor,
//           scaffoldBackgroundColor: Colors.white,
//         ),
//         home: startUp() //WelcomeScreen(),
//         );
//   }

//   getToken() async {
//     token = await FirebaseMessaging.instance.getToken();
//     setState(() {
//       token = token;
//     });
//     print(token);
//   }
// }
// // android:name="io.flutter.app.FlutterApplication"

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
//   print(message.data);
//   flutterLocalNotificationsPlugin.show(
//       message.data.hashCode,
//       message.data['title'],
//       message.data['body'],
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channel.description,
//         ),
//       ));
// }

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String token;
//   List subscribed = [];
//   List topics = [
//     'Samsung',
//     'Apple',
//     'Huawei',
//     'Nokia',
//     'Sony',
//     'HTC',
//     'Lenovo'
//   ];
//   @override
//   void initState() {
//     super.initState();
//     var initialzationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings =
//         InitializationSettings(android: initialzationSettingsAndroid);

//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification;
//       AndroidNotification android = message.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channel.description,
//                 icon: android?.smallIcon,
//               ),
//             ));
//       }
//     });
//     getToken();
//     getTopics();
//     FirebaseMessaging.instance.subscribeToTopic('hello');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: Text('appbar'),
//           ),
//           body: ListView.builder(
//             itemCount: topics.length,
//             itemBuilder: (context, index) => ListTile(
//               title: Text(topics[index]),
//               trailing: subscribed.contains(topics[index])
//                   ? ElevatedButton(
//                       onPressed: () async {
//                         await FirebaseMessaging.instance
//                             .unsubscribeFromTopic(topics[index]);
//                         await FirebaseFirestore.instance
//                             .collection('topics')
//                             .doc(token)
//                             .update({topics[index]: FieldValue.delete()});
//                         setState(() {
//                           subscribed.remove(topics[index]);
//                         });
//                       },
//                       child: Text('unsubscribe'),
//                     )
//                   : ElevatedButton(
//                       onPressed: () async {
//                         await FirebaseMessaging.instance
//                             .subscribeToTopic(topics[index]);
//                         print(topics[index]);

//                         await FirebaseFirestore.instance
//                             .collection('topics')
//                             .doc(token)
//                             .set({topics[index]: 'subscribe'},
//                                 SetOptions(merge: true));
//                         setState(() {
//                           subscribed.add(topics[index]);
//                         });
//                       },
//                       child: Text('subscribe')),
//             ),
//           )),
//     );
//   }

//   getToken() async {
//     token = await FirebaseMessaging.instance.getToken();
//     setState(() {
//       token = token;
//     });
//     print(token);
//   }

//   getTopics() async {
//     await FirebaseFirestore.instance
//         .collection('topics')
//         .get()
//         .then((value) => value.docs.forEach((element) {
//               if (token == element.id) {
//                 subscribed = element.data().keys.toList();
//               }
//             }));

//     setState(() {
//       subscribed = subscribed;
//     });
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Provider/account_provder.dart';
import 'package:flutter_auth/Provider/isloading_provider.dart';
import 'package:flutter_auth/Screens/chat_screen/chat_Screen.dart';
import 'package:flutter_auth/Screens/start_up/start_up.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AccountProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => IsLoadingProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {'/chartscreen': (context) => chatScreen()},
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
          //brightness: Brightness.dark,
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: startUp() //WelcomeScreen(),
        );
  }
}









//android:name="io.flutter.app.FlutterApplication"