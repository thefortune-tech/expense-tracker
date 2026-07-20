import 'package:hive/hive.dart';

import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    super.pin,
    required super.defaultCurrencyCode,
    required super.createdAt,
  });

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      id: profile.id,
      name: profile.name,
      pin: profile.pin,
      defaultCurrencyCode: profile.defaultCurrencyCode,
      createdAt: profile.createdAt,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      pin: pin,
      defaultCurrencyCode: defaultCurrencyCode,
      createdAt: createdAt,
    );
  }
}

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 1;

  @override
  UserProfileModel read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final hasPin = reader.readBool();
    final pin = hasPin ? reader.readString() : null;
    final defaultCurrencyCode = reader.readString();
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return UserProfileModel(
      id: id,
      name: name,
      pin: pin,
      defaultCurrencyCode: defaultCurrencyCode,
      createdAt: createdAt,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeBool(obj.hasPin);
    if (obj.hasPin) {
      writer.writeString(obj.pin!);
    }
    writer.writeString(obj.defaultCurrencyCode);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}