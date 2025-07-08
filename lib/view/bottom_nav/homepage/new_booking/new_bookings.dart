import 'package:champion_car_wash_app/controller/get_newbooking_controller.dart';
import 'package:champion_car_wash_app/controller/service_underproccessing_controller.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/new_booking/view_More.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBookingsScreen extends StatefulWidget {
  const NewBookingsScreen({super.key});

  @override
  State<NewBookingsScreen> createState() => _NewBookingsScreenState();
}

class _NewBookingsScreenState extends State<NewBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetNewbookingController>(
        context,
        listen: false,
      ).fetchBookingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 16,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        title: const Text(
          'New Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Customer by Vehicle Number',
                hintStyle: TextStyle(color: Colors.grey[500]),
                suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<GetNewbookingController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }

                if (controller.error != null) {
                  return Center(child: Text(controller.error!));
                }

                final bookings = controller.bookingData;

                if (bookings.isEmpty) {
                  return Center(child: Text('No new bookings found.'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  booking.registrationNumber,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'New',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildInfoRow('Customer Name', booking.customerName),
                          _buildInfoRow('Mobile No', booking.phone),
                          _buildInfoRow('Email ID', booking.email),
                          _buildInfoRow('Make', booking.make),
                          _buildInfoRow('Vehicle Type', booking.carType),
                          _buildInfoRow('Vehicle Model', booking.model),
                          _buildInfoRow('Engine No', booking.engineNumber),
                          _buildInfoRow('Chasis No', booking.chasisNumber),
                          _buildInfoRow('Fuel Level', '${booking.fuelLevel}%'),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewMorePage(booking: booking),
                                ),
                              );
                            },
                            child: Text(
                              'View More',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Selected Services',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...booking.services.map(
                            (service) => Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(
                                service.serviceType +
                                    (service.washType != null
                                        ? ' - ${service.washType}'
                                        : '') +
                                    (service.oilBrand != null
                                        ? ' - ${service.oilBrand}'
                                        : ''),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirm'),
                                    content: Text(
                                      'Are you sure you want to start the service?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text('Start'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await Provider.of<
                                        ServiceUnderproccessingController
                                      >(context, listen: false)
                                      .markServiceInProgress(booking.serviceId);
                                  await Provider.of<GetNewbookingController>(
                                    context,
                                    listen: false,
                                  ).fetchBookingList();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Start Service',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
