// To parse this JSON data, do
//
//     final inspectionListModal = inspectionListModalFromJson(jsonString);

import 'dart:convert';

InspectionListModal inspectionListModalFromJson(String str) =>
    InspectionListModal.fromJson(json.decode(str));

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

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    success: json['success'],
    inspectionType: json['inspection_type'],
    template: json['template'],
    questions: List<Question>.from(
      json['questions'].map((x) => Question.fromJson(x)),
    ),
  );

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

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    questions: json['questions'],
    isMandatory: json['is_mandatory'],
  );

  Map<String, dynamic> toJson() => {
    'questions': questions,
    'is_mandatory': isMandatory,
  };
}
