import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/pages/messages/message/builder.dart';
import 'package:filcnaplo/ui/pages/messages/note/builder.dart';
import 'package:filcnaplo/ui/pages/messages/event/builder.dart';
import 'package:filcnaplo/data/context/message.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/ui/common/account_button.dart';
import 'package:filcnaplo/ui/common/custom_snackbar.dart';
import 'package:filcnaplo/ui/common/custom_tabs.dart';
import 'package:filcnaplo/ui/common/empty.dart';
import 'package:filcnaplo/ui/pages/debug/button.dart';
import 'package:filcnaplo/ui/pages/debug/view.dart';
import 'package:filcnaplo/ui/pages/messages/compose.dart';
import 'package:flutter/cupertino.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  MessageBuilder _messageBuilder;
  NoteBuilder _noteBuilder;
  EventBuilder _eventBuilder;

  _MessagesPageState() {
    this._messageBuilder = MessageBuilder(() => setState(() {
          buildPage();
        }));
    this._noteBuilder = NoteBuilder();
    this._eventBuilder = EventBuilder();
  }

  final _refreshKeyMessages = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyNotes = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyEvents = GlobalKey<RefreshIndicatorState>();

  TabController _tabController;
  MessageType selectedMessageType = MessageType.inbox;
  bool didPageChange;
  List<Widget> messageTiles = [];

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 3,
    );
    didPageChange = false;
    _tabController.addListener(() => setState(() => didPageChange = true));
    super.initState();
    buildPage();
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
    if (app.user.sync.messages.uiPending ||
        app.user.sync.note.uiPending ||
        app.user.sync.event.uiPending) {
      app.user.sync.messages.uiPending = false;
      app.user.sync.note.uiPending = false;
      app.user.sync.event.uiPending = false;
      buildPage();
    }

    return Scaffold(
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              child: Icon(Icons.edit, color: app.settings.appColor),
              backgroundColor: app.settings.theme.backgroundColor,
              onPressed: () {
                if (!app.debugUser) {
                  messageContext = MessageContext();

                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                          builder: (context) => NewMessagePage()))
                      .then((_) => setState(() {
                            buildPage();
                          }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar(
                      color: Colors.red,
                      message:
                          "Message writing is not available with the debug user.",
                    ),
                  );
                }
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
              stretch: true,
              shadowColor: Colors.transparent,
              backgroundColor:
                  app.settings.theme.bottomNavigationBarTheme.backgroundColor,
              title: Text(
                I18n.of(context).messageTitle,
                style: TextStyle(fontSize: 22.0),
              ),
              actions: [
                app.debugMode
                    ? DebugButton(DebugViewClass.messages)
                    : Container(),
                AccountButton()
              ],
              bottom: CustomTabBar(
                controller: _tabController,
                color: app.settings.theme.textTheme.bodyText1.color,
                onTap: (value) {
                  _tabController.animateTo(value);
                  setState(() {
                    buildPage();
                  });
                },
                labels: [
                  CustomLabel(
                    dropdown: CustomDropdown(
                        initialValue: selectedMessageType.index,
                        callback: (value) {
                          setState(() {
                            selectedMessageType = MessageType.values[value];
                            buildPage();
                          });
                        },
                        values: {
                          0: capital(I18n.of(context).messageDrawerInbox),
                          1: capital(I18n.of(context).messageDrawerSent),
                          2: capital(I18n.of(context).messageDrawerTrash),
                          3: capital(I18n.of(context).messageDrawerDrafts),
                        }),
                  ),
                  CustomLabel(title: capital(I18n.of(context).noteTitle)),
                  CustomLabel(title: capital(I18n.of(context).eventTitle)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Messages
            RefreshIndicator(
              key: _refreshKeyMessages,
              onRefresh: () async {
                if (!await app.user.sync.messages.sync()) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                    message: I18n.of(context).errorMessages,
                    color: Colors.red,
                  ));
                } else {
                  setState(() {
                    buildPage();
                  });
                }
              },

              // Message Tiles
              child: CupertinoScrollbar(
                child: messageTiles.length > 1
                    ? AnimationLimiter(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.only(top: 12.0),
                          itemCount: messageTiles.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: didPageChange
                                  ? Duration.zero
                                  : Duration(milliseconds: 400),
                              delay: didPageChange ? Duration.zero : null,
                              child: SlideAnimation(
                                verticalOffset: 150,
                                child:
                                    FadeInAnimation(child: messageTiles[index]),
                              ),
                            );
                          },
                        ),
                      )
                    : ListView(
                        children: [
                          Empty(
                            title: selectedMessageType == MessageType.draft
                                ? I18n.of(context).notImplemented
                                : I18n.of(context).emptyMessages,
                          )
                        ],
                      ),
              ),
            ),

            // Notes
            RefreshIndicator(
              key: _refreshKeyNotes,
              onRefresh: () async {
                if (!await app.user.sync.note.sync()) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                    message: I18n.of(context).errorMessages,
                    color: Colors.red,
                  ));
                } else {
                  setState(() {
                    buildPage();
                  });
                }
              },
              child: CupertinoScrollbar(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: _noteBuilder.noteTiles.length != 0
                        ? _noteBuilder.noteTiles.length
                        : 1,
                    itemBuilder: (context, index) {
                      if (_noteBuilder.noteTiles.length > 0) {
                        return _noteBuilder.noteTiles[index];
                      } else {
                        return Empty(title: I18n.of(context).emptyNotes);
                      }
                    }),
              ),
            ),

            // Events
            RefreshIndicator(
              key: _refreshKeyEvents,
              onRefresh: () async {
                if (!await app.user.sync.event.sync()) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                    message: I18n.of(context).errorMessages,
                    color: Colors.red,
                  ));
                } else {
                  setState(() {
                    buildPage();
                  });
                }
              },
              child: CupertinoScrollbar(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: _eventBuilder.eventTiles.length != 0
                        ? _eventBuilder.eventTiles.length
                        : 1,
                    itemBuilder: (context, index) {
                      if (_eventBuilder.eventTiles.length > 0) {
                        return _eventBuilder.eventTiles[index];
                      } else {
                        return Empty(title: I18n.of(context).emptyEvents);
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buildPage() {
    _messageBuilder.build();
    _noteBuilder.build();
    _eventBuilder.build();

    messageTiles = [];

    messageTiles.addAll(_messageBuilder.messageTiles
        .getSelectedMessages(selectedMessageType.index));
    messageTiles.add(SizedBox(height: 100.0));
  }
}
