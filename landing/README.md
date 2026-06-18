# MINDLY — Landing Page

Landing Page สำหรับแอปดูแลสุขภาพจิต **MINDLY** — สร้างด้วย React + Vite + Tailwind CSS
ธีม **Sage & Cream** ที่ให้ความรู้สึกสงบ อบอุ่น ไม่ตัดสิน และน่าไว้วางใจ

## เริ่มใช้งาน

```bash
cd landing
npm install      # ติดตั้ง dependencies
npm run dev      # รัน dev server (http://localhost:5173)
npm run build    # build สำหรับ production
npm run preview  # ดูตัวอย่างไฟล์ที่ build แล้ว
```

## โครงสร้างคอมโพเนนต์

```
src/
├─ App.tsx
├─ main.tsx
├─ index.css            # Tailwind + ธีม + prefers-reduced-motion
└─ components/
   ├─ Navbar.tsx        # แถบนำทาง + เมนูมือถือ
   ├─ Hero.tsx          # วงกลมหายใจ + แสงเรืองนุ่ม
   ├─ Features.tsx      # 4 ฟีเจอร์หลัก (ซ้อนเหลื่อม Hero)
   ├─ About.tsx         # เกี่ยวกับเรา + เกรเดียนต์หมุน
   ├─ HowItWorks.tsx    # 6 การ์ดวิธีใช้งาน
   ├─ Pricing.tsx       # 3 แพ็กเกจ (Plus = เป็นที่รักที่สุด)
   ├─ Contact.tsx       # ฟอร์ม + ข้อความสนับสนุนกรณีวิกฤต
   ├─ Footer.tsx        # 4 คอลัมน์ + จดหมายข่าว + disclaimer
   └─ Logo.tsx          # โลโก้ใบมน 3 กลีบ
```

## ระบบดีไซน์ (Tailwind `tailwind.config.js`)

| โทเคน | ค่า | การใช้งาน |
|-------|-----|----------|
| `cream` | `#F5F1EA` | พื้นหลังหลัก |
| `cream-card` | `#FAF8F5` | พื้นการ์ด |
| `beige` | `#EFE9E0` | พื้นรอง / กรอบไอคอน |
| `earth` | `#D4C5B0` | เส้นขอบ |
| `sage` / `sage-dark` | `#7A9B8E` / `#688577` | สีเน้นหลัก / hover |
| `peach` | `#E8B89B` | สีเน้นรอง (อบอุ่น) |
| `ink` / `muted` | `#3D3A35` / `#6B6660` | ข้อความหลัก / รอง |

- ฟอนต์: **Inter** + Noto Sans Thai
- แอนิเมชัน: `breathe`, `float` (ช้า นุ่ม) — ปิดเองเมื่อผู้ใช้ตั้ง `prefers-reduced-motion`
- Responsive 100%: มือถือ → แท็บเล็ต → เดสก์ท็อป