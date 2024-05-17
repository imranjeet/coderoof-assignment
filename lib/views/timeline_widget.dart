import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TimeLineWidget extends StatelessWidget {
  const TimeLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.7,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            timelineCard(),
          ],
        ),
      ),
    );
  }

  Widget timelineCard() {
    final events = [
      Event(
        startTime: DateTime(2023, 5, 10, 10, 0),
        endTime: DateTime(2023, 5, 10, 11, 30),
        title: 'Hyde Vineyard Estate',
        subtitle: '40 mins · 45 Miles',
        price: '\$75',
        duration: '90mins',
        icon: 'assets/images/TIMESAVOR.svg',
        additionalIcon: null,
      ),
      Event(
        startTime: DateTime(2023, 5, 10, 14, 0),
        endTime: DateTime(2023, 5, 10, 16, 0),
        title: 'Angele Restaurant',
        subtitle: '40 mins · 45 Miles',
        price: '\$60',
        duration: '2hrs',
        icon: 'assets/images/restaurant.svg',
        additionalIcon: 'assets/images/check-circle.svg',
      ),
    ];

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: _buildTimeline(events),
        ),
      ),
    );
  }

  List<Widget> _buildTimeline(List<Event> events) {
    List<Widget> timeline = [];
    DateTime currentTime = DateTime(2023, 5, 10, 0, 0);

    for (int i = 0; i < 48; i++) {
      Event? currentEvent = events.firstWhere(
        (event) => event.startTime == currentTime,
        orElse: () => Event.empty(),
      );

      if (currentEvent.isEmpty) {
        timeline.add(_buildTimeSlot(currentTime));
      } else {
        timeline.add(_buildEventCard(currentEvent));
        currentTime = currentEvent.endTime;
        i += (currentEvent.endTime.difference(currentEvent.startTime).inMinutes / 30).round() - 1;
      }

      currentTime = currentTime.add(const Duration(minutes: 30));
    }

    return timeline;
  }

  Widget _buildTimeSlot(DateTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        children: [
          Text(
            DateFormat('h:mm a').format(time),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: [
                  TextSpan(
                      text: DateFormat('h:mm ').format(event.startTime),
                      style: const TextStyle(color: Colors.black)),
                  TextSpan(
                      text: DateFormat('a').format(event.startTime),
                      style: const TextStyle(color: Colors.black)),
                ]),
              ),
              const SizedBox(height: 65),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(children: [
                  TextSpan(
                      text: DateFormat('h:mm ').format(event.endTime),
                      style: const TextStyle(color: Colors.black)),
                  TextSpan(
                      text: DateFormat('a').format(event.endTime),
                      style: const TextStyle(color: Colors.black)),
                ]),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 12),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0XFFFFEFF4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 251,
                  margin: const EdgeInsets.only(left: 2),
                  child: Row(
                    children: [
                      SvgPicture.asset(event.icon),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 6, left: 6, bottom: 5),
                        child: Text(
                          event.title,
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (event.additionalIcon != null)
                        SvgPicture.asset(event.additionalIcon!),
                      const Icon(Icons.more_horiz, color: Colors.black),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/car.svg"),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          event.subtitle,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      event.price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF800020),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3, left: 4),
                      child: Text(
                        "Per tasting",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2, left: 24),
                      child: SvgPicture.asset("assets/images/TimeSquare.svg"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        event.duration,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Event {
  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String subtitle;
  final String price;
  final String duration;
  final String icon;
  final String? additionalIcon;

  Event({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.duration,
    required this.icon,
    this.additionalIcon,
  });

  Event.empty()
      : startTime = DateTime(0),
        endTime = DateTime(0),
        title = '',
        subtitle = '',
        price = '',
        duration = '',
        icon = '',
        additionalIcon = null;

  bool get isEmpty => title.isEmpty;
}