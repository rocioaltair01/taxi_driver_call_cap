class AnnounceList {
  final String? event;
  final bool? success;
  final String? message;
  final AnnounceListResult? result;

  AnnounceList({
    required this.event,
    required this.success,
    required this.message,
    required this.result,
  });

  factory AnnounceList.fromJson(Map<String, dynamic> json) {
    return AnnounceList(
      event: json['event'] ?? '',
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      result: AnnounceListResult.fromJson(json['result']),
    );
  }
}

class AnnounceListResult {
  final Paging paging;
  final List<Announcement> data;

  AnnounceListResult({
    required this.paging,
    required this.data,
  });

  factory AnnounceListResult.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Announcement> data = list.map((item) => Announcement.fromJson(item)).toList();

    return AnnounceListResult(
      paging: Paging.fromJson(json['paging']),
      data: data,
    );
  }
}

class Announcement {
  final String? subject;
  final String? content;
  final bool? isTop;
  final String? createdAt;
  final String? announcer;

  Announcement({
    required this.subject,
    required this.content,
    required this.isTop,
    required this.createdAt,
    required this.announcer,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      subject: json['subject'] ?? '',
      content: json['content'] ?? '',
      isTop: json['isTop'] ?? false,
      createdAt: json['createdAt'] ?? '',
      announcer: json['announcer'] ?? '',
    );
  }
}

class Paging {
  final int currentPage;
  final int nextPage;
  final int previousPage;
  final int totalPages;
  final int perPage;
  final int totalEntries;

  Paging({
    required this.currentPage,
    required this.nextPage,
    required this.previousPage,
    required this.totalPages,
    required this.perPage,
    required this.totalEntries,
  });

  factory Paging.fromJson(Map<String, dynamic> json) {
    return Paging(
      currentPage: json['currentPage'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      totalPages: json['totalPages'],
      perPage: json['perPage'],
      totalEntries: json['totalEntries'],
    );
  }
}
