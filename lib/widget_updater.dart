import 'package:home_widget/home_widget.dart';

/// Update the upcoming booking widget with booking details
Future<void> updateBookingWidget({
  required String service,
  required String date,
  required String time,
  String customer = 'Customer Name',
  String vehicle = 'Vehicle Details',
  String status = 'ACTIVE',
}) async {
  await HomeWidget.saveWidgetData<String>('booking_service', service);
  await HomeWidget.saveWidgetData<String>('booking_customer', customer);
  await HomeWidget.saveWidgetData<String>('booking_date', date);
  await HomeWidget.saveWidgetData<String>('booking_time', time);
  await HomeWidget.saveWidgetData<String>('booking_vehicle', vehicle);
  await HomeWidget.saveWidgetData<String>('booking_status', status);
  await HomeWidget.updateWidget(
    name: 'UpcomingBookingWidgetProvider',
    androidName: 'UpcomingBookingWidgetProvider',
  );
}

/// Update the service status widget with all status counts
Future<void> updateStatusWidget({
  required int openServiceCount,
  required int prebookingCount,
  required int inprogressServiceCount,
  required int completedServiceCount,
  required int totalServiceCount,
}) async {
  await HomeWidget.saveWidgetData<int>('open_service_count', openServiceCount);
  await HomeWidget.saveWidgetData<int>('prebooking_count', prebookingCount);
  await HomeWidget.saveWidgetData<int>(
    'inprogress_service_count',
    inprogressServiceCount,
  );
  await HomeWidget.saveWidgetData<int>(
    'completed_service_count',
    completedServiceCount,
  );
  await HomeWidget.saveWidgetData<int>(
    'total_service_count',
    totalServiceCount,
  );
  await HomeWidget.updateWidget(
    name: 'ServiceStatusWidgetProvider',
    androidName: 'ServiceStatusWidgetProvider',
  );
}

/// Update status widget from ServiceCountsController
Future<void> updateStatusWidgetFromCounts({
  required int openCount,
  required int prebookingCount,
  required int inprogressCount,
  required int completedCount,
  required int totalCount,
}) async {
  await updateStatusWidget(
    openServiceCount: openCount,
    prebookingCount: prebookingCount,
    inprogressServiceCount: inprogressCount,
    completedServiceCount: completedCount,
    totalServiceCount: totalCount,
  );
}
