import 'package:equatable/equatable.dart';
import 'package:core/models/invoice.dart';
import 'package:core/models/coupon.dart';

abstract class FinanceState extends Equatable {
  const FinanceState();

  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final double totalRevenue;
  final List<Invoice> invoices;
  final List<Coupon> coupons;

  const FinanceLoaded({
    required this.totalRevenue,
    required this.invoices,
    required this.coupons,
  });

  @override
  List<Object?> get props => [totalRevenue, invoices, coupons];
}

class FinanceFailure extends FinanceState {
  final String message;
  const FinanceFailure(this.message);

  @override
  List<Object?> get props => [message];
}
