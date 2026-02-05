import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/user_service.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/providers/api_provider.dart';

Future<void> main() async {
  // S'assurer que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser GetStorage
  await GetStorage.init();
  
  // Charger les variables d'environnement
  await dotenv.load(fileName: ".env");

  // Initialiser les services globaux
  await initServices();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ScAi Tutor",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

/// Initialiser tous les services globaux de l'application
Future<void> initServices() async {
  // Enregistrer l'ApiProvider comme singleton
  Get.put(ApiProvider(), permanent: true);
  
  // Enregistrer le UserService comme service global
  await Get.putAsync(() async => UserService());
  
  // Enregistrer l'AuthService comme service global
  await Get.putAsync(() async => AuthService());
}
