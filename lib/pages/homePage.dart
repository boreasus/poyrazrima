import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rimapoyraz/controllers/homePageController.dart';
import 'package:rimapoyraz/models/Notification.dart';
import 'package:rimapoyraz/utilities/constants.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController controller = Get.put(HomePageController());
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        print("a");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: clrSofterPink,
        body: SafeArea(
            bottom: false,
            child: Body(
              controller: controller,
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.sendNotification();
          },
          backgroundColor: clrDarkerPink,
          child: Icon(
            Icons.notification_add,
            color: clrBlue,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  Body({super.key, required this.controller});
  final HomePageController controller;
  var rng = math.Random();
  List<Color> randColors = [clrPink, clrDarkerPink, clrBlue];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          Header(
            rng: rng,
            randColors: randColors,
            controller: controller,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Son Gelen Bildirim',
            style: GoogleFonts.dancingScript(
                fontWeight: FontWeight.w900, fontSize: 24, color: clrBlue),
          ),
          SizedBox(
            height: 5,
          ),
          ObxContainer(controller: controller),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Son Gönderdiğin Bildirim',
            style: GoogleFonts.dancingScript(
                fontWeight: FontWeight.w900, fontSize: 24, color: clrBlue),
          ),
          const SizedBox(
            height: 15,
          ),
          centerThreeDots(),
          SizedBox(
            height: 10,
          ),
          Text(
            'Önceki Bildirimlerin',
            style: GoogleFonts.dancingScript(
                fontWeight: FontWeight.w900, fontSize: 24, color: clrBlue),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                  itemCount: controller.counter.value,
                  itemBuilder: ((context, index) {
                    List<NotificationBox?> data = controller.oldNotifications;
                    if (data[index]?.sendBy == controller.partnerName.value &&
                        data[index] != null) {
                      return Column(
                        children: [
                          pinkContainer(
                            title: data[index]?.title,
                            text: data[index]?.text,
                            date: "${data[index]?.date} / ${data[index]?.hour}",
                            type: true,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  })),
            ),
          )
        ],
      ),
    );
  }
}

class centerThreeDots extends StatelessWidget {
  const centerThreeDots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Icon(
          Icons.favorite,
          color: clrDarkerPink,
          size: 20,
        ),
        Icon(
          Icons.circle,
          color: clrDarkerPink,
          size: 14,
        ),
        SizedBox(
          height: 4,
        ),
        Icon(
          Icons.circle,
          color: clrDarkerPink,
          size: 10,
        ),
      ]),
    );
  }
}

class pinkContainer extends StatelessWidget {
  final title;
  final text;
  final date;
  bool? type;
  pinkContainer({
    required this.title,
    required this.text,
    required this.date,
    this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: type != null ? clrDarkerPink : clrPink),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: type == null ? clrPink : clrSofterPink),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.aBeeZee(
                      color: clrBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  text,
                  style: GoogleFonts.aBeeZee(
                      color: clrBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.aBeeZee(
                      color: clrBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ObxContainer extends StatelessWidget {
  final HomePageController controller;
  bool? type;
  ObxContainer({
    this.type,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, color: type != null ? clrDarkerPink : clrPink),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: type == null ? clrPink : clrSofterPink),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.lastNotification.value?.title ?? "",
                    style: GoogleFonts.aBeeZee(
                        color: clrBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    controller.lastNotification.value?.text ?? "",
                    style: GoogleFonts.aBeeZee(
                        color: clrBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${controller.lastNotification.value?.date ?? ""} / ${controller.lastNotification.value?.hour ?? ""}",
                    textAlign: TextAlign.end,
                    style: GoogleFonts.aBeeZee(
                        color: clrBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header(
      {super.key,
      required this.rng,
      required this.randColors,
      required this.controller});

  final math.Random rng;
  final List<Color> randColors;
  final HomePageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 4,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.rotate(
                angle: -math.pi / 4,
                child: Obx(
                  () => Text(
                    controller.partnerName.value,
                    style: GoogleFonts.dancingScript(
                        fontWeight: FontWeight.w900,
                        fontSize: 46,
                        color: clrBlue),
                  ),
                )),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Icon(
              Icons.favorite,
              size: MediaQuery.of(context).size.width / 4,
              color: clrDarkerPink,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Transform.rotate(
                angle: -math.pi / 4,
                child: Obx(
                  () => Text(
                    controller.name.value,
                    style: GoogleFonts.dancingScript(
                        fontWeight: FontWeight.w900,
                        fontSize: 46,
                        color: clrBlue),
                  ),
                )),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
          Positioned(
            left: rng.nextDouble() * MediaQuery.of(context).size.width,
            bottom: rng.nextDouble() * MediaQuery.of(context).size.width / 5,
            child: Icon(
              Icons.favorite,
              size: 20,
              color: randColors[rng.nextInt(3)],
            ),
          ),
        ],
      ),
    );
  }
}
