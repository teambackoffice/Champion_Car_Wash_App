class ServiceItem {
  final String itemCode;
  final int price;
  final int qty;

  ServiceItem({required this.itemCode, required this.price, required this.qty});

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      itemCode: json['item_code'],
      price: json['price'],
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'item_code': itemCode, 'price': price, 'qty': qty};
  }
}

class CreateInvoiceModal {
  final String customer;
  final String serviceId;
  final List<ServiceItem> items;

  CreateInvoiceModal({
    required this.customer,
    required this.serviceId,
    required this.items,
  });

  factory CreateInvoiceModal.fromJson(Map<String, dynamic> json) {
    return CreateInvoiceModal(
      customer: json['customer'],
      serviceId: json['service_id'],
      items: (json['items'] as List)
          .map((item) => ServiceItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': customer,
      'service_id': serviceId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
