import 'package:coderoof_assignment/views/timeline_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  DateTime initailDataTime = DateTime.now();
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(
        initailDataTime.year, initailDataTime.month, initailDataTime.day);
    _currentMonth =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: SvgPicture.asset(
            "assets/images/back_circle.svg",
            fit: BoxFit.cover,
          ),
        ),
        title: const Text(
          "Itinerary for Napa, CA",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0XFF32343E)),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              // _onMenuItemSelected(value as int);
            },
            surfaceTintColor: Colors.white,
            offset: const Offset(0.0, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            itemBuilder: (BuildContext ctx) => <PopupMenuEntry<dynamic>>[
              _buildPopupMenuItem('Share Itinerary', Icons.share_outlined),
              const PopupMenuDivider(),
              _buildPopupMenuItem('Invite A  Friend', Icons.person_add),
              const PopupMenuDivider(),
              _buildPopupMenuItem('Rearrange Itinerary', Icons.copy),
              const PopupMenuDivider(),
              _buildPopupMenuItem('Edit Name', Icons.edit),
              const PopupMenuDivider(),
              _buildPopupMenuItem('Change Date', Icons.calendar_month),
              const PopupMenuDivider(),
              _buildPopupMenuItem('Add From Saved', Icons.bookmark),
              const PopupMenuDivider(),
              _buildPopupMenuItem('Delete Itinerary', Icons.delete),
            ],
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SvgPicture.asset("assets/images/more_circle.svg"),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: const Color(0XFF800020),
            borderRadius: BorderRadius.circular(20)),
        width: 106,
        height: 40,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/location.svg"),
                const SizedBox(width: 5),
                const Text(
                  "Map",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month - 1, 1);
                    });
                  },
                ),
              ),
              Text(
                DateFormat.yMMM().format(_currentMonth),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 20),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                          _currentMonth.year, _currentMonth.month + 1, 1);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          _buildCalendar(),
          const TimeLineWidget(),
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title, IconData iconData) {
    return PopupMenuItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          Icon(
            iconData,
            color: Colors.black,
          ),
          const SizedBox(width: 15),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _getDaysInMonth(_currentMonth).length,
        itemBuilder: (context, index) {
          final DateTime date = _getDaysInMonth(_currentMonth)[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              width: 56.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: _selectedDate == date
                    ? const Color.fromRGBO(128, 0, 32, 1)
                    : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      color:
                          _selectedDate == date ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color:
                          _selectedDate == date ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final List<DateTime> days = [];
    final int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    for (int i = 0; i < daysInMonth; i++) {
      final DateTime day = DateTime(month.year, month.month, i + 1);
      days.add(day);
    }

    return days;
  }

  void _scrollToCurrentDate() {
    final currentDateIndex = _getDaysInMonth(_currentMonth).indexWhere((date) =>
        date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day);
    if (currentDateIndex != -1) {
      _scrollController.animateTo(
        (currentDateIndex * 66).toDouble(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
