import 'dart:typed_data';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/controllers/storage.dart';
import 'package:filcnaplo/data/models/attachment.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:filcnaplo/ui/pages/messages/message/image_viewer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class AttachmentTile extends StatefulWidget {
  AttachmentTile(this.attachment, {Key key}) : super(key: key);

  final Attachment attachment;

  @override
  _AttachmentTileState createState() => new _AttachmentTileState();
}

class _AttachmentTileState extends State<AttachmentTile> {
  Uint8List data;

  isImage(Attachment attachment) {
    return attachment.name.endsWith(".jpg") ||
        attachment.name.endsWith(".png") ||
        attachment.name.endsWith(".jpeg");
    /* todo: check if it's an image by mime type */
  }

  @override
  initState() {
    var attachment = widget.attachment;
    super.initState();
    if (isImage(attachment)) {
      app.user.kreta.downloadAttachment(this.widget.attachment).then((var d) {
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
      saveAttachment(attachment, data, context: context)
          .then((String f) => OpenFile.open(f));
    }

    openImage() {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => ImageViewer(
              imageProvider: MemoryImage(data),
              shareHandler: handleShare,
              downloadHandler: handleSave)));
    }

    return Container(
      padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 12.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.only(
          bottom: 12.0,
          top: isImage(attachment) ? 0 : 12.0,
        ),
        onPressed: () {
          if (data != null) {
            saveAttachment(attachment, data, context: context)
                .then((String f) => OpenFile.open(f));
          } else {
            downloadAttachment(attachment, context: context);
          }
        },
        child: Column(
          children: [
            isImage(attachment)
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 132,
                          margin: EdgeInsets.only(bottom: 12.0),
                          child: data != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Material(
                                    child: InkWell(
                                      child: Ink.image(
                                        image: MemoryImage(data),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                      onTap: openImage,
                                    ),
                                    color: Colors.transparent,
                                  ),
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
                children: [
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
                  Icon(
                    FeatherIcons.download,
                    color: app.settings.appColor,
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
  Attachment attachment,
  Uint8List data, {
  @required BuildContext context,
}) async {
  try {
    String downloads;

    if (Platform.isAndroid) {
      downloads = "/storage/self/primary/Download";
    } else {
      downloads = (await getTemporaryDirectory()).path;
    }

    if (data != null) {
      var filePath = downloads + "/" + attachment.name;
      if (app.debugMode) print("INFO: Saved file: " + filePath);
      if (await StorageController.writeFile(filePath, data)) {
        print("INFO: Downloaded " + attachment.name);
        return filePath;
      } else {
        throw "Storage Permission denied";
      }
    } else {
      throw "Cannot write null to file";
    }
  } catch (error) {
    print("ERROR: downloadAttachment: " + error.toString());
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            I18n.of(context).messageAttachmentFailed,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }
}

Future downloadAttachment(
  Attachment attachment, {
  @required BuildContext context,
}) async {
  var data = await app.user.kreta.downloadAttachment(attachment);
  saveAttachment(attachment, data, context: context)
      .then((String f) => OpenFile.open(f));
}
