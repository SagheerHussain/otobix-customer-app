import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_customer_app/views/new_and_used_cars_pdi_page.dart';

class PdiController extends GetxController {
  // ====== Service Categories (dummy data exactly like screenshot) ======
  // final RxInt selectedCategoryIndex = 0.obs;

  /// Each item is a simple Map (no models, as requested)
  final RxList<Map<String, dynamic>> serviceCategories = <Map<String, dynamic>>[
    {
      'title': 'New Car PDI',
      'imageAsset': '', // keep empty to use placeholder icon in UI
      'isSelected': true,
    },
    {
      'title': 'Used Car PDI',
      'imageAsset': '', // keep empty to use placeholder icon in UI
      'isSelected': false,
    },
  ].obs;

  // ====== What we cover (dummy list like screenshot) ======
  final RxList<Map<String, dynamic>> coverageItems = <Map<String, dynamic>>[
    {'title': 'Body Structure/ Chassis', 'icon': Icons.grid_view_rounded},
    {'title': 'Engine & Transmission', 'icon': Icons.settings_rounded},
    {'title': 'Mechanicals', 'icon': Icons.build_circle_rounded},
    {
      'title': 'Battery & Electricals',
      'icon': Icons.battery_charging_full_rounded,
    },
    {'title': 'Interiors & AC', 'icon': Icons.air_rounded},
    {'title': 'Steering & Suspension', 'icon': Icons.sync_alt_rounded},
    {'title': 'Brakes & Clutch', 'icon': Icons.speed_rounded},
    {'title': 'Wheels & Tyres', 'icon': Icons.tire_repair_rounded},
    {'title': 'Exterior Panels', 'icon': Icons.car_repair_rounded},
    {'title': 'Vehicle Documentation', 'icon': Icons.description_rounded},
  ].obs;

  // ====== How it Works (dummy data like screenshot) ======
  final RxList<Map<String, dynamic>> howItWorksSteps = <Map<String, dynamic>>[
    {
      'title': 'Book an Appointment',
      'desc':
          'Schedule via the OtoBix App or Website and complete payment securely.',
      'icon': Icons.support_agent_rounded,
    },
    {
      'title': 'Engineer Assigned',
      'desc':
          'A certified Inspection Engineer is assigned as per your chosen date.',
      'icon': Icons.engineering_rounded,
    },
    {
      'title': '360° Vehicle Inspection',
      'desc':
          'The vehicle is thoroughly inspected, including a 5 km test drive with the customer or representative present.',
      'icon': Icons.threesixty_rounded,
    },
    {
      'title': 'Verified Inspection Report',
      'desc': 'The report is quality-checked and shared via the app or email.',
      'icon': Icons.assignment_turned_in_rounded,
    },
  ].obs;

  // ====== FAQs (dummy data like screenshot) ======
  final RxList<Map<String, dynamic>> faqs = <Map<String, dynamic>>[
    {
      'question': 'What is a Pre-Delivery Inspection ?',
      'answer':
          'PDI (Pre-Delivery Inspection) is a complete professional inspection of a vehicle done before you take delivery, whether it’s a new or used car. The goal is to confirm that the car is safe, defect-free, and in the exact condition promised by the seller. During a PDI, experts check:\n\n'
          '• Engine, transmission, and mechanical health\n'
          '• Electrical systems, electronics, and sensors\n'
          '• Body condition, paint, and structural damage\n'
          '• Accident history, water damage, and hidden repairs\n'
          '• Odometer accuracy, tyres, brakes, and suspension\n'
          '• A short real-road test drive for performance verification\n\n'
          'A proper PDI protects you from unexpected repairs, safety risks, and financial loss, and ensures you get full value for your money.',
    },
    {
      'question': 'Why Pre-Delivery Inspection is Important ?',
      'answer':
          'OtoBix has inspected customer cars for over 3 years, and more than 70% of them had issues that a normal buyer would never notice. Our trained Inspection Engineers detect hidden repairs, cover-ups, and early signs of future problems that aren’t visible to the naked eye.\n\n'
          'Key Facts:\n'
          '• 18% had hidden engine repairs.\n'
          '• 25% showed accident damage; 15% had major structural issues.\n'
          '• 3% suffered water-damage and engine overhauls.',
    },
    {
      'question': 'Why a New Car Pre-Delivery Inspection is Important ?',
      'answer':
          'A New Car PDI ensures the car is defect-free, safe, and fully functional before delivery. It catches issues that may occur during transport or storage - like scratches, low battery, incorrect fluid levels, or non-working electronics, so you receive the car exactly as promised.',
    },
    {
      'question': 'Why Used Car Pre-Delivery Inspection is Important ?',
      'answer':
          'A Used Car PDI verifies the car’s true condition, checking for hidden mechanical issues, past damage, odometer tampering, and wear & tear. It protects you from costly repairs later and ensures the car is safe, reliable, and worth the price.',
    },
    {
      'question': 'How long does a Pre-Delivery Inspection take ?',
      'answer':
          'A standard PDI usually takes 60 to 90 minutes to complete.\n\n'
          '• Full mechanical and electrical checks\n'
          '• Exterior, interior, and underbody inspection\n'
          '• Diagnostic scan (if applicable)\n'
          '• A real-road test drive of about 5 km\n'
          '• Digital report preparation\n\n'
          'If the vehicle has complex issues or requires deeper diagnostics, it may take slightly longer.',
    },
  ].obs;

  // which FAQ is expanded
  final RxInt expandedFaqIndex = 0.obs;

  void toggleFaq(int index) {
    if (expandedFaqIndex.value == index) {
      expandedFaqIndex.value = -1;
    } else {
      expandedFaqIndex.value = index;
    }
  }

  // ====== Functions (and you will use them in UI) ======

  void selectCategory(int index) {
    // selectedCategoryIndex.value = index;

    // Update selection flags in the same list (no models)
    for (int i = 0; i < serviceCategories.length; i++) {
      serviceCategories[i]['isSelected'] = (i == index);
    }
    serviceCategories.refresh();
    Get.to(
      NewAndUsedCarsPdiPage(serviceCategory: serviceCategories[index]['title']),
    );

    // Get.snackbar('Category', serviceCategories[index]['title']);
  }

  @override
  void onClose() {
    // searchController.dispose();
    super.onClose();
  }
}
