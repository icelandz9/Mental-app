import { ArrowRight } from 'lucide-react'

export default function Hero() {
  return (
    <section id="home" className="relative overflow-hidden">
      {/* แสงเรืองนุ่มด้านหลัง */}
      <div
        aria-hidden="true"
        className="pointer-events-none absolute -left-24 top-10 h-[460px] w-[460px] rounded-full bg-sage/15 blur-[120px]"
      />
      <div
        aria-hidden="true"
        className="pointer-events-none absolute -right-16 top-40 h-[420px] w-[420px] rounded-full bg-peach/15 blur-[120px]"
      />

      <div className="relative mx-auto max-w-7xl px-6 pb-20 pt-32 lg:pb-32 lg:pt-48">
        <div className="grid items-center gap-16 lg:grid-cols-2">
          {/* คอลัมน์ซ้าย: เนื้อหา */}
          <div className="text-center lg:text-left">
            <p className="text-sm font-semibold uppercase tracking-[0.15em] text-sage">
              เพื่อนคู่ใจดูแลสุขภาพจิตของคุณ
            </p>
            <h1 className="mt-5 text-5xl font-bold leading-[1.1] tracking-tight text-ink lg:text-7xl">
              ก้าวเล็ก ๆ อย่างอ่อนโยน
              <br />
              <span className="text-sage">สู่ความรู้สึกที่ดีขึ้น</span>
            </h1>
            <p className="mx-auto mt-6 max-w-xl text-lg leading-relaxed text-muted lg:mx-0">
              สำรวจอารมณ์ของตัวเองในแต่ละวันอย่างเป็นส่วนตัวและไม่ตัดสิน
              ค่อย ๆ ทำความเข้าใจหัวใจของคุณทีละน้อย ในจังหวะที่คุณสบายใจ
              เราอยู่ตรงนี้เคียงข้างคุณเสมอ
            </p>

            <div className="mt-9 flex flex-col items-center gap-4 sm:flex-row lg:items-start lg:justify-start">
              <a
                href="#features"
                className="group inline-flex w-full items-center justify-center gap-2 rounded-full bg-sage px-7 py-3.5 font-semibold text-white shadow-lg shadow-sage/20 transition-all duration-300 hover:scale-[1.03] hover:bg-sage-dark sm:w-auto"
              >
                เริ่มเช็คอินของคุณ
                <ArrowRight
                  size={18}
                  className="transition-transform duration-300 group-hover:translate-x-1"
                />
              </a>
              <a
                href="#how-it-works"
                className="inline-flex w-full items-center justify-center gap-2 rounded-full border border-sage/60 px-7 py-3.5 font-semibold text-sage transition-all duration-300 hover:scale-[1.03] hover:bg-sage/5 sm:w-auto"
              >
                วิธีใช้งาน
              </a>
            </div>

            <p className="mt-6 text-sm text-muted/90">
              ฟรีตลอด · ไม่ต้องใช้บัตรเครดิต · ข้อมูลของคุณเป็นความลับ
            </p>
          </div>

          {/* คอลัมน์ขวา: วงกลมหายใจ */}
          <div className="flex justify-center lg:justify-end">
            <div className="relative aspect-square w-full max-w-[480px]">
              {/* วงแหวนซ้อน */}
              <div className="absolute inset-0 animate-breathe-slow rounded-full bg-sage/10" />
              <div className="absolute inset-[10%] animate-breathe rounded-full bg-peach/15" />
              <div className="absolute inset-[22%] rounded-full border border-earth/40" />

              {/* แกนกลางหายใจ */}
              <div className="absolute inset-[30%] flex items-center justify-center">
                <div className="flex h-full w-full animate-breathe items-center justify-center rounded-full bg-gradient-to-br from-sage to-sage-dark shadow-2xl shadow-sage/25">
                  <div className="text-center text-white">
                    <p className="text-sm font-medium tracking-[0.2em]">
                      BREATHE
                    </p>
                    <p className="mt-1 text-xs text-white/80">หายใจเข้า…ออก</p>
                  </div>
                </div>
              </div>

              {/* ก้อนลอยนุ่ม ๆ */}
              <div className="absolute right-2 top-6 h-16 w-16 animate-float rounded-full bg-peach/40 blur-sm" />
              <div className="absolute bottom-8 left-0 h-12 w-12 animate-float-slow rounded-full bg-sage/30 blur-sm" />
              <div className="absolute bottom-16 right-8 h-8 w-8 animate-float-x rounded-full bg-earth/50 blur-[2px]" />
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}