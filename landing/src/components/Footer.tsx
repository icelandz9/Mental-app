import { Globe, MessageCircle, Camera } from 'lucide-react'
import Logo from './Logo'

const columns = [
  {
    title: 'บริษัท',
    links: ['เกี่ยวกับเรา', 'ทีมงาน', 'ร่วมงานกับเรา', 'บล็อก'],
  },
  {
    title: 'แหล่งข้อมูล',
    links: ['แหล่งข้อมูลสุขภาพจิต', 'สายด่วนวิกฤต', 'คำถามที่พบบ่อย', 'คู่มือการใช้งาน'],
  },
]

const socials = [
  { icon: Globe, label: 'เว็บไซต์' },
  { icon: MessageCircle, label: 'แชต' },
  { icon: Camera, label: 'ภาพถ่าย' },
]

export default function Footer() {
  return (
    <footer className="bg-beige">
      <div className="mx-auto max-w-7xl px-6 py-16">
        <div className="grid grid-cols-1 gap-12 md:grid-cols-2 lg:grid-cols-4">
          {/* แบรนด์ / พันธกิจ */}
          <div className="lg:col-span-1">
            <a href="#home" className="flex items-center gap-3">
              <Logo />
              <span className="text-xl font-bold tracking-tight text-ink">
                MINDLY
              </span>
            </a>
            <p className="mt-5 max-w-xs text-sm leading-relaxed text-muted">
              เพื่อนคู่ใจที่อยู่เคียงข้างคุณในทุกก้าวเล็ก ๆ
              ของการดูแลหัวใจอย่างอ่อนโยน
            </p>
            <div className="mt-6 flex gap-3">
              {socials.map(({ icon: Icon, label }) => (
                <a
                  key={label}
                  href="#"
                  aria-label={label}
                  className="flex h-10 w-10 items-center justify-center rounded-full border border-earth/60 text-muted transition-all duration-300 hover:border-sage/50 hover:bg-sage/10 hover:text-sage"
                >
                  <Icon size={18} strokeWidth={1.75} />
                </a>
              ))}
            </div>
          </div>

          {/* คอลัมน์ลิงก์ */}
          {columns.map((col) => (
            <div key={col.title}>
              <h4 className="text-sm font-bold uppercase tracking-wide text-ink">
                {col.title}
              </h4>
              <ul className="mt-5 space-y-3">
                {col.links.map((link) => (
                  <li key={link}>
                    <a
                      href="#"
                      className="text-sm text-muted transition-colors hover:text-sage"
                    >
                      {link}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}

          {/* จดหมายข่าว */}
          <div>
            <h4 className="text-sm font-bold uppercase tracking-wide text-ink">
              จดหมายข่าว
            </h4>
            <p className="mt-5 text-sm leading-relaxed text-muted">
              เคล็ดลับอ่อนโยนเพื่อสุขภาวะของคุณ — ไม่มีสแปม ตลอดไป
            </p>
            <form
              className="mt-5 flex flex-col gap-3 sm:flex-row"
              onSubmit={(e) => e.preventDefault()}
            >
              <input
                type="email"
                placeholder="อีเมลของคุณ"
                aria-label="อีเมลสำหรับรับจดหมายข่าว"
                className="w-full rounded-full border border-earth bg-cream-card px-4 py-2.5 text-sm text-ink outline-none transition-colors placeholder:text-muted/60 focus:border-sage focus:ring-1 focus:ring-sage"
              />
              <button
                type="submit"
                className="shrink-0 rounded-full bg-sage px-6 py-2.5 text-sm font-semibold text-white transition-all duration-300 hover:scale-[1.03] hover:bg-sage-dark"
              >
                สมัครรับ
              </button>
            </form>
          </div>
        </div>

        {/* แถบล่าง */}
        <div className="mt-14 border-t border-earth/50 pt-8">
          <div className="flex flex-col items-center justify-between gap-4 sm:flex-row">
            <p className="text-sm text-muted">
              © {new Date().getFullYear()} MINDLY · สร้างด้วยความใส่ใจ
            </p>
            <div className="flex gap-6 text-sm text-muted">
              <a href="#" className="transition-colors hover:text-sage">
                ความเป็นส่วนตัว
              </a>
              <a href="#" className="transition-colors hover:text-sage">
                เงื่อนไขการใช้งาน
              </a>
            </div>
          </div>
          <p className="mt-6 text-center text-xs leading-relaxed text-muted/80 sm:text-left">
            หมายเหตุ: MINDLY ให้บริการเครื่องมือช่วยเหลือตนเองเชิงสนับสนุน
            และไม่ใช่บริการทางการแพทย์ การวินิจฉัย หรือบริการฉุกเฉิน
            หากคุณอยู่ในภาวะวิกฤต กรุณาติดต่อสายด่วนช่วยเหลือในพื้นที่ของคุณทันที
          </p>
        </div>
      </div>
    </footer>
  )
}