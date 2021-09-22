
import 'package:json_annotation/json_annotation.dart';
part 'person.g.dart';

@JsonSerializable()
class Person {
  String? firstName = '';
  String? lastName = '';
  String email;
  String? profileImage;
  String status;
  int id;

  Person(this.firstName, this.lastName, this.email, this.profileImage, this.status, this.id);

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
