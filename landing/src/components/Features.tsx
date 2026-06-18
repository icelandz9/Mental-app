import {
  LineChart,
  ClipboardCheck,
  NotebookPen,
  ShieldCheck,
} from 'lucide-react'
import type { LucideIcon } from 'lucide-react'

type Feature = {
  icon: LucideIcon
  title: string
  desc: string
}

const features: Feature[] = [
  {
    icon: LineChart,
    title: 'ติดตามอารมณ์',
    desc: 'บันทึกความรู้สึกในแต่ละวัน แล้วมองเห็นแนวโน้มอารมณ์ของคุณอย่างนุ่มนวล',
  },
  {
    icon: ClipboardCheck,
    title: 'แบบประเมินตนเอง',
    desc: 'เครื่องมือคัดกรองที่ผ่านการตรวจสอบ เช่น PHQ-9 เพื่อทำความเข้าใจตัวเอง',
  },
  {
    icon: NotebookPen,
    title: 'การทบทวนแบบมีคำแนะนำ',
    desc: 'คำถามชวนสะท้อนใจอย่างอ่อนโยน ช่วยให้คุณเข้าใจความรู้สึกได้ลึกขึ้น',
  },
  {
    icon: ShieldCheck,
    title: 'เป็นส่วนตัวและปลอดภัย',
    desc: 'ข้อมูลของคุณเป็นความลับเสมอ พื้นที่ปลอดภัยที่ไม่มีการตัดสิน',
  },
]

export default function Features() {
  return (
    <section id="features" className="relative z-10 mx-auto -mt-12 max-w-7xl px-6 lg:-mt-16">
      <div className="rounded-3xl border border-earth/50 bg-cream-card p-8 shadow-lg shadow-sage/5">
        <div className="grid grid-cols-1 gap-8 md:grid-cols-2 lg:grid-cols-4">
          {features.map(({ icon: Icon, title, desc }) => (
            <div key={title} className="group flex flex-col items-start text-left">
              <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-beige transition-transform duration-300 group-hover:scale-110">
                <Icon size={26} className="text-sage" strokeWidth={1.75} />
              </div>
              <h4 className="mt-5 text-xl font-bold text-ink transition-colors duration-300 group-hover:text-sage">
                {title}
              </h4>
              <p className="mt-2 text-sm leading-relaxed text-muted">{desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}