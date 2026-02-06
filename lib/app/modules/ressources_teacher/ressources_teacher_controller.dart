import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/document_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/document_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';

class RessourcesTeacherController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final DocumentProvider _documentProvider = DocumentProvider(Get.find<ApiProvider>());
  final UserService _userService = Get.find<UserService>();

  late TabController tabController;
  static const int MAX_VIDEO_DURATION_SECONDS = 300;

  final RxList<DocumentModel> allDocuments = <DocumentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  List<Map<String, dynamic>> get documents => allDocuments
    .where((doc) => doc.type != 'video')
    .map((doc) => {
      'title': doc.titre,
      'date': DateTime.now(),
      'type': doc.type,
      'icon': _getIconForType(doc.type),
      'iconColor': _getColorForType(doc.type),
      'document': doc,
    }).toList();

  List<Map<String, dynamic>> get videos => allDocuments
    .where((doc) => doc.type == 'video')
    .map((doc) => {
      'title': doc.titre,
      'date': DateTime.now(),
      'thumbnail': 'assets/images/video1.jpg',
      'duration': '0:00',
      'watched': false,
      'document': doc,
    }).toList();

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.play_circle_outline;
      default:
        return Icons.description_outlined;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return const Color(0xFFF44336);
      case 'video':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF2196F3);
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      isLoading.value = true;
      error.value = '';

      final userId = _userService.user?.id;
      if (userId == null) {
        error.value = 'Utilisateur non connecte';
        return;
      }

      final response = await _documentProvider.getAll(
        params: {'id_enseignant': userId}
      );

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        print('[RessourcesTeacher] Parsing ${data.length} documents...');
        
        allDocuments.value = data
          .map((json) {
            try {
              final doc = DocumentModel.fromJson(json as Map<String, dynamic>);
              print('[RessourcesTeacher] ✓ Parsed: ${doc.titre} (${doc.type})');
              return doc;
            } catch (e) {
              print('[RessourcesTeacher] ✗ ERROR parsing document: $e');
              print('[RessourcesTeacher] JSON was: $json');
              rethrow;
            }
          })
          .toList();
        
        print('[RessourcesTeacher] Loaded ${allDocuments.length} documents successfully');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger les documents',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

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
