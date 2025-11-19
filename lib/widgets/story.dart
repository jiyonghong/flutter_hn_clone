import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hn_clone/models/story.dart';
import 'package:humanize/humanize.dart';

class StoryWidget extends StatefulWidget {
  final Story story;

  const StoryWidget({super.key, required this.story});

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 12.0,
          bottom: 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.story.title, style: textTheme.headlineSmall),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('by ', style: textTheme.bodyMedium),
                Text(
                  widget.story.by,
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  naturaltime(
                    DateTime.fromMillisecondsSinceEpoch(
                      widget.story.time * 1000,
                    ),
                  ),
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.bookmark_outline),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                    Badge(
                      label: Text('${widget.story.kids?.length}'),
                      isLabelVisible: widget.story.kids != null,
                      offset: const Offset(-4, 4),
                      textColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.story.text != null
                      ? [
                          Text(
                            'Read more ',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Icon(Icons.arrow_forward_rounded, size: 16),
                        ]
                      : [
                          Text(
                            'Visit link ',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Icon(Icons.link, size: 16),
                        ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
