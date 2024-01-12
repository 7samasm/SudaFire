import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const Product._();
  const factory Product({
    @Default('') String id,
    required String title,
    required String description,
    required String category,
    required String imageUrl,
    required double price,
    required String createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  factory Product.fromDocument(DocumentSnapshot doc) {
    if (doc.data() == null) throw Exception("Document data was null");

    return Product.fromJson(doc.data() as Map<String, Object?>)
        .copyWith(id: doc.id);
  }
}
