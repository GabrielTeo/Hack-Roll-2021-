import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';

class HistoryTile extends StatefulWidget {
  final DateTime dateTime;
  final int valence;
  final int arousal;
  final List<String> keywords;
  final Function onDelete;
  final Function onClick;

  @override
  _HistoryTileState createState() => _HistoryTileState();

  HistoryTile({
    this.dateTime,
    this.valence,
    this.arousal,
    this.keywords,
    this.onDelete,
    this.onClick,
  });
}

class _HistoryTileState extends State<HistoryTile> {
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm');
    final String formatted = formatter.format(widget.dateTime);

    return Container(
      child: ListTile(
        title: Text(formatted),
        subtitle: _buildContent(),
        onTap: widget.onClick,
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        },
      ),
      color: Colors.black38,
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Valence: " + widget.valence.toString()),
            Text("Arousal: " + widget.arousal.toString()),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Tags(
            alignment: WrapAlignment.start,
            itemCount: widget.keywords.length, // required
            itemBuilder: (int index) {
              final item = widget.keywords[index];
              return ItemTags(
                // Each ItemTags must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: Key(index.toString()),
                index: index,
                // required
                title: item,
                pressEnabled: false,
                combine: ItemTagsCombine.withTextBefore,
              );
            })
      ],
    );
  }

  void _delete() {
    widget.onDelete();
    Navigator.of(context).pop();
  }


  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Delete History?'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('No'),
        ),
        new FlatButton(
          onPressed: _delete,
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
