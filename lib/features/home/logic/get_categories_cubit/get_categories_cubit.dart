import 'package:bloc/bloc.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo_impl.dart';
import 'package:meta/meta.dart';

part 'get_categories_state.dart';

class GetCategoriesCubit extends Cubit<GetCategoriesState> {
  GetCategoriesCubit(this.getCategoriesRepoImpl)
    : super(GetCategoriesInitial());
  final GetCategoriesRepoImpl getCategoriesRepoImpl;

  Future<void> getCategories() async {
    emit(GetCategoriesLoading());
    final result = await getCategoriesRepoImpl.getCategories();
    result.fold(
      (left) => emit(GetCategoriesFailure(left.message)),
      (right) => emit(GetCategoriesSuccess(right)),
    );
  }
}
