
import 'package:json_annotation/json_annotation.dart';
part 'settings.g.dart';

@JsonSerializable()
class Settings {
  int minFeedAge;
  int maxFeedAge;

  Settings(this.maxFeedAge, this.minFeedAge);

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
