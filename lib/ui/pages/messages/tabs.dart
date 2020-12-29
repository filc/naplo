import 'package:filcnaplo/data/context/message.dart';
import 'package:filcnaplo/ui/account_button.dart';
import 'package:filcnaplo/ui/custom_tabs.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/debug/button.dart';
import 'package:filcnaplo/ui/pages/debug/view.dart';
import 'package:filcnaplo/ui/pages/messages/compose.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';

class MessageTabs extends StatefulWidget {
  final _scaffoldKey;
  final messageTiles;
  final noteTiles;
  final eventTiles;
  final Function callback;

  MessageTabs(
    this._scaffoldKey,
    this.messageTiles,
    this.noteTiles,
    this.eventTiles, {
    this.callback,
  });

  @override
  _MessageTabsState createState() => _MessageTabsState();
}

class _MessageTabsState extends State<MessageTabs>
    with SingleTickerProviderStateMixin {
  final _refreshKeyMessages = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyNotes = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyEvents = GlobalKey<RefreshIndicatorState>();
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 3,
    );
    _tabController.addListener(() => widget.callback());
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
    return Scaffold(
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              child: Icon(Icons.edit, color: app.settings.appColor),
              backgroundColor: app.settings.theme.backgroundColor,
              onPressed: () {
                messageContext = MessageContext();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewMessagePage()));
              },
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              forceElevated: true,
              title: Text(
                I18n.of(context).messageTitle,
                style: TextStyle(fontSize: 22.0),
              ),
              actions: <Widget>[
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
                  widget.callback();
                },
                labels: [
                  CustomLabel(
                    dropdown: CustomDropdown(
                        initialValue: app.selectedMessagePage,
                        callback: (value) {
                          setState(() => app.selectedMessagePage = value);
                          widget.callback();
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
          children: <Widget>[
            // Messages
            RefreshIndicator(
              key: _refreshKeyMessages,
              onRefresh: () async {
                if (!await app.user.sync.messages
                    .sync()) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      I18n.of(context).errorMessages,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  widget.callback();
                }
              },

              // Message Tiles
              child: CupertinoScrollbar(
                child: ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.only(top: 12.0),
                  children: [
                    Column(
                      children:
                          widget.messageTiles.getSelectedMessages(app.selectedMessagePage).length >
                                  0
                              ? widget.messageTiles.getSelectedMessages(app.selectedMessagePage)
                              : <Widget>[
                                  Empty(
                                    title: app.selectedMessagePage == 3
                                        ? I18n.of(context).notImplemented
                                        : I18n.of(context).emptyMessages,
                                  ),
                                ],
                    ),
                    SizedBox(height: 100.0),
                  ],
                ),
              ),
            ),

            // Notes
            RefreshIndicator(
              key: _refreshKeyNotes,
              onRefresh: () async {
                if (!await app.user.sync.note.sync()) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      I18n.of(context).errorMessages,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  widget.callback();
                }
              },
              child: CupertinoScrollbar(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: widget.noteTiles.length > 0
                      ? widget.noteTiles
                      : <Widget>[
                          Empty(title: I18n.of(context).emptyNotes),
                        ],
                ),
              ),
            ),

            // Events
            RefreshIndicator(
              key: _refreshKeyEvents,
              onRefresh: () async {
                if (!await app.user.sync.event.sync()) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      I18n.of(context).errorMessages,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  widget.callback();
                }
              },
              child: widget.eventTiles.length > 0
                  ? CupertinoScrollbar(
                      child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: widget.eventTiles),
                    )
                  : Empty(title: I18n.of(context).emptyEvents),
            ),
          ],
        ),
      ),
    );
  }
}
