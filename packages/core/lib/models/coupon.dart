import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

@freezed
abstract class Coupon with _$Coupon {
  factory Coupon({
    required String id,
    required String organizationId,
    required String code,
    double? discountPercentage,
    double? discountAmount,
    DateTime? validFrom,
    DateTime? validUntil,
    int? usageLimit,
    @Default(0) int usedCount,
    DateTime? createdAt,
  }) = _$CouponImpl;

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
}
