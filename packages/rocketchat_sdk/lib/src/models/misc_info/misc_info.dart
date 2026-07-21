import 'package:freezed_annotation/freezed_annotation.dart';

part 'misc_info.freezed.dart';
part 'misc_info.g.dart';

@freezed
@immutable
abstract class MiscInfoMinimumClientVersions
    with _$MiscInfoMinimumClientVersions {
  factory MiscInfoMinimumClientVersions({
    required String desktop,
    required String mobile,
  }) = _MiscInfoMinimumClientVersions;
  factory MiscInfoMinimumClientVersions.fromJson(Map<String, dynamic> json) =>
      _$MiscInfoMinimumClientVersionsFromJson(json);
}

@freezed
@immutable
abstract class MiscInfoSupportedVersions with _$MiscInfoSupportedVersions {
  factory MiscInfoSupportedVersions({required String signed}) =
      _MiscInfoSupportedVersions;
  factory MiscInfoSupportedVersions.fromJson(Map<String, dynamic> json) =>
      _$MiscInfoSupportedVersionsFromJson(json);
}

@freezed
@immutable
abstract class MiscInfo with _$MiscInfo {
  factory MiscInfo({
    required String version,
    required MiscInfoMinimumClientVersions minimumClientVersions,
    required MiscInfoSupportedVersions supportedVersions,
    required String cloudWorkspaceId,
  }) = _MiscInfo;

  factory MiscInfo.fromJson(Map<String, dynamic> json) =>
      _$MiscInfoFromJson(json);
}
