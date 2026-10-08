import { redirect } from 'next/navigation';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Hemen Ustam Gelsin Uygulamasını İndir - HUG',
  description: 'HUG mobil uygulamasını indir, 81 ilde ustaları cebinden çağır.',
};

export default function IndirPage() {
  redirect('https://play.google.com/store/apps/details?id=com.hemenustamgelsin.android');
}