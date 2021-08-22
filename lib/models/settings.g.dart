// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      json['maxFeedAge'] as int,
      json['minFeedAge'] as int,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'minFeedAge': instance.minFeedAge,
      'maxFeedAge': instance.maxFeedAge,
    };
