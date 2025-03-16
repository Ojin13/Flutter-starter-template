import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_starter_template/service/image_data_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../common/enums/entity_types.dart';
import '../../common/model/database_entity.dart';
import '../../common/model/image_data_model.dart';
import '../../common/util/image_compressor.dart';
import '../../ioc/ioc_container.dart';
import '../user_service.dart';
import 'firebase_auth_service.dart';

class FirebaseStorageService {
  final _firebaseAuth = get<FirebaseAuthService>();
  final _firebaseStorage = FirebaseStorage.instanceFor(bucket: 'gs://xxxxx');
  final _imageDataModelService = get<ImageDataService>();
  final _userService = get<UserService>();

  Future<ImageDataModel?> prepareImageForUpload() async {
    final newImageId = Uuid().v4();
    final compressedImageFile = await selectAndCompressImage();
    if (compressedImageFile == null) {
      return null;
    }

    ImageDataModel newImageDataModel = _createImageDataModelFromLocalFile(compressedImageFile, newImageId);
    _imageDataModelService.cacheImageDataModel(newImageDataModel);

    return newImageDataModel;
  }

  Future<void> massUploadImages(DatabaseEntity entity, EntityTypes entityType) async {
    final images = _imageDataModelService.getCachedImageDataModelByIds(entity.imageIds);
    for (ImageDataModel image in images) {
      // Check if the image is already uploaded (in case we are editing an entity, some images might
      // be already uploaded and we want to upload only the new ones)
      if (image.imageUrl != null || image.imageLocalPath == null) {
        continue;
      }

      final filePath = '${getImagePathByEntityType(entityType)}/${entity.id}/${image.id}';
      final compressedImageFile = File(image.imageLocalPath!);

      // Upload to Firebase Storage
      uploadImage(filePath, compressedImageFile);

      // Store image metadata in Firestore
      _imageDataModelService.createImageDataModelDocument(image);
      if (kDebugMode) {
        print('${image.id} Image uploaded');
      }
    }
  }

  ImageDataModel _createImageDataModelFromLocalFile(File compressedImageFile, String imageId) {
    return ImageDataModel(
        imageLocalPath: compressedImageFile.path, id: imageId, uploadedByUser: _firebaseAuth.currentUser!.uid, uploadedDate: DateTime.now());
  }

  Future<void> updateProfileImage({bool updateBackground = false}) async {
    final ImageDataModel? newProfilePicture = await prepareImageForUpload();
    if (newProfilePicture == null) {
      return;
    }

    final corePath = '/images/users/${_firebaseAuth.currentUser!.uid}/${updateBackground ? "backgroundPicture" : "profilePicture"}/';
    final filePath = '$corePath${newProfilePicture.id}';

    // Delete old profile picture
    await deleteImagesOnPath(corePath);

    // Upload new profile picture
    await uploadImage(filePath, File(newProfilePicture.imageLocalPath!));

    // Update user profile picture in Firestore
    _userService.updateUserPicture(newProfilePicture.id, _firebaseAuth.currentUser!.uid, isBackgroundPicture: updateBackground);
  }

  Future<Set<String>> fetchEntityImages({required DatabaseEntity entity, required EntityTypes entityType}) async {
    await _imageDataModelService.fetchImageDataModelByIds(entity.imageIds);

    // Fetch the images from the storage
    final ListResult images = await _firebaseStorage.ref('${getImagePathByEntityType(entityType)}/${entity.id}/').listAll();

    // Load url of new images into the image data service
    await loadImageUrlsToImageDataModelService(images);
    return entity.imageIds;
  }

  Future<void> fetchUserImages(String userId) async {
    // Fetch profile picture
    final ListResult profilePicture = await _firebaseStorage.ref('${getImagePathByEntityType(EntityTypes.user)}/$userId/profilePicture/').listAll();
    // Fetch background picture
    final ListResult backgroundPicture =
    await _firebaseStorage.ref('${getImagePathByEntityType(EntityTypes.user)}/$userId/backgroundPicture/').listAll();

    await loadImageUrlsToImageDataModelService(profilePicture);
    await loadImageUrlsToImageDataModelService(backgroundPicture);
  }

  String getImagePathByEntityType(EntityTypes entityType) {
    switch (entityType) {
      case EntityTypes.user:
        return 'images/users';
      default:
        return '';
    }
  }

  Future<void> loadImageUrlsToImageDataModelService(ListResult imageEntities) async {
    for (var i = 0; i < imageEntities.items.length; i++) {
      final imageId = imageEntities.items[i].name;

      if (_imageDataModelService.cachedImageDataModel.containsKey(imageId)) {
        if (_imageDataModelService.cachedImageDataModel[imageId].imageUrl == null) {
          final imageUrl = await imageEntities.items[i].getDownloadURL();
          _imageDataModelService.setCachedImageUrl(imageId, imageUrl);
        }
      } else {
        // This happens if the uploaded image is not tracked in the firestore for some reason (upload issue etc)
        // This is just fallback to avoid error.
        final imageUrl = await imageEntities.items[i].getDownloadURL();
        _imageDataModelService.updateImageDataModel(
            ImageDataModel(id: imageId, uploadedByUser: _firebaseAuth.currentUser!.uid, uploadedDate: DateTime.now(), imageUrl: imageUrl));
      }
    }
  }

  Future<String?> fetchUserImage(String userId, {bool fetchBackgroundImage = false}) async {
    String imagePath = fetchBackgroundImage ? 'images/users/$userId/backgroundPicture/' : 'images/users/$userId/profilePicture/';

    final ListResult result = await _firebaseStorage.ref(imagePath).listAll();

    if (result.items.isEmpty) {
      return null;
    }

    final imageUrl = await result.items.first.getDownloadURL();
    ImageDataModel image = ImageDataModel(id: result.items.first.name, uploadedByUser: userId, uploadedDate: DateTime.now(), imageUrl: imageUrl);
    _imageDataModelService.updateImageDataModel(image);

    if (!fetchBackgroundImage) {
      _imageDataModelService.updateImageDataModel(image.copyWith(id: _firebaseAuth.currentUser!.uid));
    }

    return imageUrl;
  }

  Future<void> deleteImagesByUrl({required List<String> imageUrls}) async {
    await Future.wait(imageUrls.map((String url) => _firebaseStorage.refFromURL(url).delete()));
  }

  Future<File?> selectAndCompressImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }

    final compressedIImageBytes = await ImageCompressor.compressFile(File(image.path));
    if (compressedIImageBytes == null) {
      return null;
    }

    File compressedImageFile = File(image.path)..writeAsBytesSync(compressedIImageBytes);
    return compressedImageFile;
  }

  Future<void> uploadImage(String filePath, File image) async {
    try {
      _firebaseStorage.ref(filePath).putFile(image);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteImagesOnPath(String path) async {
    final ListResult result = await _firebaseStorage.ref(path).listAll();
    await Future.wait(result.items.map((Reference ref) => ref.delete()));
  }
}
