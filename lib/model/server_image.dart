
import 'package:json_annotation/json_annotation.dart';

part 'server_image.g.dart'; 

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class ServerImage {
  final String url;

  ServerImage(this.url);

  @override
  bool operator ==(Object other) {
    bool th = (identical(this, other) ||
        other is ServerImage &&
            runtimeType == other.runtimeType &&
            url == other.url);
    return th;
  }

  @override
  int get hashCode => url.hashCode;

  factory ServerImage.fromJson(Map<String, dynamic> json) => _$ServerImageFromJson(json);

  Map<String, dynamic> toJson() => _$ServerImageToJson(this);
}