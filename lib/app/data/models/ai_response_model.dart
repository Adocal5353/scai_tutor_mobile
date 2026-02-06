class AiResponse {
  final String? response;
  final String? message;
  final dynamic data;

  AiResponse({
    this.response,
    this.message,
    this.data,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      response: json['response'] as String?,
      message: json['message'] as String?,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'message': message,
      'data': data,
    };
  }
}

class AiUsage {
  final String? id;
  final String? userId;
  final String? userName;
  final String? userType;
  final String? text;
  final String? response;
  final DateTime? createdAt;
  final double? temperature;
  final bool? hasImage;

  AiUsage({
    this.id,
    this.userId,
    this.userName,
    this.userType,
    this.text,
    this.response,
    this.createdAt,
    this.temperature,
    this.hasImage,
  });

  factory AiUsage.fromJson(Map<String, dynamic> json) {
    return AiUsage(
      id: json['_id'] as String? ?? json['id'] as String?,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
      userType: json['user_type'] as String?,
      text: json['text'] as String?,
      response: json['response'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      temperature: (json['temperature'] as num?)?.toDouble(),
      hasImage: json['has_image'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'user_name': userName,
      'user_type': userType,
      'text': text,
      'response': response,
      'created_at': createdAt?.toIso8601String(),
      'temperature': temperature,
      'has_image': hasImage,
    };
  }
}

class AiStats {
  final int? totalRequests;
  final int? totalUsers;
  final Map<String, int>? requestsByUserType;
  final Map<String, int>? requestsByDate;
  final double? averageTemperature;

  AiStats({
    this.totalRequests,
    this.totalUsers,
    this.requestsByUserType,
    this.requestsByDate,
    this.averageTemperature,
  });

  factory AiStats.fromJson(Map<String, dynamic> json) {
    return AiStats(
      totalRequests: json['total_requests'] as int?,
      totalUsers: json['total_users'] as int?,
      requestsByUserType: json['requests_by_user_type'] != null
          ? Map<String, int>.from(json['requests_by_user_type'] as Map)
          : null,
      requestsByDate: json['requests_by_date'] != null
          ? Map<String, int>.from(json['requests_by_date'] as Map)
          : null,
      averageTemperature: (json['average_temperature'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_requests': totalRequests,
      'total_users': totalUsers,
      'requests_by_user_type': requestsByUserType,
      'requests_by_date': requestsByDate,
      'average_temperature': averageTemperature,
    };
  }
}
