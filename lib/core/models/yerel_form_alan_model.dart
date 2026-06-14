// lib/core/models/yerel_form_alan_model.dart

class YerelFormAlanModel {
  final String id;
  final String label;
  final String type;
  final List<String> options;
  final String? dependsOnId;
  final List<String> dependsOnValue;
  final bool required;

  YerelFormAlanModel({
    required this.id,
    required this.label,
    required this.type,
    this.options = const [],
    this.dependsOnId,
    this.dependsOnValue = const [],
    this.required = false,
  });

  factory YerelFormAlanModel.fromMap(Map<String, dynamic> map) {
    final List<dynamic> hamOptions = map['options'] is List ? map['options'] as List : [];

    List<String> valuesList = [];
    if (map['depends_on_value'] is List) {
      valuesList = (map['depends_on_value'] as List).map((e) => e.toString()).toList();
    } else if (map['depends_on_value'] != null) {
      valuesList = [map['depends_on_value'].toString()];
    }

    return YerelFormAlanModel(
      id: map['id']?.toString() ?? '',
      label: map['label']?.toString() ?? '',
      type: map['type']?.toString() ?? 'single',
      options: hamOptions.map((e) => e.toString()).toList(),
      dependsOnId: map['depends_on_id']?.toString(),
      dependsOnValue: valuesList,
      required: map['required'] is bool ? map['required'] as bool : false,
    );
  }
}