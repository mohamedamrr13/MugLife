import 'package:bloc/bloc.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';
import 'package:drinks_app/features/home/data/repos/get_categories_repo/get_categories_repo.dart';
import 'package:meta/meta.dart';

part 'get_categories_state.dart';

class GetCategoriesCubit extends Cubit<GetCategoriesState> {
  GetCategoriesCubit(this.getCategoriesRepo)
    : super(GetCategoriesInitial());
  final GetCategoriesRepo getCategoriesRepo;

  Future<void> getCategories() async {
    emit(GetCategoriesLoading());
    final result = await getCategoriesRepo.getCategories();
    result.fold(
      (left) => emit(GetCategoriesFailure(left.message)),
      (right) => emit(GetCategoriesSuccess(right)),
    );
  }
}
