import 'package:scai_tutor_mobile/app/data/models/Devoir.dart';
import 'package:scai_tutor_mobile/app/data/models/User.dart';

class Classe {
  final String id;
  final String subject;
  final String level;
  final User teacher;
  final List<User> students;
  final List<Devoir> assignments;
  
  Classe({
    required this.id,
    required this.subject,
    required this.level,
    required this.teacher,
    this.students = const [],
    this.assignments = const [],
  });

  // Créer Classe depuis les données API
  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(
      id: (json['id_classe']?.toString() ?? json['_id']?.toString() ?? json['id']?.toString() ?? ''),
      subject: json['nom_classe'] ?? json['subject'] ?? '',
      level: json['niveau_scolaire'] ?? json['level'] ?? '',
      teacher: json['teacher'] != null 
        ? User.fromJson(json['teacher'])
        : (json['id_enseignant'] != null
          ? User(id: json['id_enseignant'], name: 'Enseignant', role: 'enseignant')
          : User(name: 'Enseignant inconnu', role: 'enseignant')),
      students: json['students'] != null
          ? (json['students'] as List<dynamic>)
              .map((student) => User.fromJson(student))
              .toList()
          : (json['apprenants_ids'] != null
            ? (json['apprenants_ids'] as List<dynamic>)
                .map((id) => User(id: id.toString(), name: 'Élève', role: 'apprenant'))
                .toList()
            : []),
      assignments: json['assignments'] != null
          ? (json['assignments'] as List<dynamic>)
                .map((assignment) => Devoir.fromJson(assignment))
                .toList()
          : [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id_classe': id,
      'nom_classe': subject,
      'niveau_scolaire': level,
      'teacher': teacher.toJson(),
      'students': students.map((student) => student.toJson()).toList(),
      'assignments': assignments
          .map((assignment) => assignment.toJson())
          .toList(),
    };
  }
  
  // Conversion vers le format API
  Map<String, dynamic> toApiJson() {
    return {
      'id_classe': id,
      'nom_classe': subject,
      'niveau_scolaire': level,
      'id_enseignant': teacher.id,
      'apprenants_ids': students.map((s) => s.id).toList(),
    };
  }
}
