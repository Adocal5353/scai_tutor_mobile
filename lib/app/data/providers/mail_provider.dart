import 'package:dio/dio.dart';
import 'api_provider.dart';

class MailProvider {
  final ApiProvider _apiProvider;

  MailProvider(this._apiProvider);

  // POST /api/send-mail
  // Envoie un email via le service de messagerie
  Future<Response> sendMail(Map<String, dynamic> data) async {
    return await _apiProvider.post('/send-mail', data: data);
  }

  // GET /api/test-brevo-api
  // Teste la connexion a l'API Brevo
  Future<Response> testBrevoApi() async {
    return await _apiProvider.get('/test-brevo-api');
  }

  // GET /api/debug-mail-config
  // Recupere la configuration mail pour le debogage
  Future<Response> debugMailConfig() async {
    return await _apiProvider.get('/debug-mail-config');
  }
}
