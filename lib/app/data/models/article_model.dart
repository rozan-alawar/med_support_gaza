import 'dart:convert';

class Article {
  final int id;
  final int adminId;
  final String title;
  final String summary;
  final String content;
  final String image;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String status;

  Article({
    required this.id,
    required this.adminId,
    required this.title,
    required this.summary,
    required this.content,
    required this.image,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.status,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      adminId: json['admin_id'],
      title: json['title'],
      summary: json['summary'],
      content: json['content'],
      image: json['image'],
      publishedAt: json['published_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'title': title,
      'summary': summary,
      'content': content,
      'image': image,
      'published_at': publishedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'status': status,
    };
  }
}

class ArticleResponse {
  final String message;
  final List<Article> articles;

  ArticleResponse({
    required this.message,
    required this.articles,
  });

  factory ArticleResponse.fromJson(String jsonString) {
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    final List<Article> articles = (jsonData['articles'] as List)
        .map((articleJson) => Article.fromJson(articleJson))
        .toList();

    return ArticleResponse(
      message: jsonData['message'],
      articles: articles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'articles': articles.map((article) => article.toJson()).toList(),
    };
  }
}
