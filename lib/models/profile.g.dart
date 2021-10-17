// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      json['firstName'] as String,
      json['dateOfBirth'] as String,
      json['countryCode'] as String?,
      json['chatAccountId'] as String?,
      json['about'] as String?,
      json['profileImage'] as String?,
      json['settings'] == null
          ? null
          : Settings.fromJson(json['settings'] as Map<String, dynamic>),
      json['momentCount'] as int? ?? 0,
      json['followerCount'] as int? ?? 0,
      json['followingCount'] as int? ?? 0,
      (json['interests'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      json['gender'] as String?,
      json['id'] as int?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('settings', instance.settings?.toJson());
  val['firstName'] = instance.firstName;
  val['dateOfBirth'] = instance.dateOfBirth;
  writeNotNull('chatAccountId', instance.chatAccountId);
  writeNotNull('countryCode', instance.countryCode);
  writeNotNull('about', instance.about);
  val['momentCount'] = instance.momentCount;
  val['followerCount'] = instance.followerCount;
  val['followingCount'] = instance.followingCount;
  writeNotNull('interests', instance.interests);
  writeNotNull('gender', instance.gender);
  writeNotNull('profileImage', instance.profileImage);
  writeNotNull('id', instance.id);
  return val;
}
