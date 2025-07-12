class Product {
  String? id;
  String? name;
  String? price;
  String? des;
  String? image;
  Product({this.id, this.name, this.price, this.des, this.image});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
        price: parsedJson['pprice'].toString(),
        name: parsedJson['pname'].toString(),
        des: parsedJson['pdes'].toString(),
        image: parsedJson['pimage'].toString());
  }
}
