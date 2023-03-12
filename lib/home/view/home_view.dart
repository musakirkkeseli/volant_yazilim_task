import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:volant_yazilim_task/constants/const_border.dart';
import 'package:volant_yazilim_task/constants/const_color.dart';
import 'package:volant_yazilim_task/constants/const_padding.dart';
import 'package:volant_yazilim_task/constants/const_variables.dart';
import 'package:volant_yazilim_task/home/bloc/home_bloc.dart';
import 'package:volant_yazilim_task/home/model/PersonDeleteRequestModel.dart';
import 'package:volant_yazilim_task/home/model/PersonInsertRequestModel.dart';
import 'package:volant_yazilim_task/home/model/PersonModel.dart';
import 'package:volant_yazilim_task/home/service/home_service.dart';
import 'package:volant_yazilim_task/profil/view/profil_view.dart';

///user add content
enum AddPersonTextForm {
  name,
  age,
  project,
  experience,
  phone,
  email,
  profession
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 0);
  final ItemScrollController scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(
              HomeService(Dio(BaseOptions(baseUrl: baseUrl))),
            )..add(const PersonelPostFetched()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            // TODO: implement listener
            switch (state.personelAddLoading) {
              case true:
                //adding user triggers the waiting screen
                Navigator.pop(context);
                loadingDialog();
                break;
              case false:
                //After the user add process is completed
                switch (state.personelAddError) {
                  case true:
                    // Error adding user
                    Navigator.pop(context);
                    actionResultDialog(unsuccessfulTitle, unsuccessfulDesc);
                    break;
                  default:
                    // Add user successful
                    Navigator.pop(context);
                    actionResultDialog(successfulTitle, successfulDesc);
                }
                break;
              default:
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case PostStatus.initial:
                // Loading screen state
                return Scaffold(
                  body: SafeArea(
                      child: Column(
                    children: [
                      appBar(),
                      Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator())),
                    ],
                  )),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      addPersonDialog(
                          context, state.allProfession!.result ?? []);
                    },
                    child: const Icon(Icons.add),
                  ),
                );

              case PostStatus.success:
                // data extraction successful
                return Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        appBar(),
                        professionListWidget(
                            state.allProfession!.result, state.pageIndex),
                        personByProfessionListPageView(context, state)
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      addPersonDialog(
                          context, state.allProfession!.result ?? []);
                    },
                    child: const Icon(Icons.add),
                  ),
                );

              default:
                // data extraction is incorrect
                return Center(
                  child: Text(pageErrorText),
                );
            }
          },
        ));
  }

  appBar() {
    return Container(
      margin: const PagePadding.h20(),
      padding: const PagePadding.v20(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  homeAppbarTitle,
                  style: TextStyle(fontSize: 20, color: AppColor().dullColor),
                ),
                Text(
                  homeAppbarSubtitle,
                  style: const TextStyle(fontSize: 30),
                )
              ],
            ),
          ),
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageUrl),
                ),
              ))
        ],
      ),
    );
  }

  ///professions bar
  professionListWidget(List<String>? professionGetAll, int pageIndex) {
    return Container(
      margin: const PagePadding.l8(),
      width: MediaQuery.of(context).size.width,
      height: 70,
      //automatically places jobs in a scrolling list
      child: ScrollablePositionedList.builder(
          itemScrollController: scrollController,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: professionGetAll!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Triggers page change of PageView.builder widget
                pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease);
              },
              child: Container(
                margin: const PagePadding.h12v16(),
                padding: const PagePadding.h20(),
                alignment: Alignment.center,
                constraints: const BoxConstraints(minWidth: 70),
                decoration: BoxDecoration(
                    color: pageIndex == index
                        ? AppColor().mainColor
                        : AppColor().whiteColor,
                    borderRadius: const CustomBR.all20()),
                child: Text(
                  professionGetAll[index].toUpperCase(),
                  style: TextStyle(
                      fontSize: 16,
                      color: pageIndex == index
                          ? AppColor().whiteColor
                          : AppColor().dullColor),
                ),
              ),
            );
          }),
    );
  }

  ///widget where personnel are paginated by their occupations
  Expanded personByProfessionListPageView(
      BuildContext context, HomeState state) {
    return Expanded(
      child: Container(
        margin: const PagePadding.l16(),
        child: PageView.builder(
            controller: pageController,
            onPageChanged: (int page) {
              //Triggers the ChangeProfession state
              context.read<HomeBloc>().add(ChangeProfession(page));
              // auto-scroll in the professions bar
              SchedulerBinding.instance.addPostFrameCallback((_) {
                scrollController.scrollTo(
                    index: page, duration: const Duration(milliseconds: 500));
              });
            },
            itemCount: state.allProfession!.result?.length,
            itemBuilder: (context, pageIndex) {
              String profession = state.allProfession!.result![pageIndex];
              List<Personel>? personByProfession =
                  state.personByProfessionList![profession];

              switch (personByProfession.runtimeType) {
                case Null:
                  return Padding(
                    padding: const PagePadding.all16(),
                    child: Text(noStaff),
                  );
                default:
                  // profession specific user list
                  return ListView.builder(
                      itemCount: personByProfession!.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                // detele user
                                SlidableAction(
                                  onPressed: (BuildContext context) {
                                    context.read<HomeBloc>().add(DeletePerson(
                                        PersonDeleteRequestModel(
                                            iD: personByProfession[index].iD)));
                                  },
                                  label: deleteText,
                                  backgroundColor: AppColor().deleteColor,
                                ),
                              ]),
                          //user list element
                          child: Padding(
                            padding: const PagePadding.all10(),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilView(
                                              personel:
                                                  personByProfession[index],
                                            )));
                              },
                              title: Text(
                                  personByProfession[index].name ?? noName),
                              subtitle: Text(
                                  personByProfession[index].profession ??
                                      noProfession),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ),
                        );
                      });
              }
            }),
      ),
    );
  }

  ///add user dialog
  Future<dynamic> addPersonDialog(
      BuildContext pageContext, List<String> allProfession) {
    final ValueNotifier<String> dropdownValue =
        ValueNotifier<String>(allProfession[0]);
    final formKey = GlobalKey<FormState>();
    String? name;
    String? age;
    String? project;
    String? experience;
    String? phone;
    String? email;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Padding(
            padding: const PagePadding.all16(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: formKey,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: AddPersonTextForm.values.length,
                        itemBuilder: (context, index) {
                          String hintText = "";
                          TextInputType? _keyboardType;
                          switch (AddPersonTextForm.values[index]) {
                            case AddPersonTextForm.name:
                              hintText = nameHT;
                              break;
                            case AddPersonTextForm.age:
                              hintText = ageHT;
                              _keyboardType = TextInputType.number;
                              break;
                            case AddPersonTextForm.project:
                              hintText = projectHT;
                              _keyboardType = TextInputType.number;
                              break;
                            case AddPersonTextForm.experience:
                              hintText = experienceHT;
                              _keyboardType = TextInputType.number;
                              break;
                            case AddPersonTextForm.phone:
                              hintText = phoneHT;
                              _keyboardType = TextInputType.phone;
                              break;
                            case AddPersonTextForm.email:
                              hintText = emailHT;
                              _keyboardType = TextInputType.emailAddress;
                              break;
                            case AddPersonTextForm.profession:
                              hintText = professionHT;
                              break;
                            default:
                          }

                          switch (AddPersonTextForm.values[index]) {
                            case AddPersonTextForm.profession:
                              return Padding(
                                  padding: const PagePadding.v12(),
                                  child: Container(
                                    padding: const PagePadding.h10(),
                                    decoration: BoxDecoration(
                                      borderRadius: const CustomBR.all15(),
                                      border: Border.all(
                                          color: AppColor().dullColor,
                                          style: BorderStyle.solid,
                                          width: 0.80),
                                    ),
                                    child: ValueListenableBuilder(
                                        valueListenable: dropdownValue,
                                        builder: (BuildContext context,
                                            String value, Widget? child) {
                                          return DropdownButtonFormField<
                                              String>(
                                            value: value,
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            elevation: 16,
                                            style: TextStyle(
                                                color: AppColor().dullColor),
                                            borderRadius:
                                                const CustomBR.all20(),
                                            onChanged: (String? value) {
                                              dropdownValue.value = value!;
                                            },
                                            validator: (value) {
                                              if (value! == "all") {
                                                return professionValidator;
                                              } else {
                                                return null;
                                              }
                                            },
                                            items: allProfession
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              String valueText = value == "all"
                                                  ? "Profession"
                                                  : value;
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    valueText.toUpperCase()),
                                              );
                                            }).toList(),
                                          );
                                        }),
                                  ));
                            default:
                              return Padding(
                                padding: const PagePadding.v12(),
                                child: TextFormField(
                                  keyboardType: _keyboardType,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: hintText,
                                    hintStyle:
                                        TextStyle(color: AppColor().dullColor),
                                    filled: true,
                                    fillColor: AppColor().dullColor3,
                                  ),
                                  validator: (value) {
                                    switch (AddPersonTextForm.values[index]) {
                                      case AddPersonTextForm.name:
                                        if (value!.isEmpty) {
                                          return nameValidator;
                                        } else {
                                          return null;
                                        }
                                      case AddPersonTextForm.age:
                                        if (value!.isEmpty) {
                                          return ageValidator;
                                        } else {
                                          return null;
                                        }
                                      case AddPersonTextForm.project:
                                        if (value!.isEmpty) {
                                          return projectValidator;
                                        } else {
                                          return null;
                                        }
                                      case AddPersonTextForm.experience:
                                        if (value!.isEmpty) {
                                          return experienceValidator;
                                        } else {
                                          return null;
                                        }
                                      case AddPersonTextForm.phone:
                                        if (value!.isEmpty) {
                                          return phoneValidator;
                                        } else {
                                          return null;
                                        }
                                      case AddPersonTextForm.email:
                                        if (value!.isEmpty) {
                                          return emailValidator;
                                        } else {
                                          return null;
                                        }
                                      default:
                                        return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    switch (AddPersonTextForm.values[index]) {
                                      case AddPersonTextForm.name:
                                        name = value!;
                                        break;
                                      case AddPersonTextForm.age:
                                        age = value!;
                                        break;
                                      case AddPersonTextForm.project:
                                        project = value!;
                                        break;
                                      case AddPersonTextForm.experience:
                                        experience = value!;
                                        break;
                                      case AddPersonTextForm.phone:
                                        phone = value!;
                                        break;
                                      case AddPersonTextForm.email:
                                        email = value!;
                                        break;
                                      default:
                                    }
                                  },
                                ),
                              );
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 50)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          PersonInsertRequestModel personInsertRequestModel =
                              PersonInsertRequestModel(
                                  personel: Personel(
                                      name: name,
                                      age: int.tryParse(age!),
                                      project: int.tryParse(project!),
                                      yearsOfExperience:
                                          int.tryParse(experience!),
                                      phone: phone,
                                      email: email,
                                      profession: dropdownValue.value));
                          pageContext
                              .read<HomeBloc>()
                              .add(AddPerson(personInsertRequestModel));
                        }
                      },
                      child: Text(addButton))
                ],
              ),
            ),
          ));
        });
  }

  actionResultDialog(String title, String description) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(description),
            )).then((value) {
      context.read<HomeBloc>().add(LoadingClear());
    });
  }

  loadingDialog() {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
            backgroundColor: AppColor().transparentColor,
            insetPadding: const PagePadding.all0(),
            child: WillPopScope(
                child: Container(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                onWillPop: () async => false)));
  }
}
