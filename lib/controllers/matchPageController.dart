// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:rimapoyraz/pages/homePage.dart';
import 'package:rimapoyraz/utilities/constants.dart';

class MatchPageController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final GetStorage _db = GetStorage();

  final RxInt _code = 0.obs;
  final RxString _name = "".obs;

  RxInt get code => _code;
  RxString get name => _name;

  void createCode() {
    _db.write("code", Random().nextInt(90000) + 10000);
    readCode();
  }

  void readCode() {
    _code.value = _db.read("code");
  }

  void setDatasToFireBaseDataBase() {
    users
        .add({'code': _code.value, 'nickName': _name.value, 'roomId': ''})
        .then((value) => print("user added"))
        .catchError((onError) => print(onError));
  }

  void createName() {
    TextEditingController textEditingController = TextEditingController();
    void onEditingComplete() {
      if (textEditingController.text.isNotEmpty) {
        Get.back();
        _db.write("nickName", textEditingController.text);
        readName();
        setDatasToFireBaseDataBase();
      } else {
        FocusScope.of(Get.context!).unfocus();
      }
    }

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      content: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.favorite,
              size: 200,
              color: clrDarkerPink,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Kullanıcı Adı:",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dancingScript(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            color: clrBlue),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 8, color: clrDarkerPink),
                      color: clrPink),
                  width: MediaQuery.of(Get.context!).size.width * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: textEditingController,
                      maxLines: 1,
                      inputFormatters: [LengthLimitingTextInputFormatter(4)],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Maksimum 4 karakter",
                          hintStyle: TextStyle(fontSize: 14, letterSpacing: 0)),
                      autocorrect: false,
                      enableSuggestions: false,
                      style: GoogleFonts.dancingScript(
                          letterSpacing: 10,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: clrBlue),
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        onEditingComplete();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );

    Get.dialog(alert, barrierDismissible: false);
  }

  void readName() {
    _name.value = _db.read("nickName");
  }

  void matchButtonPressed(String partnerCode) async {
    var roomId = "${_name.value}${_code}";

    String? docId;
    String? partnerDocId;
    String? partnerName;

    //kendi id'sini bulur
    await FirebaseFirestore.instance
        .collection("users")
        .where("code", isEqualTo: _code.value)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                print(element.data());
                element.data();
                docId = element.id;
              })
            });
    print("docid");
    print(docId);

    //partnerin id'sini bulur
    await FirebaseFirestore.instance
        .collection("users")
        .where("code", isEqualTo: int.parse(partnerCode))
        .get()
        .then((value) => {
              value.docs.forEach((element) async {
                print("aaaaa");
                print(element.data());

                partnerDocId = element.id;
              })
            });
    print(partnerDocId);
    //partnerin adını bulur
    await FirebaseFirestore.instance
        .collection("users")
        .where("code", isEqualTo: int.parse(partnerCode))
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                partnerName = element.get("nickName");
                print(partnerName);
              })
            })
        .onError((error, stackTrace) {
      throw (error!);
    });
    //kendi roomId'sini değiştirir
    await FirebaseFirestore.instance
        .collection("users")
        .doc(docId)
        .update({'roomId': roomId}).then((value) => print("success"));

    //partnerin roomId'sini değiştirir
    await FirebaseFirestore.instance
        .collection("users")
        .doc(partnerDocId)
        .update({'roomId': roomId}).then((value) => print("success"));

    //oda oluşturur
    await FirebaseFirestore.instance
        .collection(roomId)
        .doc("names")
        .set({'nameFirst': _name.value, 'nameSecond': partnerName});

    print(partnerName);
    print(roomId);
    _db.write("partnerName", partnerName);
    _db.write("roomId", roomId);
    Get.to(HomePage());
  }

  void checkHasPartner() async {
    String? docId;
    String? partnerDocId;
    String? partnerName;
    String? roomId;
    //kendi id'sini bulur
    await FirebaseFirestore.instance
        .collection("users")
        .where("code", isEqualTo: _code.value)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                print(element.data());
                element.data();
                docId = element.id;
              })
            });

    await FirebaseFirestore.instance
        .collection("users")
        .where("code", isEqualTo: _code.value)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                roomId = element.get("roomId");
                print(roomId);
              })
            })
        .onError((error, stackTrace) {
      throw (error!);
    });
    print("query");

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(roomId!).get();
    final data = querySnapshot.docs.map((doc) {
      try {
        return doc['nameFirst'];
      } catch (error) {
        return '';
      }
    });

    for (String i in data) {
      if (i.length > 1) {
        partnerName = i;
      }
    }
    print(partnerName);

    _db.write("partnerName", partnerName);
    _db.write("roomId", roomId);
    Get.to(HomePage());
  }

  @override
  void onInit() async {
    checkHasPartner();
    await _db.read("code") == null ? createCode() : readCode();
    await _db.read("nickName") == null ? createName() : readName();

    super.onInit();
  }
}



  // FirebaseFirestore.instance
    //     .collection("users")
    //     .where("code", isEqualTo: _code.value)
    //     .get()
    //     .then((value) => {
    //           value.docs.forEach((element) {
    //             print(element);
    //           })
    //         });