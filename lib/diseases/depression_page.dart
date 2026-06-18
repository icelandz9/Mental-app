import 'package:flutter/material.dart';
import 'package:my_app/symptoms/disease_detail_page.dart';

class DepressionPage extends StatelessWidget {
  const DepressionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiseaseDetailPage(
      diseaseName: "PHQ-9",
      diseaseTitle: "ซึมเศร้า",
    );
  }
}