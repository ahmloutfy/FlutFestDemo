import 'package:flutfest/logic/controllers/settings_controller.dart';
import 'package:flutfest/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsCategories extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const EventsCategories({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.isRegistered<SettingsController>()
        ? Get.find<SettingsController>()
        : Get.put(SettingsController(), permanent: true);
    return Obx(() {
      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      final bool isDark = controller.themeOption.value == ThemeOption.dark ||
          (controller.themeOption.value == ThemeOption.system && isDarkMode);
      final Color selectedButtonColor =
      isDark ? AppTheme.darkButtonColor : AppTheme.lightButtonColor;
      final Color selectedTextColor =
      isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor;

      final Color unselectedTextColor =
      isDark ? AppTheme.darkTextColor : AppTheme.lightTextColor;

      return SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildTab('All', context, selectedButtonColor, selectedTextColor, unselectedTextColor),
            _buildTab('Upcoming', context, selectedButtonColor, selectedTextColor, unselectedTextColor),
            _buildTab('Expired', context, selectedButtonColor, selectedTextColor, unselectedTextColor),
            _buildTab('Favorites', context, selectedButtonColor, selectedTextColor, unselectedTextColor),
          ],
        ),
      );
    });
  }

  Widget _buildTab(String title, BuildContext context, Color selectedButtonColor, Color selectedTextColor, Color unselectedTextColor) {
    final bool isSelected = title == selectedTab;

    return Container(
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () => onTabSelected(title),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          isSelected ? selectedButtonColor : Colors.transparent,
          foregroundColor: isSelected ? selectedTextColor : unselectedTextColor,
          side: BorderSide(color: selectedButtonColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
