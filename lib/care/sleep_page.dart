import 'package:flutter/material.dart';
import 'care_page.dart';

class SleepPage extends StatelessWidget {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CarePage(
      title: "การนอนหลับ",
      subtitle: "การนอนที่ดีช่วยฟื้นฟูสมองและอารมณ์\nลองปรับพฤติกรรมเหล่านี้ดู",
      icon: Icons.bedtime,
      color: Color(0xFF5C6BC0),
      tips: [
        CareTip(
          icon: Icons.schedule,
          title: "เข้านอน–ตื่นเวลาเดิมทุกวัน",
          detail: "แม้วันหยุดก็ควรรักษาเวลาให้สม่ำเสมอ เพื่อปรับนาฬิกาชีวิตให้คงที่",
        ),
        CareTip(
          icon: Icons.phonelink_erase,
          title: "เลี่ยงจอมือถือก่อนนอน 1 ชั่วโมง",
          detail: "แสงสีฟ้าจากหน้าจอรบกวนการหลั่งเมลาโทนิน ทำให้หลับยากขึ้น",
        ),
        CareTip(
          icon: Icons.local_cafe,
          title: "งดคาเฟอีนช่วงบ่าย–เย็น",
          detail: "ชา กาแฟ น้ำอัดลม อาจทำให้หลับยาก ควรงดอย่างน้อย 6 ชั่วโมงก่อนนอน",
        ),
        CareTip(
          icon: Icons.dark_mode,
          title: "จัดห้องให้มืด เงียบ และเย็นสบาย",
          detail: "สภาพแวดล้อมที่เหมาะสมช่วยให้หลับลึกและตื่นมาสดชื่นขึ้น",
        ),
        CareTip(
          icon: Icons.self_improvement,
          title: "ผ่อนคลายก่อนนอน",
          detail: "อ่านหนังสือ ยืดเหยียดเบาๆ หรือหายใจลึกๆ ช่วยให้ร่างกายพร้อมพักผ่อน",
        ),
      ],
    );
  }
}
