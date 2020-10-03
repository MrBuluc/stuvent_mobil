import 'dart:io';

abstract class StorageBase {
  Future<String> uploadFile(
      String anaKlasor, File dosya, String etkinlikAdi, String dosyaAdi);
  Future<bool> deleteFile(String anaKlasor, String etkinlikAdi, String dosyaAdi);
  Future<bool> delFiles(String anaKlasor, String etkinlikAdi, List<String> files);
}