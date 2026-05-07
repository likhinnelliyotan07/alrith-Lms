import 'package:equatable/equatable.dart';
import 'package:core/models/profile.dart';

abstract class ParentState extends Equatable {
  const ParentState();

  @override
  List<Object?> get props => [];
}

class ParentInitial extends ParentState {}

class ParentLoading extends ParentState {}

class ParentsLoaded extends ParentState {
  final List<Profile> parents;
  final String? query;
  const ParentsLoaded(this.parents, {this.query});

  @override
  List<Object?> get props => [parents, query];
}

class ParentChildrenLoaded extends ParentState {
  final List<Profile> children;
  const ParentChildrenLoaded(this.children);

  @override
  List<Object?> get props => [children];
}

class ParentFailure extends ParentState {
  final String message;
  const ParentFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ParentSuccess extends ParentState {
  final String message;
  const ParentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
