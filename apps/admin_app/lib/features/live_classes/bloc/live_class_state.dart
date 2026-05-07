import 'package:equatable/equatable.dart';

abstract class LiveClassState extends Equatable {
  const LiveClassState();
  @override
  List<Object?> get props => [];
}

class LiveClassInitial extends LiveClassState {}

class LiveClassLoading extends LiveClassState {}

class LiveClassesLoaded extends LiveClassState {
  final List<dynamic> liveClasses;
  const LiveClassesLoaded(this.liveClasses);
  @override
  List<Object?> get props => [liveClasses];
}

class LiveClassFailure extends LiveClassState {
  final String message;
  const LiveClassFailure(this.message);
  @override
  List<Object?> get props => [message];
}
