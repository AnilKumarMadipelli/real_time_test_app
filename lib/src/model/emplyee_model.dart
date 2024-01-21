
class Employee {
  String name;
  String role;
  String today;
  String? noDate; // Can be null
  int slno;

  Employee({
    required this.name,
    required this.role,
    required this.today,
    this.noDate,
    required this.slno,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    name: json["name"],
    role: json["role"],
    today: json["today"],
    noDate: json["noDate"] == null ? "empty" : json["noDate"],
    slno: json["slno"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "today": today,
    "noDate": noDate == null ? "empty":noDate ,
    "slno": slno,
  };
}


