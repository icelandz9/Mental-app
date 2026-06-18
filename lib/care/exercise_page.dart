import 'package:flutter/material.dart';
import 'care_page.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CarePage(
      title: "ออกกำลังกาย",
      subtitle:
          "การขยับร่างกายช่วยหลั่งสารแห่งความสุข\nลดเครียดและทำให้หลับดีขึ้น",
      icon: Icons.fitness_center,
      color: Color(0xFFF1976B),
      tips: [
        CareTip(
          icon: Icons.directions_run,
          title: "แอโรบิก 150 นาทีต่อสัปดาห์",
          detail:
              "เดินเร็ว วิ่ง ปั่นจักรยาน หรือว่ายน้ำ ช่วยให้หัวใจแข็งแรงและอารมณ์ดีขึ้น",
        ),
        CareTip(
          icon: Icons.directions_walk,
          title: "ขยับร่างกายทุกวัน",
          detail: "ลุกเดินบ่อยๆ ใช้บันไดแทนลิฟต์ การเคลื่อนไหวเล็กๆ ก็มีผลสะสม",
        ),
        CareTip(
          icon: Icons.self_improvement,
          title: "โยคะหรือยืดเหยียด",
          detail: "ช่วยคลายกล้ามเนื้อ ลดความตึงเครียด และทำให้ใจสงบ",
        ),
        CareTip(
          icon: Icons.groups,
          title: "ออกกำลังกายกับเพื่อน",
          detail: "การมีเพื่อนร่วมทำช่วยให้สนุกและทำได้ต่อเนื่องมากขึ้น",
        ),
        CareTip(
          icon: Icons.trending_up,
          title: "เริ่มทีละน้อย แล้วค่อยเพิ่ม",
          detail:
              "ไม่ต้องหักโหม ค่อยๆ เพิ่มความหนักเพื่อป้องกันบาดเจ็บและทำได้ยาว",
        ),
      ],
    );
  }
}
