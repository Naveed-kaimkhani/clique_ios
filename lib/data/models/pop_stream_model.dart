

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
  final String createdBy;

  PopstreamModel({
    required this.id,
    required this.eventCover,
    required this.name,
    required this.showType,
    required this.createdBy,
    required this.hashtags,
    required this.partyId,
    required this.partyName,
    required this.videoUrl,
    required this.consultantIds,
  });

  factory PopstreamModel.fromJson(Map<String, dynamic> json) {
    return PopstreamModel(
      id: json['id']?.toString() ?? '',
      eventCover: json['event_cover']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
       createdBy: json['created_by']?.toString() ?? '',
      showType: json['show_type']?.toString() ?? '',
      hashtags: List<String>.from(json['hashtags']?.map((x) => x.toString()) ?? []),
      partyId: json['party_id']?.toString() ?? '',
      partyName: json['party_name']?.toString() ?? '',
      videoUrl: json['video_url']?.toString() ?? '',
      consultantIds: json['consultant_ids']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'event_cover': eventCover,
        'name': name,
        'show_type': showType,
        'hashtags': hashtags,
        'party_id': partyId,
        'party_name': partyName,
        'video_url': videoUrl,
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