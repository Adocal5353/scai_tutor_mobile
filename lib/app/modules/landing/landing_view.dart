import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/global_widgets/primary_button.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

import 'landing_controller.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing_image.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  const Color.fromRGBO(16, 75, 191, 1).withOpacity(0.6),
                  BlendMode.hardLight,
                ),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Image(
                  image: AssetImage("assets/images/app_logo.png"),
                  height: 100,
                  width: 300,
                ),

                const SizedBox(height: 5),
                const Text("Bienvenu!", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 400,
            color: Color.fromRGBO(16, 75, 191, 1),
            child: Container(
              margin: EdgeInsets.only(top: 50),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  PrimaryButton(
                    text: "Se connecter",
                    backgroundColor: Color.fromRGBO(16, 75, 191, 1),
                    onPressed: () => Get.toNamed(Routes.LOGIN),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: "S'inscrire",
                    backgroundColor: Colors.white,
                    borderColor: Color.fromRGBO(16, 75, 191, 1),
                    textColor: Color.fromRGBO(16, 75, 191, 1),
                    onPressed: () => Get.toNamed(Routes.SIGNUP),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
