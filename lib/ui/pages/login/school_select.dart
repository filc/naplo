import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/models/school.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/login.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/controllers/search.dart';

class SchoolSelect extends StatefulWidget {
  @override
  _SchoolSelectState createState() => _SchoolSelectState();
}

class _SchoolSelectState extends State<SchoolSelect> {
  Future getSchoolList() async {
    loginContext.schools = await app.kretaApi.client.getSchools();

    setState(() {
      loginContext.schoolState = true;
    });
  }

  List<School> schoolList = loginContext.schools;

  @override
  Widget build(BuildContext context) {
    if (!loginContext.schoolState) {
      getSchoolList();
    }

    if (schoolList == null) {
      schoolList = [];
      getSchoolList();
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 32.0),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: app.settings.appColor,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: capital(I18n.of(context).search),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: app.settings.appColor))),
                    onChanged: (pattern) {
                      List<School> results = SearchController.schoolResults(
                        loginContext.schools,
                        pattern,
                      );

                      setState(() {
                        schoolList = results;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(FeatherIcons.x, color: app.settings.appColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Schools
          loginContext.schoolState
              ? Expanded(
                  child: CupertinoScrollbar(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: schoolList.length,
                      itemBuilder: (context, int index) {
                        School school = schoolList[index];
                        return SchoolTile(
                          school.name,
                          school.instituteCode,
                          school.city,
                        );
                      },
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}

class SchoolTile extends StatelessWidget {
  final String title;
  final String schoolId;
  final String city;

  SchoolTile(this.title, this.schoolId, this.city);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        loginContext.selectedSchool = School(schoolId, title, city);
        Navigator.pop(context);
      },
      child: ListTile(
        title: Text(title),
        subtitle: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                schoolId,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                city,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
