export const metadata = { 
  title: 'Hemen Ustam Gelsin - En Yakın Usta', 
  description: '81 ilde 42 iş kolunda en yakın ustayı bul, Hemen Ustam Gelsin ile hemen teklif al',
  verification: {
    yandex: '1992acbf758234c0'
  }
}

export default function RootLayout({children}:{children:React.ReactNode}){
  return <html lang="tr"><body style={{margin:0, fontFamily:'system-ui', background:'#f8fafc'}}>{children}</body></html>
}