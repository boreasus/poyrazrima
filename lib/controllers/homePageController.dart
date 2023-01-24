import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rimapoyraz/models/Notification.dart';
import 'package:rimapoyraz/utilities/constants.dart';

class HomePageController extends GetxController {
  final GetStorage _db = GetStorage();

  final RxString _name = "".obs;
  final RxString _partnerName = "".obs;

  RxList<NotificationBox?> _oldNotifications = <NotificationBox>[
    NotificationBox(sendBy: "", date: "", title: "", text: "", hour: "")
  ].obs;

  Rx<NotificationBox?> _lastNotification = null.obs;

  RxInt _counter = 0.obs;

  RxInt get counter => _counter;
  RxString get name => _name;
  RxString get partnerName => _partnerName;
  RxList<NotificationBox?> get oldNotifications => _oldNotifications;
  Rx<NotificationBox?> get lastNotification => _lastNotification;

  String? roomId;

  void sendNotification() {
    TextEditingController titleTEC = TextEditingController();
    TextEditingController textTEC = TextEditingController();
    void onEditingComplete(title, text) {
      Get.back();
      DateTime now = DateTime.now();
      String date = "${now.day}.${now.month}.${now.year}";
      String hour = "${now.hour}.${now.minute}";

      AlertDialog alert = AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: Colors.transparent,
          content: Wrap(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: clrSofterPink,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        )),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.done,
                            size: 100,
                            color: clrBlue,
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
                                      "Bildirim Başarıyla Gönderildi",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.dancingScript(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 32,
                                          color: clrBlue),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(Get.context!).size.width,
                                decoration: BoxDecoration(
                                    color: clrBlue,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "Olley!",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 22,
                                        color: clrPink),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ));

      FirebaseFirestore.instance.collection(roomId!).doc().set({
        'title': title,
        'text': text,
        'sendBy': _name.value,
        'date': date,
        'hour': hour,
        'time': DateTime.now(),
      }).then((_) => {
            Get.dialog(
              alert,
              barrierDismissible: true,
            )
          });
    }

    final FocusScopeNode focus = FocusScope.of(Get.context!);

    AlertDialog alert = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: Colors.transparent,
        content: Wrap(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: clrSofterPink,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.notifications,
                          size: 100,
                          color: clrBlue,
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
                                    "Başlık:",
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      width: 8, color: clrDarkerPink),
                                  color: clrPink),
                              width:
                                  MediaQuery.of(Get.context!).size.width * 0.7,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: titleTEC,
                                  maxLines: 1,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Başlık",
                                      hintStyle: TextStyle(
                                          fontSize: 14, letterSpacing: 0)),
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  style: GoogleFonts.dancingScript(
                                      letterSpacing: 10,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      color: clrBlue),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: () {
                                    focus.unfocus();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Mesaj:",
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      width: 8, color: clrDarkerPink),
                                  color: clrPink),
                              width:
                                  MediaQuery.of(Get.context!).size.width * 0.7,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  controller: textTEC,
                                  maxLines: 1,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(40)
                                  ],
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Mesaj",
                                      hintStyle: TextStyle(
                                          fontSize: 14, letterSpacing: 0)),
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  style: GoogleFonts.dancingScript(
                                      letterSpacing: 1,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      color: clrBlue),
                                  keyboardType: TextInputType.text,
                                  onEditingComplete: () {
                                    focus.unfocus();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(Get.context!).size.width,
                              decoration: BoxDecoration(
                                  color: clrBlue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: TextButton(
                                onPressed: () {
                                  FocusScope.of(Get.context!).unfocus();
                                  onEditingComplete(
                                      titleTEC.text, textTEC.text);
                                },
                                child: Text(
                                  "Gönder",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22,
                                      color: clrPink),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));

    Get.dialog(
      alert,
      barrierDismissible: true,
    );
  }

  @override
  void onInit() async {
    _partnerName.value = _db.read("partnerName");
    _name.value = _db.read("nickName");
    roomId = _db.read("roomId");

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(roomId!)
        .orderBy("time", descending: true)
        .get();
    final List<NotificationBox?> allData = querySnapshot.docs.map((doc) {
      try {
        return NotificationBox(
            sendBy: doc["sendBy"],
            title: doc["title"],
            hour: doc["hour"],
            text: doc["text"],
            date: doc["date"]);
      } catch (e) {
        return null;
      }
    }).toList();
    _oldNotifications = allData.obs;
    _counter.value = allData.length;
    Future.delayed(Duration.zero, () {
      _lastNotification = allData[0].obs;
    });

    super.onInit();
  }
}
