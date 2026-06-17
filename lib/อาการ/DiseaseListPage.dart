import 'package:flutter/material.dart';
import 'package:my_app/อาการ/DiseaseDetailPage.dart';

class DiseaseListPage extends StatelessWidget {
  DiseaseListPage({super.key});

  final List<Map<String, String>> diseases = [
    {"name": "PHQ-9", "title": "ภาวะซึมเศร้า"},
    {"name": "GAD-7", "title": "ภาวะวิตกกังวล"},
    {"name": "ASRS", "title": "ADHD"},
    {"name": "OCI-R", "title": "OCD (ย้ำคิดย้ำทำ)"},
    {"name": "MDQ", "title": "ไบโพลาร์"},
    {"name": "AQ / RAADS-R", "title": "ออทิสติก"},
    {"name": "PCL-5", "title": "PTSD"},
    {"name": "PSS", "title": "ความเครียด"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ข้อมูลสุขภาพจิต"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DiseaseDetailPage(
                      diseaseName: diseases[index]["name"]!,
                      diseaseTitle: diseases[index]["title"]!,
                    ),
                  ),
                );
              },
              child: Text(
                "${diseases[index]["name"]}\n${diseases[index]["title"]}",
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}