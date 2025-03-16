class Order {
  String? orderId;
  String? orderDate;
  String? status;
  String? itemsCount;
  String? total_price;
  Order(
      {this.orderId,
      this.orderDate,
      this.status,
      this.itemsCount,
      this.total_price});

  factory Order.fromJson(Map<String, dynamic> parsedJson) {
    return Order(
      orderId: parsedJson['porderId'].toString(),
      orderDate: parsedJson['porderDate'].toString(),
      itemsCount: parsedJson['pitemsCount'].toString(),
      status: parsedJson['pstatus'].toString(),
      total_price: parsedJson['ptotal_price'].toString(),
    );
  }
}
