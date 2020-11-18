//import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:filcnaplo/data/controllers/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:filcnaplo/ui/image_viewer.dart';
import 'package:share/share.dart';

class HomeworkView extends StatefulWidget {
  final Homework homework;
  final Function onSolved;

  HomeworkView(this.homework, this.onSolved);

  @override
  _HomeworkViewState createState() => _HomeworkViewState();
}

class _HomeworkViewState extends State<HomeworkView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: ProfileIcon(name: widget.homework.teacher),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.homework.teacher != null
                              ? capitalize(widget.homework.teacher)
                              : I18n.of(context).unknown,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Text(formatDate(context, widget.homework.date))
                    ],
                  ),
                  subtitle: Text(capital(widget.homework.subjectName)),
                ),
              ),
              // Feature removed by KRETA
              // Container(
              //   width: 42.0,
              //   margin: EdgeInsets.only(right: 12.0),
              //   child: Column(
              //     children: <Widget>[
              //       FlatButton(
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(6.0)),
              //         padding: EdgeInsets.zero,
              //         onPressed: () =>
              //             setState(() => widget.onSolved(widget.homework)),
              //         child: Icon(
              //           widget.homework.isSolved
              //               ? FeatherIcons.checkSquare
              //               : FeatherIcons.square,
              //           color: widget.homework.isSolved
              //               ? app.settings.appColor
              //               : null,
              //         ),
              //       ),
              //       Text(
              //         capital(I18n.of(context).dialogDone),
              //         overflow: TextOverflow.ellipsis,
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),

          // Homework details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: CupertinoScrollbar(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: HomeworkDetail(
                        I18n.of(context).homeworkDeadline,
                        formatDate(context, widget.homework.deadline),
                      ),
                    ),

                    // Message content
                    app.settings.renderHtml
                        ? Html(
                            data: widget.homework.content,
                            onLinkTap: (url) async {
                              if (await canLaunch(url))
                                await launch(url);
                              else
                                throw '[ERROR] HomeworkView.build: Invalid URL';
                            },
                          )
                        : SelectableLinkify(
                            text: escapeHtml(widget.homework.content),
                            onOpen: (url) async {
                              if (await canLaunch(url.url))
                                await launch(url.url);
                              else
                                throw '[ERROR] HomeworkView.build: Invalid URL';
                            },
                          ),
                    widget.homework.attachments == [] 
                        ? Container()
                        : Column(
                            children: widget.homework.attachments
                              .map((attachment) => AttachmentTile(attachment))
                              .toList()
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeworkDetail extends StatelessWidget {
  final String title;
  final String value;

  HomeworkDetail(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Text(
          capital(title) + ":  ",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

//copied from message/view, rewritten to work with homework attachments.
class AttachmentTile extends StatefulWidget {
  AttachmentTile(this.attachment, {Key key}) : super(key: key);

  final HomeworkAttachment attachment;

  @override
  _AttachmentTileState createState() => new _AttachmentTileState();
}

class _AttachmentTileState extends State<AttachmentTile> {
  Uint8List data;

  isImage(HomeworkAttachment attachment) {
    return attachment.name.endsWith(".jpg") || attachment.name.endsWith(".png");
    /* todo: check if it's an image by mime type */
  }

  @override
  initState() {
    var attachment = widget.attachment;
    super.initState();
    if (isImage(attachment)) {
      app.user.kreta.downloadHomeworkAttachment(this.widget.attachment).then((var d) {
        setState(() {
          data = d;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var attachment = widget.attachment;

    handleShare() async {
      String dir = (await getTemporaryDirectory()).path;
      print(dir);
      File temp = new File('$dir/temp.file.' + attachment.name);
      await temp.writeAsBytes(data);
      await Share.shareFiles(['$dir/temp.file.' + attachment.name]);
      temp.delete();
    }

    handleSave() async {
      saveAttachment(attachment, data).then((String f) => OpenFile.open(f));
    }

    tapImage() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImageViewer(
              imageProvider: MemoryImage(data),
              shareHandler: handleShare,
              downloadHandler: handleSave)));
    }

    /* String dir = (await getTemporaryDirectory()).path;
    print(dir);
    File temp = new File('$dir/temp.file.' + attachment.name);
    await temp.writeAsBytes(data);
    /*do something with temp file*/
    await Share.shareFiles(['$dir/temp.file']);
    temp.delete(); */

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      child: Container(
        child: Column(
          children: [
            isImage(attachment)
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 120,
                          child: data != null
                              ? Ink.image(
                                  image: MemoryImage(data),
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                  child: InkWell(onTap: tapImage),
                                )
                              : Center(
                                  child: Container(
                                      width: 35,
                                      height: 35,
                                      child: CircularProgressIndicator()),
                                ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
              child: Row(
                children: <Widget>[
                  Icon(FeatherIcons.file),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        attachment.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(FeatherIcons.download),
                    onPressed: () {
                      if (data != null) {
                        saveAttachment(attachment, data)
                            .then((String f) => OpenFile.open(f));
                      } else {
                        downloadAttachment(attachment);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// todo: error handling (snackbar)
Future<String> saveAttachment(
  HomeworkAttachment attachment,
  Uint8List data,
) async {
  try {
    String downloads = (await DownloadsPathProvider.downloadsDirectory).path;

    if (data != null) {
      var filePath = downloads + "/" + attachment.name;
      print("File: " + filePath);
      if (await StorageController.writeFile(filePath, data)) {
        print("Downloaded " + attachment.name);
        return filePath;
      } else {
        throw "Storage Permission denied";
      }
    } else {
      throw "Cannot write null to file";
    }
  } catch (error) {
    print("ERROR: downloadAttachment: " + error.toString());
  }
}

Future downloadAttachment(HomeworkAttachment attachment) async {
  var data = await app.user.kreta.downloadHomeworkAttachment(attachment);
  saveAttachment(attachment, data).then((String f) => OpenFile.open(f));
}
