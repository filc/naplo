import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/controllers/storage.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:filcnaplo/ui/image_viewer.dart';
import 'package:share/share.dart';


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
