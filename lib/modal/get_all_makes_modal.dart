class CarMake {
  final String name;

  CarMake({required this.name});

  factory CarMake.fromJson(Map<String, dynamic> json) {
    return CarMake(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  @override
  String toString() => 'CarMake(name: $name)';
}

class CarMakesResponse {
  final List<CarMake> makes;

  CarMakesResponse({required this.makes});

  factory CarMakesResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message'] ?? {};
    final makesList = message['makes'] as List<dynamic>? ?? [];
    
    return CarMakesResponse(
      makes: makesList.map((make) => CarMake.fromJson(make)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': {
        'makes': makes.map((make) => make.toJson()).toList(),
      },
    };
  }
}