class AuthResponse {
  final String message;
  final dynamic user; // Peut être Apprenant, Enseignant, Parent ou Responsable
  final String userType; // 'apprenant', 'enseignant', 'parent', 'responsable'
  final String token;

  AuthResponse({
    required this.message,
    required this.user,
    required this.userType,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      user: json['user'], // On garde le JSON brut, sera parsé selon userType
      userType: json['user_type'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user,
      'user_type': userType,
      'token': token,
    };
  }
}
