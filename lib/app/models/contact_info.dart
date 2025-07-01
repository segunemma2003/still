import 'package:nylo_framework/nylo_framework.dart';

// ContactInfo Model using Nylo Framework
class ContactInfo extends Model {
  static StorageKey key = "contact_info";

  String? name;
  String? imagePath;
  String? tagIndex;
  bool? isShowSuspension;

  ContactInfo(
      {required String name,
      required String imagePath,
      required String tagIndex})
      : super(key: key);

  ContactInfo.fromJson(dynamic data) : super(key: key) {
    name = data['name'];
    imagePath = data['imagePath'];
    tagIndex = data['tagIndex'];
    isShowSuspension = data['isShowSuspension'] ?? false;
  }

  ContactInfo.create({
    required this.name,
    required this.imagePath,
    required this.tagIndex,
    this.isShowSuspension = false,
  }) : super(key: key);

  @override
  toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'tagIndex': tagIndex,
      'isShowSuspension': isShowSuspension,
    };
  }
}
