part of 'home_bloc.dart';

enum PostStatus { initial, success, failure }

class HomeState {
  final PostStatus status;
  final ProfessionGetAllResponseModel? allProfession;
  final Map<String, List<Personel>>? personByProfessionList;
  final int pageIndex;
  final bool? personelAddLoading;
  final bool personelAddError;

  HomeState(
      {this.status = PostStatus.initial,
      this.allProfession,
      this.personByProfessionList,
      this.pageIndex = 0,
      this.personelAddLoading,
      this.personelAddError = false});

  HomeState copyWith({
    final PostStatus? status,
    final ProfessionGetAllResponseModel? allProfession,
    final Map<String, List<Personel>>? personByProfessionList,
    final int? pageIndex,
    final bool? personelAddLoading,
    final bool? personelAddError,
  }) {
    return HomeState(
        status: status ?? this.status,
        allProfession: allProfession ?? this.allProfession,
        personByProfessionList:
            personByProfessionList ?? this.personByProfessionList,
        pageIndex: pageIndex ?? this.pageIndex,
        personelAddLoading: personelAddLoading,
        personelAddError: personelAddError ?? this.personelAddError);
  }
}
