import 'dart:io';

abstract class StorageBase {
  Future<String> uploadPhoto(
      String userID,
      String fileType,
      File yuklenecekDosya,
      );
}