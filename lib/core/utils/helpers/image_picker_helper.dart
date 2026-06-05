import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  // Pick from Gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) return File(image.path);
    } catch (e) {
      // Handle permission errors here if needed
    }
    return null;
  }

  // Pick from Camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) return File(image.path);
    } catch (e) {
      // Handle permission errors here
    }
    return null;
  }
}
