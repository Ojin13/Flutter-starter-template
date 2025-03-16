import 'package:cloud_firestore/cloud_firestore.dart';


typedef DocumentDeserializer<T> = T Function(Map<String, dynamic> json);
typedef DocumentSerializer<T> = Map<String, dynamic> Function(T data);

class FirestoreService<T> {
  late final CollectionReference<T> _reference;
  late final DocumentDeserializer<T> fromJson;
  late final DocumentSerializer<T> toJson;

  FirestoreService({
    required String collectionName,
    required DocumentDeserializer<T> fromJson,
    required DocumentSerializer<T> toJson,
  }) {
    this.fromJson = fromJson;
    this.toJson = toJson;

    _reference = FirebaseFirestore.instance.collection(collectionName).withConverter(
      fromFirestore: (snapshot, options) {
        final json = snapshot.data() ?? {};
        json['id'] = snapshot.id;
        return fromJson(json);
      },
      toFirestore: (value, options) {
        final json = toJson(value);
        return json;
      },
    );
  }

  /// Creates a new document in collection with given ID
  Future<void> addDocument(T data, String id) async {
    await _reference.doc(id).set(data);
  }

  /// Returns a stream of all documents in the collection
  Stream<List<T>> observeDocuments() {
    return _reference.snapshots().map(_mapQuerySnapshotToData);
  }

  /// Observes a single document in collection with specific ID
  Stream<T?> observeDocument(String id) {
    return _reference.doc(id).snapshots().map((documentSnapshot) => documentSnapshot.data());
  }

  /// Observes all documents, whose ID is in the set of [ids].
  Stream<List<T>> observeDocumentsByIds(Set<String> ids) {
    if (ids.isEmpty) {
      return Stream.value([]);
    }

    return _reference.where(FieldPath.documentId, whereIn: ids).snapshots().map(_mapQuerySnapshotToData);
  }

  /// Returns a list of all documents in collection
  Future<List<T>> getDocuments() async {
    final documentsSnapshot = await _reference.get();
    return _mapQuerySnapshotToData(documentsSnapshot);
  }

  /// Returns a single document in collection with specific ID
  Future<T?> getDocument(String id) async {
    final documentData = await _reference.doc(id).get();
    return documentData.data();
  }

  /// Observes all documents, whose ID is in the set of [ids].
  Future<List<T>> getDocumentsByIds(Set<String> ids) async {
    if (ids.isEmpty) {
      return [];
    }

    final documentsSnapshot = await _reference.where(FieldPath.documentId, whereIn: ids).get();
    return _mapQuerySnapshotToData(documentsSnapshot);
  }

  /// Replaces all data of a specific document.
  Future<void> updateDocumentById(T data, String id) {
    return _reference.doc(id).update(toJson(data));
  }

  /// Deletes a specific document.
  Future<void> deleteDocumentById(String id) {
    return _reference.doc(id).delete();
  }

  /// Maps QuerySnapshot to List of data of type T
  List<T> _mapQuerySnapshotToData(QuerySnapshot<T> snapshot) {
    return snapshot.docs.map((documentSnapshot) => documentSnapshot.data()).toList();
  }
}
