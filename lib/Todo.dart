import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class Todo {
  static final dbUUID = "uuid";
  static final dbTitle = "title";
  static final dbDescription = "description";
  static final dbDateExpire = "dateExpire";
  static final dbDateNotification = "dateNotification";
  static final dbNotification = "notification";
  static final dbTag = "tag";

  String uuid;
  String title;
  String description;
  String dateExpire;
  String dateNotification;
  String notification;
  String tag;

  Todo(
      {@required this.uuid,
      @required this.title,
      @required this.description,
      @required this.dateExpire,
      @required this.dateNotification,
      @required this.notification,
      @required this.tag});

  Todo.fromMap(Map<String, dynamic> map)
      : this(
            uuid : map[dbUUID],
            title: map[dbTitle],
            description: map[dbDescription],
            dateExpire: map[dbDateExpire],
            dateNotification: map[dbDateNotification],
            notification: map[dbNotification],
            tag: map[dbTag]);

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      dbUUID: uuid,
      dbTitle: title,
      dbDescription: description,
      dbDateExpire: dateExpire,
      dbDateNotification: dateNotification,
      dbNotification: notification,
      dbTag: tag
    };
  }
}
