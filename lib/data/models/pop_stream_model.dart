class PopstreamModel {
  final String id;
  final String brandId;
  final String createdBy;
  final String createdOn;
  final String eventCover;
  final String eventType;
  final String groupId;
  final bool isDeleted;
  final bool isPublished;
  final String name;
  final String showType;
  final int videoDurationInSeconds;
  final List<String> hashtags;
  final String url;
  final String videoUrl;

  PopstreamModel({
    required this.id,
    required this.brandId,
    required this.createdBy,
    required this.createdOn,
    required this.eventCover,
    required this.eventType,
    required this.groupId,
    required this.isDeleted,
    required this.isPublished,
    required this.name,
    required this.showType,
    required this.videoDurationInSeconds,
    required this.hashtags,
    required this.url,
    required this.videoUrl,
  });

  factory PopstreamModel.fromJson(Map<String, dynamic> json) {
    return PopstreamModel(
      id: json['id'] ?? '',
      brandId: json['brand_id'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdOn: json['created_on'] ?? '',
      eventCover: json['event_cover'] ?? '',
      eventType: json['event_type'] ?? '',
      groupId: json['group_id'] ?? '',
      isDeleted: json['is_deleted'] ?? false,
      isPublished: json['is_published'] ?? false,
      name: json['name'] ?? '',
      showType: json['show_type'] ?? '',
      videoDurationInSeconds: json['video_duration_in_seconds'] ?? 0,
      hashtags: List<String>.from(json['hashtags'] ?? []),
      url: json['url'] ?? '',
      videoUrl: json['video_url'] ?? '',
    );
  }
}
