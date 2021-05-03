import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/builder.dart';
import 'package:filcnaplo/ui/pages/evaluations/statistics/page.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/common/account_button.dart';
import 'package:filcnaplo/ui/common/custom_snackbar.dart';
import 'package:filcnaplo/ui/common/custom_tabs.dart';
import 'package:filcnaplo/ui/common/empty.dart';
import 'package:filcnaplo/ui/pages/debug/button.dart';
import 'package:filcnaplo/ui/pages/debug/view.dart';
import 'package:filcnaplo/ui/pages/evaluations/dial.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class EvaluationsPage extends StatefulWidget {
  EvaluationsPage();

  @override
  _EvaluationsPageState createState() => _EvaluationsPageState();
}

class _EvaluationsPageState extends State<EvaluationsPage>
    with SingleTickerProviderStateMixin {
  GradeBuilder _gradeBuilder;
  SubjectBuilder _subjectBuilder;
  int evalSortBy = 0;
  List<EvaluationType> types = [];

  _EvaluationsPageState() {
    this._gradeBuilder = GradeBuilder();
    this._subjectBuilder = SubjectBuilder();
  }

  void buildPage() {
    app.user.sync.evaluation.evaluations.forEach((evaluation) {
      if (!types.contains(evaluation.type)) {
        types.add(evaluation.type);
      }
    });

    _gradeBuilder.build(sortBy: evalSortBy, type: selectedEvalType);
    _subjectBuilder.build();
  }

  EvaluationType selectedEvalType =
      app.pageContext.evaluationType ?? EvaluationType.midYear;
  TabController _tabController;
  bool didPageChange;

  final _refreshKeyGrades = GlobalKey<RefreshIndicatorState>();
  final _refreshKeySubjects = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 3,
    );

    buildPage();

    didPageChange = false;
    _tabController.addListener(() => setState(() => didPageChange = true));
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _tabController.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (app.user.sync.evaluation.uiPending) {
      app.user.sync.evaluation.uiPending = false;
      buildPage();
    }

    return Scaffold(
      floatingActionButton: _tabController.index == 0
          ? EvaluationsDial(
              (evalSortBy / 2).floor(),
              evalSortBy % 2 == 1,
              onSelect: (int selected) {
                int newVal = 4 - selected * 2;
                bool changed = newVal != evalSortBy;

                evalSortBy = newVal + (changed ? 0 : 1);
                setState(() {
                  buildPage();
                });
              },
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              floating: true,
              // BackButton appears between pages while animating
              automaticallyImplyLeading: false,
              pinned: true,
              forceElevated: true,
              shadowColor: Colors.transparent,
              backgroundColor:
                  app.settings.theme.bottomNavigationBarTheme.backgroundColor,
              title: Text(
                I18n.of(context).evaluationTitle,
                style: TextStyle(fontSize: 22.0),
              ),
              actions: [
                if (app.debugMode) DebugButton(DebugViewClass.evalutaions),
                AccountButton()
              ],
              bottom: CustomTabBar(
                controller: _tabController,
                color: app.settings.theme.textTheme.bodyText1.color,
                onTap: (value) {
                  setState(() {
                    _tabController.animateTo(value);
                  });
                },
                labels: [
                  CustomLabel(
                    title: types.length == 1
                        ? capital(I18n.of(context).evaluationsMidYear)
                        : null,
                    dropdown: types.length > 1
                        ? CustomDropdown(
                            values: {
                              EvaluationType.midYear:
                                  I18n.of(context).evaluationsMidYear,
                              EvaluationType.firstQ:
                                  I18n.of(context).evaluationsQYear,
                              EvaluationType.secondQ:
                                  I18n.of(context).evaluations2qYear,
                              EvaluationType.halfYear:
                                  I18n.of(context).evaluationsHalfYear,
                              EvaluationType.thirdQ:
                                  I18n.of(context).evaluations3qYear,
                              EvaluationType.fourthQ:
                                  I18n.of(context).evaluations4qYear,
                              EvaluationType.endYear:
                                  I18n.of(context).evaluationsEndYear,
                              EvaluationType.levelExam:
                                  I18n.of(context).evaluationsLevelExam,
                              EvaluationType.unknown: I18n.of(context).unknown,
                            },
                            check: (EvaluationType type) {
                              return types.contains(type);
                            },
                            callback: (value) {
                              setState(() {
                                selectedEvalType = EvaluationType.values[value];
                                buildPage();
                              });
                            },
                            initialValue: selectedEvalType.index,
                          )
                        : null,
                  ),
                  CustomLabel(
                      title: capital(I18n.of(context).evaluationsSubjects)),
                  CustomLabel(
                      title: capital(I18n.of(context).evaluationsStatistics)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Grades
            RefreshIndicator(
              key: _refreshKeyGrades,
              onRefresh: () async {
                if (!await app.user.sync.evaluation.sync()) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                    message: I18n.of(context).errorEvaluations,
                    color: Colors.red,
                  ));
                } else {
                  if (mounted)
                    setState(() {
                      buildPage();
                    });
                }
              },
              child: _gradeBuilder.gradeTiles.length > 0
                  ? CupertinoScrollbar(
                      child: AnimationLimiter(
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 64.0),
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: _gradeBuilder.gradeTiles.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: didPageChange
                                  ? Duration.zero
                                  : Duration(milliseconds: 500),
                              delay: didPageChange ? Duration.zero : null,
                              child: SlideAnimation(
                                verticalOffset: 150,
                                child: FadeInAnimation(
                                  child: _gradeBuilder.gradeTiles[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Empty(title: I18n.of(context).emptyGrades),
            ),

            // Subjects
            RefreshIndicator(
              key: _refreshKeySubjects,
              onRefresh: () async {
                if (!await app.user.sync.evaluation.sync()) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                    message: I18n.of(context).errorEvaluations,
                    color: Colors.red,
                  ));
                } else {
                  setState(() {
                    buildPage();
                  });
                }
              },
              child: CupertinoScrollbar(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: _subjectBuilder.subjectTiles,
                ),
              ),
            ),

            // Statistics
            StatisticsPage(),
          ],
        ),
      ),
    );
  }
}
