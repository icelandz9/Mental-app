/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        // ===== ธีม Sage & Cream =====
        cream: '#F5F1EA', // พื้นหลังหลัก (ครีมอุ่น)
        'cream-card': '#FAF8F5', // พื้นหลังการ์ด (ขาวนวลอ่อน)
        beige: '#EFE9E0', // เบจอ่อน
        earth: '#D4C5B0', // ดินอ่อน / เส้นขอบ
        sage: '#7A9B8E', // สีเน้นหลัก (เขียวเสจ)
        'sage-dark': '#688577', // เสจเข้ม (hover)
        peach: '#E8B89B', // สีเน้นรอง (พีชหม่น)
        ink: '#3D3A35', // ข้อความหลัก
        muted: '#6B6660', // ข้อความรอง
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      keyframes: {
        breathe: {
          '0%, 100%': { transform: 'scale(1)', opacity: '0.65' },
          '50%': { transform: 'scale(1.12)', opacity: '1' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-18px)' },
        },
        'float-x': {
          '0%, 100%': { transform: 'translateX(0)' },
          '50%': { transform: 'translateX(14px)' },
        },
      },
      animation: {
        breathe: 'breathe 7s ease-in-out infinite',
        'breathe-slow': 'breathe 10s ease-in-out infinite',
        float: 'float 9s ease-in-out infinite',
        'float-slow': 'float 13s ease-in-out infinite',
        'float-x': 'float-x 12s ease-in-out infinite',
      },
    },
  },
  plugins: [],
}