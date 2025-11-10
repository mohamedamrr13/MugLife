import 'package:drinks_app/core/services/firestore_service.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';

class HomeRemoteDataSource {
  final FirestoreService _firestoreService;

  HomeRemoteDataSource(this._firestoreService);

  Future<List<CategoryModel>> getCategoriesData() async {
    final snapshot = await _firestoreService.getAllDocuments(
      collectionPath: 'categories',
      orderByField: 'createdAt',
      descending: false,
    );

    final categories =
        snapshot.docs.map((doc) => CategoryModel.fromJson(doc.data())).toList();
    return categories;
  }
}
