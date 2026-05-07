import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

abstract class BatchState extends Equatable {
  const BatchState();
  @override
  List<Object?> get props => [];
}

class BatchInitial extends BatchState {}

class BatchLoading extends BatchState {}

class BatchesLoaded extends BatchState {
  final List<Batch> batches;
  const BatchesLoaded(this.batches);
  @override
  List<Object?> get props => [batches];
}

class BatchFailure extends BatchState {
  final String message;
  const BatchFailure(this.message);
  @override
  List<Object?> get props => [message];
}
