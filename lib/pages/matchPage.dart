import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rimapoyraz/controllers/matchPageController.dart';
import 'package:rimapoyraz/utilities/constants.dart';

class MatchPage extends StatelessWidget {
  MatchPageController controller = Get.put(MatchPageController());
  MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: clrSofterPink,
        body: Body(
          controller: controller,
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final MatchPageController controller;
  final TextEditingController _textEditingController = TextEditingController();
  Body({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.favorite,
                      size: 300,
                      color: clrDarkerPink,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Partnerinin Kodu",
                              style: GoogleFonts.dancingScript(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 46,
                                  color: clrBlue),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 8, color: clrDarkerPink),
                            color: clrPink),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            controller: _textEditingController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6)
                            ],
                            textAlign: TextAlign.center,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            autocorrect: false,
                            enableSuggestions: false,
                            style: GoogleFonts.dancingScript(
                                letterSpacing: 10,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: clrBlue),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    color: clrBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: TextButton(
                  onPressed: () {
                    print(_textEditingController.text);
                    controller.matchButtonPressed(_textEditingController.text);
                  },
                  child: Text(
                    "EŞLEŞ",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        color: clrPink),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Kodun:",
                style: GoogleFonts.dancingScript(
                    fontWeight: FontWeight.w900, fontSize: 46, color: clrBlue),
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                height: 10,
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                    color: clrDarkerPink,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
              const SizedBox(
                height: 5,
              ),
              Obx(
                () => Text(
                  controller.code.value.toString(),
                  style: GoogleFonts.dancingScript(
                      fontWeight: FontWeight.w900,
                      fontSize: 46,
                      color: clrBlue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
