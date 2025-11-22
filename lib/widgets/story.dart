import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hn_clone/models/story.dart';
import 'package:flutter_hn_clone/screens/webview.dart';
import 'package:heroicons/heroicons.dart';
import 'package:humanize/humanize.dart';

class StoryWidget extends StatelessWidget {
  final Story story;
  final bool? isBookmarked;
  final VoidCallback? onToggleBookmark;

  const StoryWidget({
    super.key,
    required this.story,
    this.isBookmarked,
    this.onToggleBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        final url = story.url;

        if (url != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => WebViewScreen(url: url)),
          );
        }
      },
      child: Card(
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
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.aboveBaseline,
                      baseline: TextBaseline.ideographic,
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HeroIcon(
                              HeroIcons.arrowUp,
                              size: 12,
                              color: Colors.white,
                            ),
                            Text(
                              story.score.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextSpan(text: story.title, style: textTheme.headlineSmall),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('by ', style: textTheme.bodyMedium),
                  Text(
                    story.by,
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    naturaltime(
                      DateTime.fromMillisecondsSinceEpoch(story.time * 1000),
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
                        icon: HeroIcon(
                          HeroIcons.bookmark,
                          style: isBookmarked == true
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                        ),
                        onPressed: () {
                          onToggleBookmark?.call();
                          HapticFeedback.lightImpact();
                        },
                      ),
                      Badge(
                        label: Text('${story.kids?.length}'),
                        isLabelVisible: story.kids != null,
                        offset: const Offset(-4, 4),
                        textColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        child: IconButton(
                          icon: const HeroIcon(
                            HeroIcons.chatBubbleBottomCenterText,
                          ),
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
                    children: story.text != null
                        ? [
                            Text(
                              'Read more ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            HeroIcon(HeroIcons.arrowRight, size: 16),
                          ]
                        : [
                            Text(
                              'Visit link ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            HeroIcon(HeroIcons.link, size: 16),
                          ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
