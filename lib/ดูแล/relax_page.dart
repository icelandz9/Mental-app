import 'package:flutter/material.dart';

class RelaxPage extends StatelessWidget {
  const RelaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ผ่อนคลาย"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
             menuButton(
              context,
              "อาการ",
              "มีความแตกต่างด้านการสื่อสารและปฏิสัมพันธ์ทางสังคม สนใจเรื่องใดเรื่องหนึ่งมากเป็นพิเศษ มีพฤติกรรมซ้ำ ๆ",
            ),

            const SizedBox(height: 20),

            menuButton(
              context,
              "อาการ",
              "มีความแตกต่างด้านการสื่อสารและปฏิสัมพันธ์ทางสังคม สนใจเรื่องใดเรื่องหนึ่งมากเป็นพิเศษ มีพฤติกรรมซ้ำ ๆ",
            ),

            const SizedBox(height: 20),
            menuButton(
              context,
              "อาการ",
              "มีความแตกต่างด้านการสื่อสารและปฏิสัมพันธ์ทางสังคม สนใจเรื่องใดเรื่องหนึ่งมากเป็นพิเศษ มีพฤติกรรมซ้ำ ๆ",
            ),

            const SizedBox(height: 20),

            menuButton(
              context,
              "อาการ",
              "มีความแตกต่างด้านการสื่อสารและปฏิสัมพันธ์ทางสังคม สนใจเรื่องใดเรื่องหนึ่งมากเป็นพิเศษ มีพฤติกรรมซ้ำ ๆ",
            ),

            const SizedBox(height: 20),

            menuButton(
              context,
              "อาการ",
              "มีความแตกต่างด้านการสื่อสารและปฏิสัมพันธ์ทางสังคม สนใจเรื่องใดเรื่องหนึ่งมากเป็นพิเศษ มีพฤติกรรมซ้ำ ๆ",
            ),

            const SizedBox(height: 20),

            menuButton(
              context,
              "อาการ",
              "มีความแตกต่างด้านการสื่อสารและปฏิสัมพันธ์ทางสังคม สนใจเรื่องใดเรื่องหนึ่งมากเป็นพิเศษ มีพฤติกรรมซ้ำ ๆ",
            ),

            const SizedBox(height: 20),

            menuButton(
              context,
              "สาเหตุ",
              "เกี่ยวข้องกับพัฒนาการของระบบประสาทและปัจจัยทางพันธุกรรม",
            ),

            const SizedBox(height: 20),

            menuButton(
              context,
              "การรักษา",
              "ไม่มีการรักษาให้หายขาด แต่สามารถพัฒนาทักษะผ่านการบำบัดและการสนับสนุนที่เหมาะสม",
            ),
          ],
        ),
      ),
    );
  }

  Widget menuButton(
    BuildContext context,
    String title,
    String content,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(content),
            ),
          );
        },
        child: Text(title),
      ),
    );
  }
}