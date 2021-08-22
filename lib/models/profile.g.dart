// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      json['firstName'] as String,
      json['dateOfBirth'] as String,
      Settings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'settings': instance.settings.toJson(),
      'firstName': instance.firstName,
      'dateOfBirth': instance.dateOfBirth,
    };
