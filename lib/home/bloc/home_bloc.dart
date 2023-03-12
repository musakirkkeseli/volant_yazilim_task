import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:volant_yazilim_task/home/model/PersonDeleteRequestModel.dart';
import 'package:volant_yazilim_task/home/model/PersonInsertRequestModel.dart';
import 'package:volant_yazilim_task/home/model/PersonInsertResponseModel.dart';
import 'package:volant_yazilim_task/home/model/PersonModel.dart';
import 'package:volant_yazilim_task/home/model/PersonelGetAllResponseModel.dart';
import 'package:volant_yazilim_task/home/model/ProfessionGetAllResponseModel.dart';
import 'package:volant_yazilim_task/home/service/IHomeService.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  //class variable to use in service operations
  final IHomeService service;
  HomeBloc(this.service) : super(HomeState()) {
    on<PersonelPostFetched>(
      _fetchedPersonel,
    );
    on<ChangeProfession>(
      _changePageIndex,
    );

    on<DeletePerson>(
      _deletePerson,
    );

    on<AddPerson>(
      _addPerson,
    );

    on<LoadingClear>(
      _loadingClear,
    );
  }

  Future _fetchedPersonel(
    PersonelPostFetched event,
    Emitter<HomeState> emit,
  ) async {
    Map<String, List<Personel>> personByProfessionList = {};
    //all profession fetch
    final allProfession = (await service.postAllProfession());
    //all personel fetch
    final allPersonel = (await service.postAllPersonel());

    // Merging of profession list and user list
    if (allProfession is ProfessionGetAllResponseModel &&
        allPersonel is PersonelGetAllResponseModel) {
      allProfession.result!.insert(0, "all");
      personByProfessionList["all"] = allPersonel.personels!;
      for (Personel personel in allPersonel.personels ?? []) {
        for (String profession in allProfession.result ?? []) {
          if (personel.profession == profession) {
            switch (personByProfessionList[profession].runtimeType) {
              case Null:
                personByProfessionList[profession] = [personel];
                break;
              default:
                personByProfessionList[profession]!.add(personel);
            }
          }
        }
      }
      return emit(state.copyWith(
          status: PostStatus.success,
          allProfession: allProfession,
          personByProfessionList: personByProfessionList));
    } else {
      return emit(state.copyWith(
        status: PostStatus.failure,
      ));
    }
  }

  Future _changePageIndex(
    ChangeProfession event,
    Emitter<HomeState> emit,
  ) async {
    if (event.pageIndex != state.pageIndex) {
      return emit(state.copyWith(pageIndex: event.pageIndex));
    }
  }

  Future _deletePerson(
    DeletePerson event,
    Emitter<HomeState> emit,
  ) async {
    Map<String, List<Personel>>? personByProfessionList =
        state.personByProfessionList!;
    //deletion of the deleted user from all occupation lists
    personByProfessionList.forEach((key, List<Personel> value) {
      for (var i = 0; i < value.length; i++) {
        if (value[i].iD == event.personDeleteRequestModel.iD) {
          value.removeAt(i);
        }
      }
    });
    //Displays the new list from which the user has been deleted.
    emit(state.copyWith(personByProfessionList: personByProfessionList));
    //user delete request
    await service.postDeletePersonel(event.personDeleteRequestModel);
  }

  Future _addPerson(
    AddPerson event,
    Emitter<HomeState> emit,
  ) async {
    //triggers the insert screen
    emit(state.copyWith(personelAddLoading: true));
    // user creation request
    final addPersonResponse = await service.postInsertPersonel(event.person);

    if (addPersonResponse is PersonInsertResponseModel) {
      Personel personel = addPersonResponse.result!;
      Map<String, List<Personel>>? personByProfessionList =
          state.personByProfessionList!;
      //add new user to job lists
      personByProfessionList["all"]!.add(personel);
      for (String profession in state.allProfession!.result ?? []) {
        if (personel.profession == profession) {
          switch (personByProfessionList[profession].runtimeType) {
            case Null:
              personByProfessionList[profession] = [personel];
              break;
            default:
              personByProfessionList[profession]!.add(personel);
          }
        }
      }
      //triggers successful popup
      emit(state.copyWith(
          personelAddLoading: false,
          personByProfessionList: personByProfessionList));
    } else {
      //triggers unsuccessful popup
      emit(state.copyWith(personelAddLoading: false, personelAddError: true));
    }
  }

  Future _loadingClear(
    LoadingClear event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(personelAddLoading: null));
  }
}
