import 'package:flutter/material.dart';
import 'package:volant_yazilim_task/constants/const_padding.dart';
import 'package:volant_yazilim_task/constants/const_variables.dart';
import 'package:volant_yazilim_task/home/model/PersonModel.dart';

class ProfilView extends StatelessWidget {
  final Personel personel;
  const ProfilView({Key? key, required this.personel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profileAppbarTitle),
        elevation: 0,
      ),
      body: Padding(
        padding: const PagePadding.all10(),
        child: Column(
          children: [
            ListTile(
              title: Text(personel.name ?? noName),
              subtitle: Text(personel.profession ?? noProfession),
            ),
            SizedBox(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  personInfoWidget(
                      context, personel.yearsOfExperience, experienceHT2),
                  personInfoWidget(context, personel.age, ageHT),
                  personInfoWidget(context, personel.project, projectHT),
                ],
              ),
            ),
            Padding(
              padding: const PagePadding.v40(),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.mail),
                    title: Text(personel.email ?? noEmail),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(personel.phone ?? noPhone),
                  )
                ],
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  SizedBox personInfoWidget(context, int? title, String subtitle) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .3,
      height: 50,
      child: ListTile(
        title: Text((title ?? 0).toString()),
        subtitle: Text(subtitle),
      ),
    );
  }
}
