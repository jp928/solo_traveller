import 'package:json_annotation/json_annotation.dart';
part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  String? firstName;
  String? lastName;
  String? body;
  String? profileImage;
  String? imageUrl;
  DateTime created;

  String get fullName {
    return this.firstName == null && this.lastName == null ? 'unknown' : "${this.firstName ?? ''} ${this.lastName ?? ''}";
  }


  Post(this.firstName, this.lastName, this.body, this.profileImage, this.imageUrl, this.created);

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}