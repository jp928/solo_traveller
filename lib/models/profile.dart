import 'package:json_annotation/json_annotation.dart';
import 'package:solo_traveller/models/settings.dart';
part 'profile.g.dart';

@JsonSerializable(explicitToJson: true)
class Profile {
  Settings settings;
  String firstName;
  String dateOfBirth;

  Profile(this.firstName, this.dateOfBirth, this.settings);

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}