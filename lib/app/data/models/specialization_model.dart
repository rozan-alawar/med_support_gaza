
class SpecializationModel {
  final String id;
  final String name;
  final int availableDoctors;
  final String icon;
  final bool isActive;

  SpecializationModel({
    required this.id,
    required this.name,
    required this.availableDoctors,
    required this.icon,
    this.isActive = true,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      availableDoctors: json['availableDoctors'] ?? 0,
      icon: json['icon'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'availableDoctors': availableDoctors,
      'icon': icon,
      'isActive': isActive,
    };
  }
}