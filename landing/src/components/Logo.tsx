// โลโก้แบรนด์ MINDLY — ใบมน 3 ชิ้นจัดเป็นรูปทรงดอกไม้บานอ่อนโยน
export default function Logo({ className = '' }: { className?: string }) {
  return (
    <span
      className={`relative inline-flex h-9 w-9 items-center justify-center rounded-2xl bg-sage shadow-sm shadow-sage/30 ${className}`}
      aria-hidden="true"
    >
      <svg
        viewBox="0 0 24 24"
        className="h-5 w-5 text-white"
        fill="currentColor"
      >
        {/* กลีบบน */}
        <path d="M12 2c1.8 1.5 2.7 3.4 2.7 5.4 0 1.6-.9 2.9-2.7 4-1.8-1.1-2.7-2.4-2.7-4C9.3 5.4 10.2 3.5 12 2z" />
        {/* กลีบซ้ายล่าง */}
        <path
          opacity="0.85"
          d="M4.3 8.7c2.1.3 3.7 1.3 4.7 3 .8 1.4.8 2.9 0 4.8-2-.5-3.5-1.4-4.4-3-.9-1.6-1-3.2-.3-4.8z"
        />
        {/* กลีบขวาล่าง */}
        <path
          opacity="0.85"
          d="M19.7 8.7c.7 1.6.6 3.2-.3 4.8-.9 1.6-2.4 2.5-4.4 3-.8-1.9-.8-3.4 0-4.8 1-1.7 2.6-2.7 4.7-3z"
        />
      </svg>
    </span>
  )
}