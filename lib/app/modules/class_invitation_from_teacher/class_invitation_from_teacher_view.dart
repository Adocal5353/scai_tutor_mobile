import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'class_invitation_from_teacher_controller.dart';

class ClassInvitationFromTeacherView extends GetView<ClassInvitationFromTeacherController> {
  const ClassInvitationFromTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          SafeArea(
            child: Column(
              children: [
                /// --- HEADER BLEU ARRONDI ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 25),
                  decoration: BoxDecoration(
                    color: SC_ThemeColors.darkBlue,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// --- BACK BUTTON ---
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                        onPressed: controller.goBack,
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      const SizedBox(height: 10),
                      
                      /// --- TITRE ---
                      Obx(
                        () => Text(
                          controller.className.value,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          controller.classLevel.value,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Gérer les étudiants",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                /// --- SCROLLABLE CONTENT ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ========== SECTION 1: RECHERCHER ET AJOUTER ==========
                        _buildSectionTitle("Ajouter un étudiant existant"),
                        const SizedBox(height: 12),
                        _buildSearchSection(),
                        
                        const SizedBox(height: 35),
                        const Divider(height: 1, color: Colors.black12),
                        const SizedBox(height: 35),
                        
                        /// ========== SECTION 2: INVITER PAR EMAIL ==========
                        _buildSectionTitle("Inviter un nouvel étudiant"),
                        const SizedBox(height: 12),
                        _buildInvitationSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rechercher par email",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        
        /// --- CHAMP DE RECHERCHE ---
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.searchEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "email@exemple.com",
                  prefixIcon: const Icon(Icons.search, color: Colors.black45),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: SC_ThemeColors.darkBlue),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Obx(
              () => SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SC_ThemeColors.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: controller.isSearching.value ? null : controller.searchStudent,
                  child: controller.isSearching.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 18),
        
        /// --- RÉSULTATS DE RECHERCHE ---
        Obx(() {
          if (!controller.hasSearched.value) {
            return const SizedBox.shrink();
          }
          
          if (controller.searchResults.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_search,
                        size: 48,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Aucun étudiant trouvé",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Vérifiez l'email et réessayez",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${controller.searchResults.length} résultat(s) trouvé(s)",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              ...controller.searchResults.map((student) => _buildStudentCard(student)),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildStudentCard(student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: SC_ThemeColors.darkBlue.withOpacity(0.1),
            child: Icon(Icons.person, color: SC_ThemeColors.darkBlue, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${student.nom ?? ''} ${student.prenom ?? ''}".trim(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  student.email ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SC_ThemeColors.normalGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: controller.isSearching.value 
                  ? null 
                  : () => controller.addExistingStudent(student),
              child: const Text(
                "Ajouter",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email de l'étudiant",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.inviteEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "email@exemple.com",
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: SC_ThemeColors.darkBlue),
            ),
          ),
        ),
        
        const SizedBox(height: 18),
        
        const Text(
          "Nom (optionnel)",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.inviteNomController,
          decoration: InputDecoration(
            hintText: "Nom de famille",
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: SC_ThemeColors.darkBlue),
            ),
          ),
        ),
        
        const SizedBox(height: 18),
        
        const Text(
          "Prénom (optionnel)",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.invitePrenomController,
          decoration: InputDecoration(
            hintText: "Prénom",
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: SC_ThemeColors.darkBlue),
            ),
          ),
        ),
        
        const SizedBox(height: 25),
        
        /// --- BOUTON ENVOYER INVITATION ---
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SC_ThemeColors.normalGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: controller.isInviting.value ? null : controller.sendInvitation,
              child: controller.isInviting.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Envoyer l'invitation",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
