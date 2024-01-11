import 'package:flutter/widgets.dart';

class NotifiableBuilder extends StatefulWidget {
  const NotifiableBuilder({Key? key, required this.notifier, required this.builder}) : super(key: key);

  final ChangeNotifier notifier;
  final WidgetBuilder builder;

  @override
  State<StatefulWidget> createState() => NotifiableBuilderState();
}

class NotifiableBuilderState extends State<NotifiableBuilder> {
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      setState(() {});
    };
    widget.notifier.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);

  @override
  void dispose() {
    widget.notifier.removeListener(_listener);
    super.dispose();
  }

  @override
  void didUpdateWidget(NotifiableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.notifier.removeListener(_listener);
    widget.notifier.addListener(_listener);
  }
}
