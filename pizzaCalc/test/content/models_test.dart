import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/content/module.dart';
import 'package:test/test.dart';

import '../utils/serialization.dart';

void main() {
  group('Content', () {
    group('JSON serialization', () {
      testJsonSerialization<Content>(
        'default',
        object: Content(
          createdAt: Instant.fromEpochMilliseconds(1604487201012),
          authorId: Id<User>('myUserId'),
          media: ContentMedia(
            background: MediaBackground.image(),
          ),
        ),
        json: <String, dynamic>{
          'createdAt': Timestamp(1604487201, 012000000),
          'authorId': 'myUserId',
          'media': <String, dynamic>{
            'background': <String, dynamic>{'type': 'image'},
          },
        },
        fromJson: (json) => Content.fromJson(json),
      );
    });
  });
  group('MediaBackground', () {
    group('JSON serialization', () {
      testJsonSerialization<MediaBackground>(
        'gradient',
        object: MediaBackground.gradient([Colors.white, Colors.black]),
        json: <String, dynamic>{
          'type': 'gradient',
          'colors': ['0xffffff', '0x000000'],
        },
        fromJson: (json) => MediaBackground.fromJson(json),
      );
    });
  });
}
