import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return await salvarImagemLocal(image);
    } catch (e) {
      return null;
    }
  }

  Future<String> salvarImagemLocal(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(image.path);
    final imagePath = '${directory.path}/$name';
    final File localImage = await File(image.path).copy(imagePath);

    return localImage.path;
  }
}
