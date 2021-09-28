import 'package:json_annotation/json_annotation.dart';
import 'package:solo_traveller/models/settings.dart';
part 'profile.g.dart';

@JsonSerializable(explicitToJson: true)
class Profile {
  Settings? settings;
  String firstName;
  String dateOfBirth;
  String? chatAccountId;
  String? countryCode;
  String? about;
  int momentCount;
  int followerCount;
  int followingCount;
  List<String?>? interests = [];
  String? gender;
  String? profileImage;

  Profile(
    this.firstName,
    this.dateOfBirth,
    [
      this.countryCode,
      this.chatAccountId,
      this.about,
      this.settings,
      this.momentCount = 0,
      this.followerCount = 0,
      this.followingCount = 0,
      this.interests,
      this.gender,
      this.profileImage,
    ]
  );

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
