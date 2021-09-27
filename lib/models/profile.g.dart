// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      json['firstName'] as String,
      json['dateOfBirth'] as String,
      json['countryCode'] as String,
      json['settings'] == null
          ? null
          : Settings.fromJson(json['settings'] as Map<String, dynamic>),
      json['chatAccountId'] as String?,
      json['about'] as String?,
      json['momentCount'] as int? ?? 0,
      json['followerCount'] as int? ?? 0,
      json['followingCount'] as int? ?? 0,
      (json['interests'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      json['gender'] as String?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'settings': instance.settings?.toJson(),
      'firstName': instance.firstName,
      'dateOfBirth': instance.dateOfBirth,
      'chatAccountId': instance.chatAccountId,
      'countryCode': instance.countryCode,
      'about': instance.about,
      'momentCount': instance.momentCount,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'interests': instance.interests,
      'gender': instance.gender,
    };
