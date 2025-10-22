// To parse this JSON data, do
//
//     final inspectionListModal = inspectionListModalFromJson(jsonString);

import 'dart:convert';

InspectionListModal inspectionListModalFromJson(String str) {
  print('🔍 [INSPECTION_MODAL] Parsing JSON response: $str');
  try {
    final result = InspectionListModal.fromJson(json.decode(str));
    print('🔍 [INSPECTION_MODAL] Successfully parsed inspection list modal');
    return result;
  } catch (e) {
    print('❌ [INSPECTION_MODAL] Error parsing JSON: $e');
    rethrow;
  }
}

String inspectionListModalToJson(InspectionListModal data) =>
    json.encode(data.toJson());

class InspectionListModal {
  Message message;

  InspectionListModal({required this.message});

  factory InspectionListModal.fromJson(Map<String, dynamic> json) =>
      InspectionListModal(message: Message.fromJson(json['message']));

  Map<String, dynamic> toJson() => {'message': message.toJson()};
}

class Message {
  bool success;
  String inspectionType;
  String template;
  List<Question> questions;

  Message({
    required this.success,
    required this.inspectionType,
    required this.template,
    required this.questions,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    print('🔍 [INSPECTION_MODAL] Parsing Message from JSON');
    print('🔍 [INSPECTION_MODAL] Success: ${json['success']}');
    print('🔍 [INSPECTION_MODAL] Inspection Type: ${json['inspection_type']}');
    print('🔍 [INSPECTION_MODAL] Template: ${json['template']}');
    print('🔍 [INSPECTION_MODAL] Questions count: ${(json['questions'] as List?)?.length ?? 0}');
    
    try {
      return Message(
        success: json['success'] ?? false,
        inspectionType: json['inspection_type']?.toString() ?? '',
        template: json['template']?.toString() ?? '',
        questions: List<Question>.from(
          (json['questions'] as List? ?? []).map((x) => Question.fromJson(x)),
        ),
      );
    } catch (e) {
      print('❌ [INSPECTION_MODAL] Error parsing Message: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'inspection_type': inspectionType,
    'template': template,
    'questions': List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Question {
  String questions;
  int isMandatory;
  bool isChecked; // <-- Added for UI state

  Question({
    required this.questions,
    required this.isMandatory,
    this.isChecked = false, // default unchecked
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    print('🔍 [INSPECTION_MODAL] Parsing Question: ${json['questions']}');
    print('🔍 [INSPECTION_MODAL] Is Mandatory: ${json['is_mandatory']}');
    
    try {
      return Question(
        questions: json['questions']?.toString() ?? '',
        isMandatory: (json['is_mandatory'] ?? 0).toInt(),
      );
    } catch (e) {
      print('❌ [INSPECTION_MODAL] Error parsing Question: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'questions': questions,
    'is_mandatory': isMandatory,
  };
}
