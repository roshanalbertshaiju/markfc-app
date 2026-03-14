import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:markfc/core/theme/mifc_colors.dart';

class MatchCalendarPopup extends StatefulWidget {
  const MatchCalendarPopup({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: Material(
          color: Colors.transparent,
          child: MatchCalendarPopup(),
        ),
      ),
    );
  }

  @override
  State<MatchCalendarPopup> createState() => _MatchCalendarPopupState();
}

class _MatchCalendarPopupState extends State<MatchCalendarPopup> {
  DateTime _focusedDay = DateTime(2025, 9, 13);
  DateTime? _selectedDay;

  // Mock match dates based on FixturesScreen
  final Set<DateTime> _matchDates = {
    DateTime(2025, 9, 13),
    DateTime(2025, 9, 20),
    DateTime(2025, 10, 4),
    DateTime(2025, 10, 10),
  };

  bool _isMatchDay(DateTime day) {
    return _matchDates.any((d) => 
      d.year == day.year && d.month == day.month && d.day == day.day);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF06080F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FIXTURE CALENDAR',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2026, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: GoogleFonts.inter(color: Colors.white70),
              weekendTextStyle: GoogleFonts.inter(color: Colors.white70),
              outsideTextStyle: GoogleFonts.inter(color: Colors.white24),
              todayDecoration: BoxDecoration(
                color: MifcColors.prestigeGold.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: MifcColors.prestigeGold,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: MifcColors.crimson,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              leftChevronIcon: const Icon(Icons.chevron_left, color: MifcColors.prestigeGold),
              rightChevronIcon: const Icon(Icons.chevron_right, color: MifcColors.prestigeGold),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w600),
              weekendStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            eventLoader: (day) {
              if (_isMatchDay(day)) {
                return ['Match'];
              }
              return [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: MifcColors.crimson,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: MifcColors.crimson,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Match Day',
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
