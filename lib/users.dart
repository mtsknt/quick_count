import 'dart:convert';

class User {
  final String name;
  double time_num;
  double time_az;
  double time_AZ;

  User({
    this.name,
    this.time_num,
    this.time_az,
    this.time_AZ,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        name: json['name'],
        time_num: json['time_num'],
        time_az: json['time_az'],
        time_AZ: json['time_AZ'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'time_num': time_num,
        'time_az': time_az,
        'time_AZ': time_AZ,
      };
}
