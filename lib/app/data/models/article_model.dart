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
  final int code;
  final List<Article> articles;
  final int currentPage;
  final int lastPage;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int total;

  ArticleResponse({
    required this.code,
    required this.articles,
    required this.currentPage,
    required this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
    required this.total,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) {
    return ArticleResponse(
      code: json['code'],
      articles: (json['articles']['data'] as List)
          .map((article) => Article.fromJson(article))
          .toList(),
      currentPage: json['articles']['current_page'],
      lastPage: json['articles']['last_page'],
      nextPageUrl: json['articles']['next_page_url'],
      prevPageUrl: json['articles']['prev_page_url'],
      total: json['articles']['total'],
    );
  }
}