// lib/app/data/models/message_model.dart

enum MessageType {
  text,
  image,
  file,
  system
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed
}

class MessageModel {
  final String id;
  final String text;
  final String senderId;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;

  // Optional fields for file messages
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? fileMimeType;

  // Optional system message data
  final String? systemMessageType;

  // Optional metadata
  final Map<String, dynamic>? metadata;

  MessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.timestamp,
    required this.type,
    this.status = MessageStatus.sent,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.fileMimeType,
    this.systemMessageType,
    this.metadata,
  });

  // Convert from JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      senderId: json['senderId'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      type: MessageType.values.firstWhere(
            (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
            (e) => e.toString() == 'MessageStatus.${json['status']}',
        orElse: () => MessageStatus.sent,
      ),
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      fileMimeType: json['fileMimeType'],
      systemMessageType: json['systemMessageType'],
      metadata: json['metadata'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      if (fileUrl != null) 'fileUrl': fileUrl,
      if (fileName != null) 'fileName': fileName,
      if (fileSize != null) 'fileSize': fileSize,
      if (fileMimeType != null) 'fileMimeType': fileMimeType,
      if (systemMessageType != null) 'systemMessageType': systemMessageType,
      if (metadata != null) 'metadata': metadata,
    };
  }

  // Helper method to create a text message
  static MessageModel createTextMessage({
    required String text,
    required String senderId,
  }) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: senderId,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
  }

  // Helper method to create a file message
  static MessageModel createFileMessage({
    required String fileName,
    required String fileUrl,
    required int fileSize,
    required String senderId,
    required String mimeType,
  }) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Sent a file: $fileName',
      senderId: senderId,
      timestamp: DateTime.now(),
      type: MessageType.file,
      fileName: fileName,
      fileUrl: fileUrl,
      fileSize: fileSize,
      fileMimeType: mimeType,
    );
  }

  // Helper method to create a system message
  static MessageModel createSystemMessage({
    required String text,
    required String systemMessageType,
  }) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: 'system',
      timestamp: DateTime.now(),
      type: MessageType.system,
      systemMessageType: systemMessageType,
    );
  }

  // Helper getters
  bool get isTextMessage => type == MessageType.text;
  bool get isFileMessage => type == MessageType.file;
  bool get isImageMessage => type == MessageType.image;
  bool get isSystemMessage => type == MessageType.system;

  // File helpers
  String get fileExtension => fileName?.split('.').last ?? '';
  bool get isImage => fileMimeType?.startsWith('image/') ?? false;
  bool get isPDF => fileMimeType == 'application/pdf';
  bool get isDocument => fileMimeType?.startsWith('application/') ?? false;

  // Format file size
  String get formattedFileSize {
    if (fileSize == null) return '';

    if (fileSize! < 1024) {
      return '$fileSize B';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  // Copy with method for updating message status
  MessageModel copyWith({
    MessageStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return MessageModel(
      id: id,
      text: text,
      senderId: senderId,
      timestamp: timestamp,
      type: type,
      status: status ?? this.status,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSize: fileSize,
      fileMimeType: fileMimeType,
      systemMessageType: systemMessageType,
      metadata: metadata ?? this.metadata,
    );
  }

  // Equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MessageModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              senderId == other.senderId &&
              timestamp == other.timestamp;

  @override
  int get hashCode => id.hashCode ^ senderId.hashCode ^ timestamp.hashCode;
}