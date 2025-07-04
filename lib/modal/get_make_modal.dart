

// ==================== MODAL CLASS ====================
// File: modal/car_models_modal.dart

class CarModel {
  final String model;
  final String carType;

  CarModel({
    required this.model,
    required this.carType,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      model: json['model'] ?? '',
      carType: json['car_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'car_type': carType,
    };
  }

  @override
  String toString() => 'CarModel(model: $model, carType: $carType)';
}

class CarModelsResponse {
  final String status;
  final String make;
  final List<CarModel> models;
  final int code;

  CarModelsResponse({
    required this.status,
    required this.make,
    required this.models,
    required this.code,
  });

  factory CarModelsResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message'] ?? {};
    final modelsList = message['models'] as List<dynamic>? ?? [];
    
    return CarModelsResponse(
      status: message['status'] ?? '',
      make: message['make'] ?? '',
      code: message['code'] ?? 0,
      models: modelsList.map((model) => CarModel.fromJson(model)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': {
        'status': status,
        'make': make,
        'models': models.map((model) => model.toJson()).toList(),
        'code': code,
      },
    };
  }

  bool get isSuccess => status.toLowerCase() == 'success' && code == 200;
}
