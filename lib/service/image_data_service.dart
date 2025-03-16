import 'package:rxdart/rxdart.dart';

import '../common/model/image_data_model.dart';
import 'firebase/firebase_firestore_service.dart';

const _collectionName = 'image_data';

class ImageDataService {
  // Since we want to store extra information about the images, like the generated URL, we cant use
  // the firebase stream directly. Instead we store a local copy of the fetched image data in a map
  // which prevent duplicate fetches and allows us to store the generated URL.
  final _cachedImageDataModelSubject = BehaviorSubject<Map<String, ImageDataModel>>.seeded({});
  get cachedImageDataModel => _cachedImageDataModelSubject.value;
  Stream<Map<String, ImageDataModel>> getCachedImageDataModelStream() {
    return _cachedImageDataModelSubject.stream;
  }

  final FirestoreService<ImageDataModel> _firestoreService = FirestoreService<ImageDataModel>(
    collectionName: _collectionName,
    fromJson: (json) => ImageDataModel.fromJson(json),
    toJson: (ImageDataModel) => ImageDataModel.toJson(),
  );

  void cacheImageDataModel(ImageDataModel ImageDataModel) {
    final ImageDataModelMap = _cachedImageDataModelSubject.value;
    ImageDataModelMap[ImageDataModel.id] = ImageDataModel;
    _cachedImageDataModelSubject.add(ImageDataModelMap);
  }

  void updateImageDataModel(ImageDataModel updatedImageDataModel) {
    final ImageDataModelMap = _cachedImageDataModelSubject.value;
    ImageDataModelMap[updatedImageDataModel.id] = updatedImageDataModel;
    _cachedImageDataModelSubject.add(ImageDataModelMap);
  }

  Future<void> fetchImageDataModelByIds(Set<String> ids) async {
    if (ids.isEmpty) {
      return;
    }

    List<ImageDataModel> requestedImageDataModel = await _firestoreService.getDocumentsByIds(ids);

    for (ImageDataModel image in requestedImageDataModel) {
      if (!_cachedImageDataModelSubject.value.containsKey(image.id)) {
        cacheImageDataModel(image);
      }
    }
  }

  List<ImageDataModel> getCachedImageDataModelByIds(Set<String> ids) {
    List<ImageDataModel> images = [];
    final ImageDataModelMap = _cachedImageDataModelSubject.value;
    for (String id in ids) {
      if (ImageDataModelMap.containsKey(id)) {
        images.add(ImageDataModelMap[id]!);
      }
    }
    return images;
  }

  Future<void> createImageDataModelDocument(ImageDataModel newImage) {
    return _firestoreService.addDocument(newImage, newImage.id);
  }

  Future<void> deleteImageDataModelDocument(String id) {
    return _firestoreService.deleteDocumentById(id);
  }

  void setCachedImageUrl(String id, String imageUrl) {
    final ImageDataModelMap = _cachedImageDataModelSubject.value;
    ImageDataModelMap[id] = ImageDataModelMap[id]!.copyWith(imageUrl: imageUrl);
    _cachedImageDataModelSubject.add(ImageDataModelMap);
  }

  bool areImagesLoaded(Set<String> ids) {
    final ImageDataModelMap = _cachedImageDataModelSubject.value;
    for (String id in ids) {
      if (!ImageDataModelMap.containsKey(id)) {
        return false;
      } else {
        if (ImageDataModelMap[id]!.imageUrl == null && ImageDataModelMap[id]!.imageLocalPath == null) {
          return false;
        }
      }
    }

    return true;
  }
}
