import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String? pin;
  final String defaultCurrencyCode;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.name,
    this.pin,
    required this.defaultCurrencyCode,
    required this.createdAt,
  });

  bool get hasPin => pin != null && pin!.isNotEmpty;

  @override
  List<Object?> get props => [id, name, pin, defaultCurrencyCode, createdAt];
}