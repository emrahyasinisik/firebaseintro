import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  void _submit() async {
    _registerPage ? _register() : _login();
  }

  void _login() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      debugPrint("$_email , $_password");
    } on FirebaseAuthException catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Giriş Başarısız")));
    }
  }

  void _register() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email, password: _password);
    if (userCredential.user != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection("users").doc(userCredential.user!.uid).set({
        'firstName': _name,
        'lastName': _lastName,
        'email': _email,
        'registerdate': DateTime.now()
      });
    }
  }

  final _formkey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _name = "";
  String _lastName = "";
  bool _registerPage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Card(
                    color: _registerPage
                        ? const Color.fromARGB(255, 207, 207, 207)
                        : const Color.fromARGB(255, 230, 194, 194),
                    child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _registerPage ? "Kayıt ol" : "Giriş Yap",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "E-mail",
                                    labelStyle:
                                        TextStyle(color: Colors.blueGrey)),
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (newValue) {
                                  _email = newValue!;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Şifre",
                                      labelStyle:
                                          TextStyle(color: Colors.blueGrey)),
                                  autocorrect: false,
                                  obscureText: true,
                                  onSaved: (newValue) {
                                    _password = newValue!;
                                  }),
                            ),
                            if (_registerPage)
                              Column(
                                children: [
                                  TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: "isim",
                                          labelStyle: TextStyle(
                                              color: Colors.blueGrey)),
                                      onSaved: (newValue) {
                                        _name = newValue!;
                                      }),
                                  TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: "Soyisim",
                                          labelStyle: TextStyle(
                                              color: Colors.blueGrey)),
                                      onSaved: (newValue) {
                                        _lastName = newValue!;
                                      }),
                                ],
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ElevatedButton(
                                  style: const ButtonStyle(),
                                  onPressed: () {
                                    _formkey.currentState!.save();
                                    _submit();
                                  },
                                  child: Text(
                                    _registerPage ? "Kayıt ol" : "Giriş yap",
                                    style:
                                        const TextStyle(color: Colors.blueGrey),
                                  )),
                            ),
                            SizedBox(
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _formkey.currentState!.reset();
                                      _registerPage = !_registerPage;
                                    });
                                  },
                                  child: Text(
                                    _registerPage
                                        ? "Üye misiniz? Giriş Yapın"
                                        : "Hesabınız yok mu Kayıt olun",
                                    style:
                                        const TextStyle(color: Colors.blueGrey),
                                  )),
                            ),
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
