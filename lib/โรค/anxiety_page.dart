import 'package:flutter/material.dart';
import 'package:my_app/อาการ/DiseaseDetailPage.dart';

class AnxietyPage extends StatelessWidget {
  const AnxietyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiseaseDetailPage(
      diseaseName: "GAD-7",
      diseaseTitle: "วิตกกังวล",
    );
  }
}