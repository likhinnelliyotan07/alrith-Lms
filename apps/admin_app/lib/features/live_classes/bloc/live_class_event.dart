import 'package:equatable/equatable.dart';

abstract class LiveClassEvent extends Equatable {
  const LiveClassEvent();
  @override
  List<Object?> get props => [];
}

class LoadLiveClasses extends LiveClassEvent {}
