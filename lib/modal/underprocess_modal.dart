class UnderprocessModal {
  final bool success;
  final int count;
  final List<ServiceCars> data;

  UnderprocessModal({
    required this.success,
    required this.count,
    required this.data,
  });

  factory UnderprocessModal.fromJson(Map<String, dynamic> json) {
    return UnderprocessModal(
      success: json['message']['success'] ?? false,
      count: json['message']['count'] ?? 0,
      data: (json['message']['data'] as List)
          .map((e) => ServiceCars.fromJson(e))
          .toList(),
    );
  }
}

class ServiceCars {
  final String serviceId;
  final String mainStatus;
  final String customerName;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String branch;
  final String make;
  final String model;
  final String carType;
  final String purchaseDate;
  final String engineNumber;
  final String chasisNumber;
  final String registrationNumber;
  final double fuelLevel;
  final double lastServiceOdometer;
  final double currentOdometerReading;
  final double nextServiceOdometer;
  final String? video;

  // New totals
  final double oilTotal;
  final double carwashTotal;
  final double serviceTotal;
  final double extraWorksTotal;
  final double grandTotal;

  final List<ServiceItem> services;
  final List<ExtraWorkItem> extraWorkItems;

  ServiceCars({
    required this.serviceId,
    required this.mainStatus,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.branch,
    required this.make,
    required this.model,
    required this.carType,
    required this.purchaseDate,
    required this.engineNumber,
    required this.chasisNumber,
    required this.registrationNumber,
    required this.fuelLevel,
    required this.lastServiceOdometer,
    required this.currentOdometerReading,
    required this.nextServiceOdometer,
    this.video,
    required this.oilTotal,
    required this.carwashTotal,
    required this.serviceTotal,
    required this.extraWorksTotal,
    required this.grandTotal,
    required this.services,
    required this.extraWorkItems,
  });

  factory ServiceCars.fromJson(Map<String, dynamic> json) {
    return ServiceCars(
      serviceId: json['service_id'] ?? '',
      mainStatus: json['main_status'] ?? '',
      customerName: json['customer_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      branch: json['branch'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      carType: json['car_type'] ?? '',
      purchaseDate: json['purchase_date'] ?? '',
      engineNumber: json['engine_number'] ?? '',
      chasisNumber: json['chasis_number'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      fuelLevel: (json['fuel_level'] ?? 0).toDouble(),
      lastServiceOdometer: (json['last_service_odometer'] ?? 0).toDouble(),
      currentOdometerReading: (json['current_odometer_reading'] ?? 0)
          .toDouble(),
      nextServiceOdometer: (json['next_service_odometer'] ?? 0).toDouble(),
      video: json['video'],
      oilTotal: (json['oil_total'] ?? 0).toDouble(),
      carwashTotal: (json['carwash_total'] ?? 0).toDouble(),
      serviceTotal: (json['service_total'] ?? 0).toDouble(),
      extraWorksTotal: (json['extra_works_total'] ?? 0).toDouble(),
      grandTotal: (json['grand_total'] ?? 0).toDouble(),
      services: (json['services'] as List)
          .map((e) => ServiceItem.fromJson(e))
          .toList(),
      extraWorkItems: (json['extra_work_items'] as List)
          .map((e) => ExtraWorkItem.fromJson(e))
          .toList(),
    );
  }
}

class ServiceItem {
  final String serviceType;
  final String? washType;
  final String? oilBrand;
  final String? oilSubtype;
  final int qty;
  final double price;
  final String? status;

  ServiceItem({
    required this.serviceType,
    this.washType,
    this.oilBrand,
    this.oilSubtype,
    required this.qty,
    required this.price,
    this.status,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      serviceType: json['service_type'] ?? '',
      washType: json['wash_type'],
      oilBrand: json['oil_brand'],
      oilSubtype: json['oil_subtype'],
      qty: (json['qty'] ?? 0).toInt(),
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'],
    );
  }
}

class ExtraWorkItem {
  final String workItem;
  final int qty;
  final double rate;

  ExtraWorkItem({
    required this.workItem,
    required this.qty,
    required this.rate,
  });

  factory ExtraWorkItem.fromJson(Map<String, dynamic> json) {
    return ExtraWorkItem(
      workItem: json['work_item'] ?? '',
      qty: (json['qty'] ?? 0).toInt(),
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }
}
