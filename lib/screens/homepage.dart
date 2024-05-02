import 'dart:io';

import 'package:firebaseintro/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImagePicker _imagePicker;
  XFile? selectedImage;
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<UserModel> _getUser() async {
    User? loggedInUser = FirebaseAuth.instance.currentUser;

    if (loggedInUser != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      var userInfo = await db.collection("users").doc(loggedInUser.uid).get();
      var userJson = userInfo.data();
      UserModel userModel = UserModel.fromMap(userJson!);

      return userModel;
    }
    throw Exception("");
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      try {
        setState(() {
          avatarUrl = "abc"; // Profil resmi URL'si atanıyor
        });
      } catch (e) {
        debugPrint("AvatarUrl atama hatası: $e");
      }
    }
  }

  Future<void> addedAvatarUrl({
    required String avatarUrl,
  }) async {
    try {
      User? loggedInUser = FirebaseAuth.instance.currentUser;
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db
          .collection("users")
          .doc(loggedInUser!.uid)
          .set({"avatarUrl": avatarUrl}, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Avatar URL ekleme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireBase app"),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Başarıyla çıkış yapıldı"),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Çıkış yapılırken hata oluştu"),
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _pickImage, // İmage picker fonksiyonu atandı
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: selectedImage != null
                  ? Image.file(
                      // Seçilen görüntüyü göster
                      File(selectedImage!.path),
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      // Görüntü yoksa ikon göster
                      Icons.add_photo_alternate_rounded,
                      size: 50,
                      color: Colors.black,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              height: 40,
              width: 110,
              child: ElevatedButton(
                onPressed: () {
                  addedAvatarUrl(
                      avatarUrl:
                          avatarUrl); // Fonksiyonu çağırırken resmin URL'sini de gönder
                },
                child: const Text("Güncelle"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Center(
              child: FutureBuilder(
                future: _getUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Veri yükleniyor.");
                  } else {
                    return Text(
                      "Hoşgeldiniz ${snapshot.data!.firstName} ${snapshot.data!.lastName}",
                      style: const TextStyle(fontSize: 20),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
