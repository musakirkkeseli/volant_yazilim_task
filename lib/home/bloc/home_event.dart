part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// event triggered to fetch user data when the app is first opened
class PersonelPostFetched extends HomeEvent {
  const PersonelPostFetched();
}

/// event triggered on change of job custom lists
class ChangeProfession extends HomeEvent {
  final int pageIndex;
  const ChangeProfession(this.pageIndex);
}

/// event triggered on user creation
class AddPerson extends HomeEvent {
  final PersonInsertRequestModel person;
  const AddPerson(this.person);
}

/// event triggered during user deletion
class DeletePerson extends HomeEvent {
  final PersonDeleteRequestModel personDeleteRequestModel;
  const DeletePerson(this.personDeleteRequestModel);
}

/// standby screen information reset event
class LoadingClear extends HomeEvent {}
