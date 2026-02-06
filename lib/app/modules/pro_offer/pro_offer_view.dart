import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pro_offer_controller.dart';

class ProOfferView extends GetView<ProOfferController> {
  const ProOfferView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color darkBackground = Color(0xFF051D58);
    const Color cardCyan = Color(0xFF1493A6);
    const Color cardShadow = Color(0xFF0E6A78);

    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: controller.close,
                ),
              ),
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                      "Les apprenants PRO ont 3,6\nfois plus de chances de\nterminer leurs cours",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Advantage cards
                    Obx(() => Column(
                      children: controller.advantages.map((advantage) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildAdvantageCard(
                            text: advantage['text'],
                            iconName: advantage['icon'],
                            iconColor: Color(advantage['iconColor']),
                            cardColor: cardCyan,
                            shadowColor: cardShadow,
                            isNoAdsIcon: advantage['isNoAds'] ?? false,
                          ),
                        );
                      }).toList(),
                    )),
                  ],
                ),
              ),
            ),

            // CTA button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.startFreeTrial,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "COMMENCER GRATUITEMENT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvantageCard({
    required String text,
    required String iconName,
    required Color iconColor,
    required Color cardColor,
    required Color shadowColor,
    bool isNoAdsIcon = false,
  }) {
    IconData icon = iconName == 'favorite' 
        ? Icons.favorite 
        : Icons.campaign;

    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 4),
            blurRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon management
          isNoAdsIcon
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(icon, size: 40, color: const Color(0xFF6A6A8B)),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2C3E50),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 12, color: Colors.white),
                      ),
                    )
                  ],
                )
              : Icon(icon, size: 40, color: iconColor),
          
          const SizedBox(height: 8),
          
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
