import 'package:listy/model/list_item.dart';

class _List {
  final String title;
  final List<ListItem> data;
  final DateTime lastTimeEdited;

  _List({
    required this.title,
    required this.data,
    required this.lastTimeEdited,
  });
}
