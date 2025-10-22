/// Modal class for service and prebooking counts
/// Used for displaying counts on the home screen
class ServiceCountsResponse {
  final bool success;
  final ServiceCounts counts;

  ServiceCountsResponse({required this.success, required this.counts});

  factory ServiceCountsResponse.fromJson(Map<String, dynamic> json) {
    return ServiceCountsResponse(
      success: json['success'] ?? false,
      counts: ServiceCounts.fromJson(json['counts'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'counts': counts.toJson()};
  }
}

class ServiceCounts {
  final int prebookingCount;
  final int openServiceCount;
  final int inprogressServiceCount;
  final int completedServiceCount;

  ServiceCounts({
    required this.prebookingCount,
    required this.openServiceCount,
    required this.inprogressServiceCount,
    required this.completedServiceCount,
  });

  factory ServiceCounts.fromJson(Map<String, dynamic> json) {
    return ServiceCounts(
      prebookingCount: json['prebooking_count'] ?? 0,
      openServiceCount: json['open_service_count'] ?? 0,
      inprogressServiceCount: json['inprogress_service_count'] ?? 0,
      completedServiceCount: json['completed_service_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prebooking_count': prebookingCount,
      'open_service_count': openServiceCount,
      'inprogress_service_count': inprogressServiceCount,
      'completed_service_count': completedServiceCount,
    };
  }

  // Helper getter for total service count
  int get totalServiceCount =>
      openServiceCount + inprogressServiceCount + completedServiceCount;
}
