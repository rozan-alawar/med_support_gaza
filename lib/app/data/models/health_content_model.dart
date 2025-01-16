// lib/app/data/models/health_content_model.dart

class HealthContentModel {
  final String? id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final List<String> tags;
  final bool isPublished;

  HealthContentModel({
    this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    DateTime? createdAt,
    List<String>? tags,
    this.isPublished = false,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.tags = tags ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'isPublished': isPublished,
    };
  }

  factory HealthContentModel.fromJson(Map<String, dynamic> json) {
    return HealthContentModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      tags: List<String>.from(json['tags'] ?? []),
      isPublished: json['isPublished'] ?? false,
    );
  }

  HealthContentModel copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? tags,
    bool? isPublished,
  }) {
    return HealthContentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}