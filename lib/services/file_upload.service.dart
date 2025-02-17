import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FileUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file to Firebase Storage
  Future<String> uploadFile(XFile file) async {
    String fileName = file.name;
    Reference ref = _storage.ref().child("receipts/$fileName");

    await ref.putFile(File(file.path));

    // Get file URL
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  // Pick image from gallery for upload
  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }
}
