import 'package:equatable/equatable.dart';
import 'package:core/models/notification.dart';

abstract class CommunicationState extends Equatable {
  const CommunicationState();

  @override
  List<Object?> get props => [];
}

class CommunicationInitial extends CommunicationState {}

class CommunicationLoading extends CommunicationState {}

class CommunicationSuccess extends CommunicationState {
  final String message;
  const CommunicationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CommunicationFailure extends CommunicationState {
  final String message;
  const CommunicationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
