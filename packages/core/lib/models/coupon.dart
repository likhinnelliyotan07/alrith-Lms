import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

@freezed
class Coupon with _$Coupon {
  const factory Coupon({
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
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
}
