import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'household_controller.dart';

class HouseholdView extends GetView<HouseholdController> {
  const HouseholdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// --- BACKGROUND IMAGE ---
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Ellipse_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// --- CONTENT ---
          Column(
            children: [
              /// --- APP BAR ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: SC_ThemeColors.darkBlue,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: controller.goBack,
                    ),
                    const Expanded(
                      child: Text(
                        'Foyer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              /// --- SCROLLABLE CONTENT ---
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// --- LIST OF APPRENANTS ---
                        if (controller.apprenants.isNotEmpty)
                          ...List.generate(
                            controller.apprenants.length,
                            (index) {
                              final apprenant = controller.apprenants[index];
                              final isExpanded = controller.selectedChildIndex.value == index;
                              final isRegistered = controller.isChildRegistered(apprenant);
                              
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index < controller.apprenants.length - 1 ? 20 : 0,
                                ),
                                child: GestureDetector(
                                    onTap: () => controller.toggleChild(index),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey.shade300),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  controller.getChildAvatar(index),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      apprenant.fullName,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        if (isRegistered) ...[
                                                          Icon(
                                                            Icons.check_circle,
                                                            color: SC_ThemeColors.normalGreen,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(width: 4),
                                                        ],
                                                        Flexible(
                                                          child: Text(
                                                            controller.getChildStatus(apprenant),
                                                            style: const TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (apprenant.niveauScolaire != null)
                                                      Text(
                                                        'Niveau: ${apprenant.niveauScolaire}',
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Informations détaillées quand développé
                                          if (isExpanded && isRegistered) ...[
                                            const SizedBox(height: 15),
                                            const Divider(),
                                            const SizedBox(height: 10),

                                            // TODO: Récupérer les vraies données depuis l'API
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Résultat récent :',
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  '13/20',  // Placeholder
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 10),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(
                                                  'Devoir à rendre',
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  'Oui',  // Placeholder
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                              );
                            },
                          )
                        else
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Text(
                                'Aucun apprenant',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 250),

                        /// --- ADD CHILD BUTTON ---
                        GestureDetector(
                          onTap: controller.addChild,
                          child: Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              color: SC_ThemeColors.darkBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'Ajouter un enfant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
