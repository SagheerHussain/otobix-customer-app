import 'package:get/get.dart';

class WarrantyController extends GetxController {
  // Benefits data
  final List<Map<String, dynamic>> benefits = [
    {'title': '24×7 Roadside Assistance Coverage.', 'icon': '🛡️'},
    {'title': 'Protection against costly mechanical repairs.', 'icon': '🔧'},
    {'title': 'Towing support for breakdowns and accidents.', 'icon': '🚚'},
    {'title': 'On-site battery jumpstart service.', 'icon': '🔋'},
    {'title': 'Flat tyre replacement and repair.', 'icon': '🚗'},
    {'title': 'Key lockout and key assistance.', 'icon': '🔑'},
    {'title': 'Fast response and quick service dispatch.', 'icon': '⚡'},
    {'title': 'Extended warranty beyond manufacturer cover.', 'icon': '📜'},
    {'title': 'Higher resale value and better buyer confidence.', 'icon': '💰'},
    {'title': 'Peace of mind and stress-free ownership.', 'icon': '😊'},
  ];

  // Inclusions data
  final List<Map<String, dynamic>> inclusions = [
    {'title': 'Engine and transmission mechanical failures.'},
    {'title': 'Drivetrain components such as axles and differentials.'},
    {
      'title':
          'Electrical systems including alternator, wiring, and power features.',
    },
    {'title': 'Air conditioning and heating system components.'},
    {'title': 'Fuel system components such as pumps and injectors.'},
    {'title': 'Key safety systems like airbags and seat belt mechanisms.'},
  ];
}
