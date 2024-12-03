import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final storage = Supabase.instance.client.storage;

  Future<String> uploadFile(File file, String bucketName) async {
    try {
      final path = 'uploads/${file.path.split('/').last}';
      final response = await storage.from(bucketName).upload(path, file);

      if (response.error != null) {
        throw Exception('Failed to upload: ${response.error?.message}');
      }

      // Retourner l'URL publique
      return storage.from(bucketName).getPublicUrl(path);
    } catch (e) {
      rethrow;
    }
  }
}

extension on String {
  get error => null;
}
