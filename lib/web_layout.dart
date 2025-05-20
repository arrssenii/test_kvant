// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'menu_item_model.dart';
//
// class WebLayout extends StatefulWidget {
//   const WebLayout({super.key});
//
//   @override
//   State<WebLayout> createState() => _WebLayoutState();
// }
//
// class _WebLayoutState extends State<WebLayout> {
//   int _selectedIndex = 0;
//   bool _isExpanded = true;
//   bool _isAnimationCompleted = true;
//   List<MenuItemModel> _menuItems = [];
//
//   static const double collapsedWidth = 56;
//   static const double expandedWidth = 200;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMenu();
//   }
//
//   Future<void> _loadMenu() async {
//     final String jsonStr = await rootBundle.loadString('assets/menu.json');
//     final List<dynamic> jsonData = json.decode(jsonStr)['menuItems'];
//
//     setState(() {
//       _menuItems =
//           jsonData.map((item) => MenuItemModel.fromJson(item)).toList();
//     });
//   }
//
//   void _toggleMenu() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       _isAnimationCompleted = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             width: _isExpanded ? expandedWidth : collapsedWidth,
//             onEnd: () {
//               setState(() {
//                 _isAnimationCompleted = true;
//               });
//             },
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4,
//                   offset: const Offset(2, 0),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: IconButton(
//                     icon: Icon(
//                       _isExpanded
//                           ? Icons.arrow_back_ios
//                           : Icons.arrow_forward_ios,
//                     ),
//                     onPressed: _toggleMenu,
//                   ),
//                 ),
//                 Expanded(
//                   child: _menuItems.isEmpty
//                       ? const Center(child: CircularProgressIndicator())
//                       : NavigationRail(
//                     selectedIndex: _selectedIndex.clamp(0, _menuItems.length - 1),
//                     onDestinationSelected: (int index) {
//                       setState(() {
//                         _selectedIndex = index;
//                       });
//                     },
//                     extended: _isExpanded,
//                     destinations: _menuItems
//                         .map(
//                           (item) => NavigationRailDestination(
//                         icon: Icon(_getIconByName(item.icon)),
//                         selectedIcon:
//                         Icon(_getIconByName(item.icon), color: Colors.blue),
//                         label: _isExpanded && _isAnimationCompleted
//                             ? Text(item.label)
//                             : const SizedBox.shrink(),
//                       ),
//                     )
//                         .toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const VerticalDivider(thickness: 1, width: 1),
//           Expanded(
//             child: Center(
//               child: _menuItems.isEmpty
//                   ? const CircularProgressIndicator()
//                   : Text(
//                 'Вы выбрали: ${_menuItems[_selectedIndex].label}',
//                 style: const TextStyle(fontSize: 24),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Преобразует имя иконки в соответствующий объект Icons.
//   IconData _getIconByName(String iconName) {
//     const Map<String, IconData> iconMap = {
//       'home': Icons.thermostat,
//       'person': Icons.folder_copy,
//       'message': Icons.currency_ruble_outlined,
//       'settings': Icons.settings,
//       'info': Icons.info,
//     };
//     return iconMap[iconName] ?? Icons.circle_outlined;
//   }
// }

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu_item_model.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  List<MenuItemModel> _menuItems = [];
  int _selectedIndex = 0;
  bool _isExpanded = true;
  bool _isAnimationCompleted = true;

  static const double collapsedWidth = 56;
  static const double expandedWidth = 220;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  /// Загрузка меню из JSON
  Future<void> _loadMenu() async {
    final String jsonStr = await rootBundle.loadString('assets/menu.json');
    final List<dynamic> jsonData = json.decode(jsonStr)['menuItems'];
    setState(() {
      _menuItems = jsonData
          .map((item) => MenuItemModel.fromJson(item))
          .toList();
    });
  }

  /// Переключение состояния меню (свёрнуто/развёрнуто)
  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isAnimationCompleted = false;
    });
  }

  /// Обработка выбора элемента
  void _onSelect(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
         defaultTargetPlatform == TargetPlatform.android);

    if (_menuItems.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      bottomNavigationBar: isMobile ? _buildBottomBar() : null,
    );
  }

  /// Веб-дизайн: левое меню с группировкой по разделам
  Widget _buildDesktopLayout() {
    final groupedItems = <String, List<MenuItemModel>>{};

    for (final item in _menuItems) {
      groupedItems.putIfAbsent(item.section, () => []).add(item);
    }

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isExpanded ? expandedWidth : collapsedWidth,
          onEnd: () => setState(() => _isAnimationCompleted = true),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    _isExpanded
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                  ),
                  onPressed: _toggleMenu,
                ),
              ),
              Expanded(
                child: ListView(
                  children: groupedItems.entries.expand((entry) {
                    final sectionTitle = entry.key;
                    final sectionItems = entry.value;

                    return [
                      if (_isExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(sectionTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ...sectionItems.map((item) {
                        final index = _menuItems.indexOf(item);
                        final isSelected = _selectedIndex == index;
                        return ListTile(
                          leading: Icon(
                            _getIcon(item.icon),
                            color: isSelected ? Colors.blue : null,
                          ),
                          title: _isExpanded
                              ? Text(item.label)
                              : null,
                          selected: isSelected,
                          onTap: () => _onSelect(index),
                          contentPadding: EdgeInsets.symmetric(horizontal: _isExpanded ? 16 : 8),
                        );
                      }),
                    ];
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Center(
            child: Text(
              'Вы выбрали: ${_menuItems[_selectedIndex].label}',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }

  /// Мобильная версия: отображаем только первые 4 команды
  Widget _buildMobileLayout() {
    return Center(
      child: Text(
        'Вы выбрали: ${_menuItems[_selectedIndex].label}',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  /// Нижняя панель для мобильной версии
  Widget _buildBottomBar() {
    final List<MenuItemModel> mobileItems = _menuItems.take(4).toList();

    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex.clamp(0, mobileItems.length - 1),
      onTap: (int index) {
        final originalIndex = _menuItems.indexOf(mobileItems[index]);
        _onSelect(originalIndex);
      },
      items: mobileItems.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(_getIcon(item.icon)),
          label: item.label,
        );
      }).toList(),
    );
  }

  /// Сопоставление строкового имени иконки с реальной иконкой Flutter
  IconData _getIcon(String name) {
    const icons = {
      'calendar_today': Icons.calendar_today,
      'groups': Icons.groups,
      'event_note': Icons.event_note,
      'notifications': Icons.notifications,
      'medication': Icons.medication,
      'local_hospital': Icons.local_hospital,
      'paid': Icons.paid,
      'settings': Icons.settings,
    };
    return icons[name] ?? Icons.circle_outlined;
  }
}

