class Medicine {
  final int? id;
  final String name;
  final String dose;
  final int hour;
  final int minute;

  Medicine({
    this.id,
    required this.name,
    required this.dose,
    required this.hour,
    required this.minute,
  });

  Medicine copyWith({
    int? id,
    String? name,
    String? dose,
    int? hour,
    int? minute,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'hour': hour,
      'minute': minute,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as int?,
      name: map['name'] as String,
      dose: map['dose'] as String,
      hour: map['hour'] as int,
      minute: map['minute'] as int,
    );
  }
}
