
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';
import 'package:monirth_memories/core/logger.dart';
import 'package:logger/logger.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(){
    // init();
  }

  bool showProgressBar = false;
  final Logger log = getLogger('NotificationScreenViewModel');

  // List<NotificationModel> notificationModelList = <NotificationModel>[];
  List notificationModelList = [];
  // late Future<ListResult> dukhnaPhotoList;
  //  late Future<List<FirebaseFile>> futureFiles;
  // late Future<ListResult> futureFiles;
  // final FirebaseFirestore fb = FirebaseFirestore.instance;

  init() async {
    // await getDukhnaPhoto();
  }
  // Future<String> getImg() async {
  //   var aa = await FirebaseStorage.instance.ref('dukhna/photo/IMG_0443.JPG').getDownloadURL();
  //   print('getImg => aa : $aa');
  //   return aa;
  // }
  // Future getDukhnaPhoto() async {
  //   // String aa = await FirebaseStorage.instance.ref('dukhna/photo/IMG_0443.JPG').getDownloadURL();//get on image
  //   // print('====> aa : $aa');
  //   // dukhnaPhotoList =  FirebaseStorage.instance.ref('/dukhna/photo/').listAll();
  //   FirebaseAuth.instance.authStateChanges().listen((event) { 
  //     log.d('firebase_auth: ${event.toString()}');
  //   });
  //   // final storage = FirebaseStorage.instanceFor(bucket: "gs://cardmaker-95ba3.appspot.com",);
  //   // var s = await storage.ref('dukhna/photo/IMG_0443.JPG').getDownloadURL();
  //   // print('getImg => s : $s');
  //   futureFiles = FirebaseApi.listAllCopy('dukhna/photo/');

  //   // print('====> a  :$a');
  //   // print('====> b : ${b.items}');
  //   // for (int i = 0; i < b.items.length; i++) {
  //   //   dukhnaPhotoList.add(await b.items[i]);
  //   // }
  //   // return dukhnaPhotoList;
  //   // return b;
  //   // return FirebaseStorage.instance.ref().child("dukhna/photo/").getData();
  // }
  
  // Future<List<String>> getDukhnaPhotoList() async {
  //   String a = await FirebaseStorage.instance
  //       .ref('dukhna/photo/IMG_0443.JPG')
  //       .getDownloadURL(); //get on image
  //   print('====> a  :$a');
  //   var b = await FirebaseStorage.instance.ref('dukhna/photo/').list();
  //   var d = await b.items.first.getDownloadURL();
  //   print('====> d : ${d}');
  //   for (int i = 0; i < b.items.length; i++) {
  //     dukhnaPhotoList.add(await b.items[i].getDownloadURL());
  //   }
  //   print('====> b : dukhnaPhotoList : ${dukhnaPhotoList}');
  //   return dukhnaPhotoList;
  //   // return b;
  //   // return FirebaseStorage.instance.ref().child("dukhna/photo/").getData();
  // }

  // Future<UserCredential> 
  // signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   print('signInWithGoogle => displayName : ${googleUser!.displayName}');
  //   print('signInWithGoogle => email : ${googleUser.email}');
  //   print('signInWithGoogle => googleUser : ${googleUser.id}');
  //   print('signInWithGoogle => googleUser : ${googleUser.photoUrl}');
  //   print('signInWithGoogle => googleUser : ${googleUser.authentication}');
  //   print('signInWithGoogle => googleUser : ${googleUser.serverAuthCode}');
  //   // print('googleUser  :${googleUser}');
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser.authentication;
  //   print('signInWithGoogle =>  googleAuth.accessToken : ${googleAuth?.accessToken}');
  //   print('signInWithGoogle => googleAuth.idToken : ${googleAuth?.idToken}');
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
    

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // Future<List?> getNotificationData() async {
  //   // List<NotificationModel> list = [];
  //   showProgressBar = true;
  //   notifyListeners();
  //   notificationModelList.clear();
  //   // SharedPreferences sp = await SharedPreferences.getInstance();
  //   // String userId = sp.getString(Globals.userIdPrefKey)!;
  //   final firebaseRef = FirebaseDatabase(
  //     databaseURL:
  //         // "https://clu-mobile-default-rtdb.asia-southeast1.firebasedatabase.app",
  //         "gs://cardmaker-95ba3.appspot.com",
  //   ).ref().child("dukhna/photo/");

  //   await firebaseRef
  //       // .orderByChild('userId')
  //       // .equalTo(userId)
  //       .get()
  //       .then((value) {
  //     // notificationModelList = value.children.map((d) => NotificationModel.fromJson(d.value, key: d.key!)).toList()
  //     // notificationModelList = value.children.map((d) => notificationModelList.asMap.(d.value, key: d.key!)).toList()
  //     // ..sort((a, b) => b.date!.compareTo(a.date!));
  //     log.i(
  //         'readData => value : ${value.children.length} || ${value.children}');
  //   }).onError((error, stackTrace) {
  //     log.i('readData => error : $error');
  //   });
  //   showProgressBar = false;
  //   notifyListeners();
  //   return notificationModelList;
  // }
}
