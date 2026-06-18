import 'package:flutter/material.dart';
import 'care_page.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CarePage(
      title: "อาหาร",
      subtitle: "สิ่งที่เรากินส่งผลต่ออารมณ์และพลังงาน\nเลือกกินให้ดีเพื่อใจที่ดีขึ้น",
      icon: Icons.restaurant,
      color: Color(0xFF4FB7A0),
      tips: [
        CareTip(
          icon: Icons.eco,
          title: "กินให้ครบ 5 หมู่",
          detail: "เน้นผัก ผลไม้ ธัญพืชไม่ขัดสี และโปรตีนดี เพื่อสารอาหารที่สมองต้องการ",
        ),
        CareTip(
          icon: Icons.set_meal,
          title: "เพิ่มโอเมก้า-3",
          detail: "ปลาทะเล ถั่ว และเมล็ดพืช ช่วยบำรุงสมองและลดความเครียด",
        ),
        CareTip(
          icon: Icons.no_food,
          title: "ลดน้ำตาลและของทอด",
          detail: "อาหารหวานจัดหรือมันจัดทำให้พลังงานแกว่งและอารมณ์ไม่คงที่",
        ),
        CareTip(
          icon: Icons.local_drink,
          title: "ดื่มน้ำให้เพียงพอ",
          detail: "ภาวะขาดน้ำเล็กน้อยก็ทำให้เหนื่อยล้าและสมาธิลดลงได้",
        ),
        CareTip(
          icon: Icons.access_time,
          title: "กินเป็นเวลา ไม่อดมื้อ",
          detail: "มื้ออาหารสม่ำเสมอช่วยรักษาระดับน้ำตาลและอารมณ์ให้คงที่",
        ),
      ],
    );
  }
}
