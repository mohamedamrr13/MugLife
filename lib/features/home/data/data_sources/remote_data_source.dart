import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';

class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategoriesData() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    final snapshot =
        await db
            .collection("categories")
            .orderBy("createdAt", descending: false)
            .get();
    final categories =
        snapshot.docs.map((doc) => CategoryModel.fromJson(doc.data())).toList();
    return categories;
  }
}
