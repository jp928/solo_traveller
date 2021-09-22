import 'package:json_annotation/json_annotation.dart';
import 'package:solo_traveller/models/settings.dart';
part 'profile.g.dart';

@JsonSerializable(explicitToJson: true)
class Profile {
  Settings? settings;
  String firstName;
  String dateOfBirth;
  int? chatAccountId;
  String countryCode;
  String? about;
  int momentCount;
  int followerCount;
  int followingCount;
  List<String?>? interests = [];
  String? gender;

  Profile(
    this.firstName,
    this.dateOfBirth,
    this.countryCode,
    [
      this.settings,
      this.chatAccountId,
      this.about,
      this.momentCount = 0,
      this.followerCount = 0,
      this.followingCount = 0,
      this.interests,
      this.gender,
    ]
  );

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
