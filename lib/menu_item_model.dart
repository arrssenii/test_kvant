// class MenuItemModel {
//   final String icon;
//   final String label;
// 
//   MenuItemModel({required this.icon, required this.label});
// 
//   factory MenuItemModel.fromJson(Map<String, dynamic> json) {
//     return MenuItemModel(
//       icon: json['icon'] as String,
//       label: json['label'] as String,
//     );
//   }
// }

/// Модель элемента меню
class MenuItemModel {
  final String icon;       // Название иконки
  final String label;      // Название пункта
  final String section;    // Название раздела (группы)

  MenuItemModel({
    required this.icon,
    required this.label,
    required this.section,
  });

  /// Метод для создания объекта из JSON
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      icon: json['icon'] as String,
      label: json['label'] as String,
      section: json['section'] as String,
    );
  }
}

