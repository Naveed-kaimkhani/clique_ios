

class PopstreamModel {
  final String id;
  final String eventCover;
  final String name;
  final String showType;
  final List<String> hashtags;
  final String partyId;
  final String partyName;
  final String videoUrl;
  final String consultantIds;

  PopstreamModel({
    required this.id,
    required this.eventCover,
    required this.name,
    required this.showType,
    // required this.videoDurationInSeconds,
    required this.hashtags,
    // required this.url,
    required this.partyId,
    required this.partyName,
    // required this.isTemplate,
    required this.videoUrl,
    // required this.storeProduct,
    // required this.playerCountdownAt,
    // required this.context,
    // required this.videofiles,
    required this.consultantIds,
  });

  factory PopstreamModel.fromJson(Map<String, dynamic> json) {
    return PopstreamModel(
      id: json['id']?.toString() ?? '',
      // brandId: json['brand_id']?.toString() ?? '',
      // createdBy: json['created_by']?.toString() ?? '',
      // createdOn: json['created_on']?.toString() ?? '',
      eventCover: json['event_cover']?.toString() ?? '',
      // eventType: json['event_type']?.toString() ?? '',
      // groupId: json['group_id']?.toString() ?? '',
      // isDeleted: json['is_deleted'] ?? false,
      // isPublished: json['is_published'] ?? false,
      name: json['name']?.toString() ?? '',
      showType: json['show_type']?.toString() ?? '',
      // videoDurationInSeconds: json['video_duration_in_seconds'] ?? 0,
      hashtags: List<String>.from(json['hashtags']?.map((x) => x.toString()) ?? []),
      // url: json['url']?.toString() ?? '',
      partyId: json['party_id']?.toString() ?? '',
      partyName: json['party_name']?.toString() ?? '',
      // isTemplate: json['is_template'] ?? false,
      videoUrl: json['video_url']?.toString() ?? '',
      // storeProduct: List<dynamic>.from(json['store_product'] ?? []),
      // playerCountdownAt: json['player_countdown_at']?.toString() ?? '',
      // context: Map<String, dynamic>.from(json['context'] ?? {}),
      // videofiles: List<VideoFile>.from(
      //     json['videofiles']?.map((x) => VideoFile.fromJson(x)) ?? []),
      consultantIds: json['consultant_ids']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        // 'brand_id': brandId,
        // 'created_by': createdBy,
        // 'created_on': createdOn,
        'event_cover': eventCover,
        // 'event_type': eventType,
        // 'group_id': groupId,
        // 'is_deleted': isDeleted,
        // 'is_published': isPublished,
        'name': name,
        'show_type': showType,
        // 'video_duration_in_seconds': videoDurationInSeconds,
        'hashtags': hashtags,
        // 'url': url,
        'party_id': partyId,
        'party_name': partyName,
        // 'is_template': isTemplate,
        'video_url': videoUrl,
        // 'store_product': storeProduct,
        // 'player_countdown_at': playerCountdownAt,
        // 'context': context,
        // 'videofiles': videofiles.map((x) => x.toJson()).toList(),
        'consultant_ids': consultantIds,
      };
}

class VideoFile {
  final String id;
  final String name;
  final String createdBy;
  final String url;

  VideoFile({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.url,
  });

  factory VideoFile.fromJson(Map<String, dynamic> json) {
    return VideoFile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'created_by': createdBy,
        'url': url,
      };
}