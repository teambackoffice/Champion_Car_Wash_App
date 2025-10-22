class ServiceType {
  final String name;
  final String? description;
  final double? price;

  ServiceType({required this.name, this.description, this.price});

  // Factory constructor to create ServiceType from JSON
  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      name: json['name'] ?? '',
      description: json['description'],
      price: json['price']?.toDouble(),
    );
  }

  // Convert ServiceType to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'price': price};
  }

  @override
  String toString() {
    return 'ServiceType(name: $name, description: $description, price: $price)';
  }
}

class ServiceTypeResponse {
  final List<ServiceType> serviceTypes;
  final String? error;

  ServiceTypeResponse({required this.serviceTypes, this.error});

  factory ServiceTypeResponse.fromJson(Map<String, dynamic> json) {
    try {
      final message = json['message'] as Map<String, dynamic>;
      final serviceTypeList = message['service type'] as List<dynamic>;

      List<ServiceType> types = serviceTypeList
          .map((item) => ServiceType.fromJson(item as Map<String, dynamic>))
          .toList();

      return ServiceTypeResponse(serviceTypes: types);
    } catch (e) {
      return ServiceTypeResponse(
        serviceTypes: [],
        error: 'Failed to parse response: $e',
      );
    }
  }
}
