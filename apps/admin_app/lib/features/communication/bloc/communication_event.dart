import 'package:equatable/equatable.dart';
import 'package:core/models/notification.dart';

abstract class CommunicationEvent extends Equatable {
  const CommunicationEvent();

  @override
  List<Object?> get props => [];
}

class SendAnnouncementRequested extends CommunicationEvent {
  final String title;
  final String message;
  final String? targetRole;

  const SendAnnouncementRequested({
    required this.title,
    required this.message,
    this.targetRole,
  });

  @override
  List<Object?> get props => [title, message, targetRole];
}

class LoadSentAnnouncements extends CommunicationEvent {}
