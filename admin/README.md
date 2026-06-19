# MindCare Admin Dashboard

เว็บแดชบอร์ดสำหรับ **ผู้ดูแล (แอดมิน)** ดูผลการประเมินของผู้ใช้ทุกคน
เป็นเว็บแยกจากแอปหลัก — ไฟล์ HTML เดียว ไม่ต้อง build

## ⚙️ ตั้งค่าก่อนใช้ (สำคัญ 3 ขั้นตอน)

### 1. สร้างบัญชีแอดมิน
Firebase Console → **Authentication** → **Users** → **Add user**
ใส่อีเมล + รหัสผ่านที่จะใช้เป็นแอดมิน (เช่น `admin@mindcare.com`)

### 2. ตั้ง Firestore Rules (กันข้อมูลรั่ว)
แก้ไฟล์ [`../firestore.rules`](../firestore.rules) → เปลี่ยนอีเมลในบรรทัด `isAdmin()` ให้ตรงกับข้อ 1
จากนั้นเอาไปวางที่ Firebase Console → **Firestore Database** → **Rules** → **Publish**

> ⚠️ ถ้าไม่ตั้ง rules นี้ ข้อมูลสุขภาพจิตของผู้ใช้จะเปิดให้ใครก็อ่านได้

### 3. Deploy เว็บแอดมิน (เลือก 1 วิธี)

**วิธี A — ลากวาง (ง่ายสุด):**
[app.netlify.com](https://app.netlify.com) → Add new site → Deploy manually → ลากโฟลเดอร์ `admin/` ไปวาง

**วิธี B — ผูก GitHub (auto deploy):**
สร้าง Netlify site ใหม่ → เลือก repo เดิม → ตั้ง **Base directory = `admin`** → Deploy

## วิธีใช้
เปิดเว็บแอดมิน → ล็อกอินด้วยบัญชีแอดมิน (ข้อ 1) → เห็นผลผู้ใช้ทุกคน
- ค้นหาด้วยชื่อ/เบอร์โทร
- กดการ์ดเพื่อดูประวัติการประเมินทั้งหมด
- ปุ่ม "ส่งออก CSV" ดาวน์โหลดข้อมูลทั้งหมด

## หมายเหตุ
- ค่า `firebaseConfig` ใน `index.html` เป็น public config ปกติ (ความปลอดภัยอยู่ที่ Firestore Rules ไม่ใช่การซ่อน key)
- เว็บนี้ดูข้อมูลได้อย่างเดียว แก้/ลบไม่ได้
