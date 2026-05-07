import 'package:equatable/equatable.dart';
import 'package:core/models/profile.dart';

abstract class ParentEvent extends Equatable {
  const ParentEvent();

  @override
  List<Object?> get props => [];
}

class LoadParents extends ParentEvent {
  final String? query;
  const LoadParents({this.query});

  @override
  List<Object?> get props => [query];
}

class LoadParentChildren extends ParentEvent {
  final String parentId;
  const LoadParentChildren(this.parentId);

  @override
  List<Object?> get props => [parentId];
}

class AddParent extends ParentEvent {
  final Profile parent;
  const AddParent(this.parent);

  @override
  List<Object?> get props => [parent];
}

class LinkChild extends ParentEvent {
  final String parentId;
  final String studentId;
  const LinkChild(this.parentId, this.studentId);

  @override
  List<Object?> get props => [parentId, studentId];
}

class DeleteParent extends ParentEvent {
  final String parentId;
  const DeleteParent(this.parentId);

  @override
  List<Object?> get props => [parentId];
}
