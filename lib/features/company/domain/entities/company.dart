import 'package:equatable/equatable.dart';

/// Entity representing a company
class Company extends Equatable {
  final String id;
  final String name;
  final String inviteCode;
  final String ownerId;
  final DateTime createdAt;

  const Company({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.ownerId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, inviteCode, ownerId, createdAt];
}
