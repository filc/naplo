import 'package:filcnaplo/data/models/recipient.dart';
import 'package:filcnaplo/data/models/attachment.dart';

MessageContext messageContext = MessageContext();

class MessageContext {
  String? subject;
  String? content;
  int? replyId;
  List<Recipient> recipients = [];
  List<Attachment> attachments = [];
}
