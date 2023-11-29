import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'message_model.freezed.dart';

part 'message_model.g.dart';

@Freezed(genericArgumentFactories: true)
class MessageModel with _$MessageModel {
  const factory MessageModel({
    int? id,
    required String uid,
    required String content,
    required int state,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, Object?> json) => _$MessageModelFromJson(json);
}
