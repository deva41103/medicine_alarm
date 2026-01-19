class Medicine {
  final int? id;
  final String name;
  final String dose;
  final int hour;
  final int minute;
  final List<int> days; // 1=Mon ... 7=Sun

  Medicine({
    this.id,
    required this.name,
    required this.dose,
    required this.hour,
    required this.minute,
    required this.days,
  });

  Medicine copyWith({int? id}) {
    return Medicine(
      id: id ?? this.id,
      name: name,
      dose: dose,
      hour: hour,
      minute: minute,
      days: days,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'hour': hour,
      'minute': minute,
      'days': days.join(','), // store as text
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dose: map['dose'],
      hour: map['hour'],
      minute: map['minute'],
      days: (map['days'] as String)
          .split(',')
          .map(int.parse)
          .toList(),
    );
  }
}
