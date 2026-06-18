import 'package:flutter/material.dart';
import 'care_page.dart';

class RelaxPage extends StatelessWidget {
  const RelaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CarePage(
      title: "ผ่อนคลาย",
      subtitle: "ให้เวลากับการพักใจในแต่ละวัน\nช่วยลดความเครียดสะสมได้มาก",
      icon: Icons.spa,
      color: Color(0xFFBA68C8),
      tips: [
        CareTip(
          icon: Icons.air,
          title: "ฝึกหายใจลึกๆ",
          detail: "หายใจเข้า 4 วินาที กลั้น 4 วินาที ปล่อยออก 6 วินาที ช่วยให้ใจสงบเร็ว",
        ),
        CareTip(
          icon: Icons.self_improvement,
          title: "ทำสมาธิหรือมินด์ฟูลเนส",
          detail: "อยู่กับปัจจุบันวันละ 5–10 นาที ช่วยลดความคิดฟุ้งซ่าน",
        ),
        CareTip(
          icon: Icons.headphones,
          title: "ฟังเพลงที่ชอบ",
          detail: "เสียงดนตรีที่ผ่อนคลายช่วยลดความตึงเครียดและปรับอารมณ์",
        ),
        CareTip(
          icon: Icons.phone_iphone,
          title: "พักจากโซเชียลบ้าง",
          detail: "ลดการเสพข่าวและหน้าจอ ช่วยให้สมองได้พักจากสิ่งกระตุ้น",
        ),
        CareTip(
          icon: Icons.palette,
          title: "ทำงานอดิเรกที่รัก",
          detail: "วาดรูป ปลูกต้นไม้ หรือทำอาหาร ช่วยเติมพลังใจให้กลับมาสดชื่น",
        ),
      ],
    );
  }
}
