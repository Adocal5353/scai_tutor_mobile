import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/global_widgets/primary_button.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header arrondi bleu
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: SC_ThemeColors.lightBlueBg,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Logo
                        Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                            color: SC_ThemeColors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset('assets/images/app_logo.png'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'CONNEXION',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: SC_ThemeColors.black.withOpacity(0.87),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Contenu du formulaire avec fond d'écran
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/login_background.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                          child: Column(
                children: [
                  const SizedBox(height: 30),

              // Champs de texte
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: SC_ThemeColors.lightGreyBg,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: SC_ThemeColors.lightGrey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Champ Email
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Adresse Mail",
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: SC_ThemeColors.lightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: SC_ThemeColors.darkBlue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Champ Mot de passe
                    Obx(() => TextField(
                          controller: controller.passwordController,
                          obscureText: controller.obscurePassword.value,
                          decoration: InputDecoration(
                            hintText: "Mot de passe",
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: SC_ThemeColors.lightGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: SC_ThemeColors.darkBlue,
                                width: 1.5,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: SC_ThemeColors.lightGrey,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        )),
                    const SizedBox(height: 8),
                    
                    // Mot de passe oublié
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: controller.forgotPassword,
                        child: Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                            color: SC_ThemeColors.darkBlue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Bouton Se connecter
              Obx(() => PrimaryButton(
                    text: controller.isLoading.value
                        ? "Connexion..."
                        : "Se connecter",
                    onPressed:
                        controller.isLoading.value ? () {} : controller.login,
                    backgroundColor: SC_ThemeColors.darkBlue,
                    radius: 12,
                  )),

              const SizedBox(height: 20),

              // Ligne de séparation fine
              Divider(
                color: SC_ThemeColors.lightGrey.withOpacity(0.5),
                thickness: 0.5,
                indent: 40,
                endIndent: 40,
              ),

              const SizedBox(height: 20),

              // Bouton Connexion Google
              SizedBox(
                width: 300,
                child: OutlinedButton.icon(
                  onPressed: controller.loginWithGoogle,
                  icon: Image.asset(
                    'assets/icons/google.png',
                    height: 22,
                    width: 22,
                  ),
                  label: Text(
                    "Se connecter avec Google",
                    style: TextStyle(
                      color: SC_ThemeColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: SC_ThemeColors.lightGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Lien vers inscription
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pas encore de compte ? ",
                    style: TextStyle(color: SC_ThemeColors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.SIGNUP);
                    },
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(
                        color: SC_ThemeColors.normalGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
