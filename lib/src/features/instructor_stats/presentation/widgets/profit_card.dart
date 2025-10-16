import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/features/instructor_stats/domain/entities/instructor_stats_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class ProfitCard extends StatefulWidget {
  final double todayProfit;
  final double monthProfit;
  final double yearProfit;
  final double totalProfit;
  final List<PeriodProfitData> last30DaysProfits;
  final List<PeriodProfitData> last12MonthsProfits;
  final List<PeriodProfitData> allTimeProfits;

  const ProfitCard({
    super.key,
    required this.todayProfit,
    required this.monthProfit,
    required this.yearProfit,
    required this.totalProfit,
    this.last30DaysProfits = const [],
    this.last12MonthsProfits = const [],
    this.allTimeProfits = const [],
  });

  @override
  State<ProfitCard> createState() => _ProfitCardState();
}

class _ProfitCardState extends State<ProfitCard>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPeriodChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final formatter = Formatter();

    final periods = [
      (t.today, widget.todayProfit),
      (t.this_month ?? 'This Month', widget.monthProfit),
      (t.this_year ?? 'This Year', widget.yearProfit),
      (t.all_time ?? 'All Time', widget.totalProfit),
    ];

    final selectedProfit = periods[_selectedIndex].$2;
    final shouldShowChart = _selectedIndex > 0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.total_earnings ?? 'Total Earnings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Profit Amount
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _animation.value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    formatter.formatIqd(selectedProfit),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  periods[_selectedIndex].$1,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Chart Section
          if (shouldShowChart)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(opacity: _animation.value, child: child);
                },
                child: SizedBox(
                  height: 120,
                  child: ProfitChart(
                    selectedIndex: _selectedIndex,
                    last30DaysProfits: widget.last30DaysProfits,
                    last12MonthsProfits: widget.last12MonthsProfits,
                    allTimeProfits: widget.allTimeProfits,
                  ),
                ),
              ),
            ),

          SizedBox(height: shouldShowChart ? 16 : 0),

          // Period Selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: List.generate(periods.length, (index) {
                    final isSelected = _selectedIndex == index;
                    final isCompact = constraints.maxWidth < 350;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onPeriodChanged(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: isCompact ? 6 : 8,
                            horizontal: 4,
                          ),
                          margin: EdgeInsets.only(
                            right: index < periods.length - 1 ? 8 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.25)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  periods[index].$1,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white.withOpacity(
                                      isSelected ? 1.0 : 0.7,
                                    ),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: isCompact ? 10 : 11,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: isCompact ? 2 : 4),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  formatter
                                      .formatIqd(periods[index].$2)
                                      .replaceAll('IQD', '')
                                      .trim(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white.withOpacity(
                                      isSelected ? 1.0 : 0.6,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: isCompact ? 9 : 10,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfitChart extends StatelessWidget {
  final int selectedIndex;
  final List<PeriodProfitData> last30DaysProfits;
  final List<PeriodProfitData> last12MonthsProfits;
  final List<PeriodProfitData> allTimeProfits;

  const ProfitChart({
    super.key,
    required this.selectedIndex,
    required this.last30DaysProfits,
    required this.last12MonthsProfits,
    required this.allTimeProfits,
  });

  List<BarChartGroupData> _getChartData() {
    List<PeriodProfitData> data;

    switch (selectedIndex) {
      case 1: // This Month
        data = last30DaysProfits;
        break;
      case 2: // This Year
        data = last12MonthsProfits;
        break;
      case 3: // All Time
        data = allTimeProfits;
        break;
      default:
        return [];
    }

    if (data.isEmpty) return [];

    final maxProfit = data.map((e) => e.profit).reduce((a, b) => a > b ? a : b);
    final backgroundMax = maxProfit > 0 ? maxProfit * 1.2 : 1000;

    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].profit,
            color: Colors.white.withOpacity(0.85),
            width: selectedIndex == 1 ? 4 : (selectedIndex == 2 ? 12 : 6),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                selectedIndex == 1 ? 2 : (selectedIndex == 2 ? 4 : 3),
              ),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: backgroundMax.toDouble(),
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ],
      );
    });
  }

  String _getBottomTitle(double value, int selectedIndex) {
    final index = value.toInt();

    switch (selectedIndex) {
      case 1: // Month - show days
        if (last30DaysProfits.isEmpty) return '';
        if (index >= last30DaysProfits.length) return '';
        if (index % 5 == 0) {
          return '${last30DaysProfits[index].date.day}';
        }
        return '';
      case 2: // Year - show months
        const months = [
          'J',
          'F',
          'M',
          'A',
          'M',
          'J',
          'J',
          'A',
          'S',
          'O',
          'N',
          'D',
        ];
        if (index >= last12MonthsProfits.length) return '';
        return months[last12MonthsProfits[index].date.month - 1];
      case 3: // All time - show quarters
        if (allTimeProfits.isEmpty) return '';
        if (index >= allTimeProfits.length) return '';
        if (index % 6 == 0) {
          final monthIndex = index ~/ 6;
          return 'Q${monthIndex + 1}';
        }
        return '';
      default:
        return '';
    }
  }

  String _getTooltipLabel(int index) {
    switch (selectedIndex) {
      case 1: // Month
        if (index >= last30DaysProfits.length) return '';
        final date = last30DaysProfits[index].date;
        return '${date.day}/${date.month}';
      case 2: // Year
        if (index >= last12MonthsProfits.length) return '';
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return months[last12MonthsProfits[index].date.month - 1];
      case 3: // All time
        if (index >= allTimeProfits.length) return '';
        final date = allTimeProfits[index].date;
        return '${date.month}/${date.year}';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getChartData();
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      );
    }

    // CRITICAL FIX: Handle zero profit case
    final maxY = data
        .map((group) => group.barRods.first.toY)
        .reduce((a, b) => a > b ? a : b);

    // If maxY is 0 or very small, use a default value
    final chartMaxY = maxY > 0 ? maxY * 1.2 : 1000;
    final interval = maxY > 0 ? maxY / 3 : 300;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: chartMaxY.toDouble(),
        minY: 0,
        groupsSpace: selectedIndex == 1 ? 2 : (selectedIndex == 2 ? 8 : 4),
        barGroups: data,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval
              .toDouble(), // FIXED: This can never be 0 now
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1),
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final text = _getBottomTitle(value, selectedIndex);
                if (text.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.white.withOpacity(0.95),
            tooltipBorderRadius: BorderRadius.circular(8),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final formatter = Formatter();
              final label = _getTooltipLabel(group.x.toInt());

              return BarTooltipItem(
                '$label\n${formatter.formatIqd(rod.toY)}',
                TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              );
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 300),
      swapAnimationCurve: Curves.easeInOutCubic,
    );
  }
}
