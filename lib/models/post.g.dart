// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['body'] as String?,
      json['profileImage'] as String?,
      json['imageUrl'] as String?,
      DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'body': instance.body,
      'profileImage': instance.profileImage,
      'imageUrl': instance.imageUrl,
      'created': instance.created.toIso8601String(),
    };
