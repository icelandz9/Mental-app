import 'package:flutter/material.dart';
import 'package:my_app/อาการ/DiseaseDetailPage.dart';

class Aqpage extends StatelessWidget {
  const Aqpage({super.key});

  @override
  Widget build(BuildContext context) {
    return DiseaseDetailPage(
      diseaseName: "AQ / RAADS-R",
      diseaseTitle: "ออทิสติก",
    );
  }
}