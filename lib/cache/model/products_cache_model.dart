import 'package:hive/hive.dart';

part 'products_cache_model.g.dart';

@HiveType(typeId: 1)
class ProductInServiceModel extends HiveObject {
  // String documentId;
  @HiveField(0)
  DateTime serviceStartedIn;
  @HiveField(1)
  int avgServiceTime;

  ProductInServiceModel({
    // required this.documentId,
    required this.serviceStartedIn,
    required this.avgServiceTime,
  });
}
