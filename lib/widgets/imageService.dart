import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static Future<XFile?> compressImage(XFile imageFile) async {
    try {
      final filePath = imageFile.path;
      final extension = path.extension(filePath).toLowerCase();

      // Create a valid extension for compression
      final validExtension = (extension == '.jpg' || extension == '.jpeg')
          ? extension
          : '.jpg'; // Default to jpg for other formats

      // Create a unique target path in temp directory
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(tempDir.path, 'compressed_${DateTime.now().millisecondsSinceEpoch}$validExtension');

      // Ensure the target directory exists
      final targetDir = Directory(path.dirname(targetPath));
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      // First compression attempt
      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: 85,
        minWidth: 1024,
        minHeight: 1024,
        format: validExtension == '.png' ? CompressFormat.png : CompressFormat.jpeg,
      );

      if (result != null) {
        final compressedSize = await result.length();
        if (compressedSize > 2048 * 1024) {
          // If still too large, compress more aggressively
          final secondTargetPath = path.join(tempDir.path, 'small_${DateTime.now().millisecondsSinceEpoch}$validExtension');
          return await FlutterImageCompress.compressAndGetFile(
            result.path, // Use the result of the first compression
            secondTargetPath,
            quality: 70,
            minWidth: 800,
            minHeight: 800,
            format: validExtension == '.png' ? CompressFormat.png : CompressFormat.jpeg,
          );
        }
        return result;
      }
      return null;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  static Future<XFile?> pickAndCompressImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: source);

      if (pickedImage != null) {
        final originalFile = File(pickedImage.path);
        final originalSize = await originalFile.length();

        if (originalSize > 2048 * 1024) {
          // Show loading indicator
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: CircularProgressIndicator()),
            );
          }

          // Compress image
          final compressedFile = await compressImage(pickedImage);

          // Make sure we close the loading dialog
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          return compressedFile;
        }
        return pickedImage;
      }
      return null;
    } catch (e) {
      print('Error picking/compressing image: $e');
      // Make sure dialog is closed in case of error
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      return null;
    }
  }
}