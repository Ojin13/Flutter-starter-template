import '../common/model/user_model.dart';
import 'firebase/firebase_firestore_service.dart';

const _collectionName = 'users';

class UserService {
  final Map<String, UserModel> _cachedUserModel = {};

  final FirestoreService<UserModel> _firestoreService = FirestoreService<UserModel>(
    collectionName: _collectionName,
    fromJson: (json) => UserModel.fromJson(json),
    toJson: (user) => user.toJson(),
  );

  Stream<List<UserModel>> get usersStream => _firestoreService.observeDocuments();

  UserService() {
    usersStream.listen((users) {
      for (UserModel user in users) {
        _cachedUserModel[user.id] = user;
      }
    });
  }

  Future<void> createUserDocument(UserModel user) {
    return _firestoreService.addDocument(user, user.id);
  }

  Future<void> updateUserDocument(UserModel user) {
    return _firestoreService.updateDocumentById(user, user.id);
  }

  Future<void> deleteUserDocument(String userId) {
    return _firestoreService.deleteDocumentById(userId);
  }

  Stream<UserModel?> getUserStreamById(String userId) {
    if (userId.isEmpty) {
      return Stream.value(UserModel.empty());
    }
    return _firestoreService.observeDocument(userId);
  }

  void addExperiencePoints(String userId, int experiencePoints) async {
    // Check if the user exists
    final user = await getUserStreamById(userId).first;
    int newExp = experiencePoints;

    if (user != null) {
      newExp = user.experiencePoints + experiencePoints;
      UserModel updatedUser = user.copyWith(experiencePoints: newExp);
      // Update the user document
      updateUserDocument(updatedUser);
    } else {
      UserModel newUser = UserModel.empty().copyWith(id: userId, experiencePoints: experiencePoints);
      createUserDocument(newUser);
    }
  }

  void updateUserPicture(String newPictureId, String userId, {bool isBackgroundPicture = false}) async {
    final user = await getUserStreamById(userId).first;

    if (user != null) {
      UserModel updatedUser;

      if (isBackgroundPicture) {
        updatedUser = user.copyWith(backgroundPicture: newPictureId);
        updateUserDocument(updatedUser);
      } else {
        updatedUser = user.copyWith(profilePicture: newPictureId);
      }

      updateUserDocument(updatedUser);
    }
  }


  List<UserModel> sortUsersByExperience(List<UserModel> users) {
    users.sort((a, b) => b.experiencePoints.compareTo(a.experiencePoints));
    return users;
  }

  String getUserRank(List<UserModel> users, String userId) {
    users = sortUsersByExperience(users);
    int rank = users.indexWhere((element) => element.id == userId) + 1;
    return rank.toString();
  }

  UserModel? getUserInfoById({required String uuid}) {
    return _cachedUserModel[uuid];
  }

  void updateCachedUserModel(UserModel user) {
    _cachedUserModel[user.id] = user;
  }
}
