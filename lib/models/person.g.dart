// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['email'] as String,
      json['profileImage'] as String?,
      json['status'] as String,
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'profileImage': instance.profileImage,
      'status': instance.status,
    };
