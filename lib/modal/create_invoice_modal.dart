class CreateInvoiceModal {
  final String customer;
  final String serviceId;
  final List<Item> items;

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
          .map((item) => Item.fromJson(item))
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

class Item {
  final String itemCode;
  final double price;
  final int qty;

  Item({required this.itemCode, required this.price, required this.qty});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemCode: json['item_code'],
      price: (json['price'] as num).toDouble(),
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'item_code': itemCode, 'price': price, 'qty': qty};
  }
}
