import 'package:equatable/equatable.dart';

abstract class BatchEvent extends Equatable {
  const BatchEvent();
  @override
  List<Object?> get props => [];
}

class LoadBatches extends BatchEvent {}
