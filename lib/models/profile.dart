import 'package:json_annotation/json_annotation.dart';
import 'package:solo_traveller/models/settings.dart';
import 'package:solo_traveller/utilities/to_nul.dart';
part 'profile.g.dart';

@JsonSerializable(explicitToJson: true)
class Profile {
  @JsonKey(defaultValue: null, includeIfNull: false)
  Settings? settings;
  String firstName;
  String dateOfBirth;

  @JsonKey(defaultValue: null, includeIfNull: false)
  String? chatAccountId;

  @JsonKey(defaultValue: null, includeIfNull: false)
  String? countryCode;

  @JsonKey(defaultValue: null, includeIfNull: false)
  String? about;

  @JsonKey(defaultValue: null, includeIfNull: false)
  int momentCount;

  @JsonKey(defaultValue: null, includeIfNull: false)
  int followerCount;

  @JsonKey(defaultValue: null, includeIfNull: false)
  int followingCount;

  @JsonKey(defaultValue: null, includeIfNull: false)
  List<String?>? interests = [];

  @JsonKey(defaultValue: null, includeIfNull: false)
  String? gender;

  @JsonKey(defaultValue: null, includeIfNull: false)
  String? profileImage;

  @JsonKey(defaultValue: null, includeIfNull: false)
  int? id;

  Profile(
    this.firstName,
    this.dateOfBirth, [
    this.countryCode,
    this.chatAccountId,
    this.about,
    this.profileImage,
    this.settings,
    this.momentCount = 0,
    this.followerCount = 0,
    this.followingCount = 0,
    this.interests,
    this.gender,
    this.id,
  ]);

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
