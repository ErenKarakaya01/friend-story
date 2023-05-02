import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:friend_story/screens/home/components/request_tile.dart';
import 'package:provider/provider.dart';

import '../../../models/story.dart';

class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    final requests = Provider.of<List<Story>>(context);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: requests.length,
          itemBuilder: (context, index) => RequestTile(request: requests[index]),
        ),
      ],
    );
  }
}
