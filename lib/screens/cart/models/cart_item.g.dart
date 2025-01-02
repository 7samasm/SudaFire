// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      quantity: json['quantity'] as int? ?? 1,
      listKeyIndex: json['listKeyIndex'] as int?,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'listKeyIndex': instance.listKeyIndex,
      'product': instance.product,
    };
