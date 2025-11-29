import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RessourcesTeacherController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //TODO: Implement RessourcesTeacherController

  final count = 0.obs;
  late TabController tabController;
  
  // Durée maximale autorisée pour une vidéo (en secondes)
  static const int MAX_VIDEO_DURATION_SECONDS = 300; // 5 minutes

  // Liste des documents avec dates
  final List<Map<String, dynamic>> documents = [
    {
      'title': 'Doc_comprendre les suites arithmétiques',
      'date': DateTime(2025, 5, 11),
      'type': 'doc',
      'icon': Icons.description_outlined,
      'iconColor': const Color(0xFF2196F3), // Blue
    },
    {
      'title': 'Corrigé de l\'examen nationnal.pdf',
      'date': DateTime(2025, 5, 11),
      'type': 'pdf',
      'icon': Icons.picture_as_pdf,
      'iconColor': const Color(0xFFF44336), // Red
    },
    {
      'title': 'TD Mathématique Grand Lomé.pdf',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'pdf',
      'icon': Icons.picture_as_pdf,
      'iconColor': const Color(0xFFF44336), // Red
    },
  ];

  // Liste des vidéos avec dates
  final List<Map<String, dynamic>> videos = [
    {
      'title': 'Suites numériques en arithmétique',
      'date': DateTime(2025, 5, 11),
      'thumbnail': 'assets/images/video1.jpg',
      'duration': '2:45',
      'watched': true,
    },
    {
      'title': 'Enjeux de factorisation',
      'date': DateTime.now(),
      'thumbnail': 'assets/images/video2.jpg',
      'duration': '4:32',
      'watched': true,
    },
    {
      'title': 'Introduction aux dérivées',
      'date': DateTime.now(),
      'thumbnail': 'assets/images/video3.jpg',
      'duration': '3:20',
      'watched': false,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  // Grouper les documents par date
  Map<String, List<Map<String, dynamic>>> getGroupedDocuments() {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    
    for (var doc in documents) {
      String dateKey = _getDateLabel(doc['date']);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(doc);
    }
    
    return grouped;
  }

  // Grouper les vidéos par date
  Map<String, List<Map<String, dynamic>>> getGroupedVideos() {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    
    for (var video in videos) {
      String dateKey = _getDateLabel(video['date']);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(video);
    }
    
    return grouped;
  }

  // Obtenir le label de date (11 Mai 2025, Hier, etc.)
  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final docDate = DateTime(date.year, date.month, date.day);

    if (docDate == today) {
      return "Aujourd'hui";
    } else if (docDate == yesterday) {
      return "Hier";
    } else {
      // Format: "11 Mai 2025"
      const months = [
        'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
        'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  // Convertir la durée au format "MM:SS" en secondes
  int _durationToSeconds(String duration) {
    try {
      final parts = duration.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return (minutes * 60) + seconds;
      } else if (parts.length == 3) {
        // Format HH:MM:SS
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(parts[2]);
        return (hours * 3600) + (minutes * 60) + seconds;
      }
    } catch (e) {
      print('Erreur lors de la conversion de la durée: $e');
    }
    return 0;
  }

  // Valider la durée d'une vidéo
  bool isVideoDurationValid(String duration) {
    final durationInSeconds = _durationToSeconds(duration);
    return durationInSeconds > 0 && durationInSeconds <= MAX_VIDEO_DURATION_SECONDS;
  }

  // Obtenir un message d'erreur pour une durée invalide
  String getVideoDurationErrorMessage(String duration) {
    final durationInSeconds = _durationToSeconds(duration);
    
    if (durationInSeconds == 0) {
      return 'Durée de vidéo invalide';
    }
    
    if (durationInSeconds > MAX_VIDEO_DURATION_SECONDS) {
      final maxMinutes = MAX_VIDEO_DURATION_SECONDS ~/ 60;
      return 'La durée de la vidéo dépasse la limite autorisée de $maxMinutes minutes. Durée actuelle: $duration';
    }
    
    return '';
  }

  // Valider et ajouter une vidéo (pour l'intégration future de l'API)
  Future<bool> addVideo({
    required String title,
    required String thumbnailPath,
    required String duration,
  }) async {
    // Valider la durée
    if (!isVideoDurationValid(duration)) {
      Get.snackbar(
        'Erreur',
        getVideoDurationErrorMessage(duration),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return false;
    }

    // TODO: Implémenter l'upload vers l'API
    // Pour l'instant, on ajoute simplement à la liste locale
    videos.add({
      'title': title,
      'date': DateTime.now(),
      'thumbnail': thumbnailPath,
      'duration': duration,
      'watched': false,
    });

    Get.snackbar(
      'Succès',
      'Vidéo ajoutée avec succès',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    update(); // Rafraîchir l'UI
    return true;
  }
}
