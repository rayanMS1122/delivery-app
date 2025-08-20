void main() {
  Stream<int> number = Stream.periodic(
    Duration(seconds: 1),
    (index) {
      return index;
    },
  ).take(10);

  int num = 0;

  number.listen(
    (index) {
      num += index;
      print("num: $num index: $index");
    },
  );
}
