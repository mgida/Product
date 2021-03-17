import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String phone;
  @HiveField(3)
  String product;
  @HiveField(4)
  double price;
  @HiveField(5)
  double duration;
  @HiveField(6)
  double amount;


  Task(this.id, this.name, this.phone, this.product, this.price, this.duration,
      this.amount);
}
