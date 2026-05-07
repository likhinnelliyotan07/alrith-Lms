import 'package:equatable/equatable.dart';
import 'package:core/models/invoice.dart';
import 'package:core/models/coupon.dart';

abstract class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadFinanceStats extends FinanceEvent {}

class CreateCouponRequested extends FinanceEvent {
  final Coupon coupon;
  const CreateCouponRequested(this.coupon);

  @override
  List<Object?> get props => [coupon];
}
