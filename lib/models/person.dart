
import 'package:json_annotation/json_annotation.dart';
part 'person.g.dart';

@JsonSerializable()
class Person {
  String? firstName = '';
  String? lastName = '';
  String email;
  String? profileImage;
  String status;

  Person(this.firstName, this.lastName, this.email, this.profileImage, this.status);

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
