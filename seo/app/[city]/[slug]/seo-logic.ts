// app/[city]/[slug]/seo-logic.ts - FIXED v16.1 Uyumlu
// Override + Auto + Intro + FAQ - Ana kod mantığı

import { cities } from '../../../data/cities';
import { jobs } from '../../../data/jobs';
import { districtSEODataOverride } from './district-overrides';
import { introVariants } from './intro-variants';
import { faqTemplates, faqTopicMap } from './faq-templates';
import { loc, hashString, pickDeterministic } from './helpers';

export type DistrictSEOData = {
  serviceFocus: string[];
  localIntro: string;
  demandNote: string;
  faqTopics: string[];
  nearbyPriority: string[];
};

const safeLocalIntroTemplates: Array<(dName: string, cName: string, dLoc: string) => string> = [
 (d,c,dL) => `${d}, ${c} ili sınırları içinde konut ve iş yeri için ilan oluşturabileceğin ilçelerden biridir ve aktif olarak hizmet vermektedir.`,
 (d,c,dL) => `${d} ilçesi ${c} içinde yer alan ve Hemen Ustam Gelsin üzerinden ilan verilebilen bölgelerden biri olarak öne çıkmaktadır.`,
 (d,c,dL) => `${c} içinde ${d} ilçesi için Hemen Ustam Gelsin üzerinden ilan oluşturarak doğrudan usta teklifi alabilirsin ve süreci başlatabilirsin.`,
 (d,c,dL) => `${d} ${c} içinde ilan oluşturulabilen ilçelerden biri olup ${dL} tadilat ve yenileme işleri için hızlıca hizmet alabilirsin ve teklif toplayabilirsin.`,
 (d,c,dL) => `${d} ilçesi ${c} genelinde Hemen Ustam Gelsin üzerinden aktif olarak ilan açılabilen ve teklif alınabilen bölgelerden biridir.`
];

const safeDemandNoteTemplates: Array<(dName: string, cName: string, dLoc: string) => string> = [
 (d,c,dL) => `${d} için oluşturulan ilanlar ilgili hizmet kategorisindeki uygun ustalara iletilir.`,
 (d,c,dL) => `${d} ilçesinde ilan verdiğinde ustalar tekliflerini iletir.`,
 (d,c,dL) => `${d} için yayınladığın ilan ${c} içindeki ilgili ustalara yönlendirilir.`,
 (d,c,dL) => `${d} ilçesi için açtığın ilan ilgili hizmet kategorisindeki ustalara iletilir.`,
 (d,c,dL) => `${d} için ilan oluşturduktan sonra teklifleri karşılaştırarak ustanı seçebilirsin.`
];

const allFaqTopics = ['usta-fiyatlari','komisyon','ilan-verme','teklif-alma','hizmetler','dis-usta','kesif','ilan-suresi','hugai'];

function getAutoServiceFocus(citySlug: string, districtSlug: string): string[] {
  return pickDeterministic(jobs, `${citySlug}/${districtSlug}/services`, 10).map(j => j.slug);
}
function getAutoLocalIntro(citySlug: string, districtSlug: string, dName: string, cName: string, dLoc: string): string {
  const tmpl = pickDeterministic(safeLocalIntroTemplates, `${citySlug}/${districtSlug}/localIntro`, 1)[0];
  return tmpl(dName, cName, dLoc);
}
function getAutoDemandNote(citySlug: string, districtSlug: string, dName: string, cName: string, dLoc: string): string {
  const tmpl = pickDeterministic(safeDemandNoteTemplates, `${citySlug}/${districtSlug}/demandNote`, 1)[0];
  return tmpl(dName, cName, dLoc);
}
function getAutoFaqTopics(citySlug: string, districtSlug: string): string[] {
  return pickDeterministic(allFaqTopics, `${citySlug}/${districtSlug}/faq`, 4);
}
function getAutoDistrictPriority(city: typeof cities[0], districtSlug: string): string[] {
  return city.districts.filter(d => d.slug !== districtSlug).map(d => d.slug);
}

export function getDistrictSEOData(city: typeof cities[0], district: { slug: string; name: string }): DistrictSEOData {
  const key = `${city.slug}/${district.slug}`;
  const override = (districtSEODataOverride as any)[key] || {};
  const dLoc = loc(district.name);

  return {
    serviceFocus: override.serviceFocus ?? getAutoServiceFocus(city.slug, district.slug),
    localIntro: override.localIntro ?? getAutoLocalIntro(city.slug, district.slug, district.name, city.name, dLoc),
    demandNote: override.demandNote ?? getAutoDemandNote(city.slug, district.slug, district.name, city.name, dLoc),
    faqTopics: override.faqTopics ?? getAutoFaqTopics(city.slug, district.slug),
    nearbyPriority: override.nearbyPriority ?? getAutoDistrictPriority(city, district.slug),
  };
}

export function buildDistrictIntro(dName: string, cName: string, dLoc: string, city: typeof cities[0], district: { slug: string; name: string }): string {
  const seoData = getDistrictSEOData(city, district);
  const introIdx = hashString(`${city.slug}/${district.slug}`) % introVariants.length;
  return `${seoData.localIntro} ${introVariants[introIdx](dName, cName, dLoc)}`;
}

export function getDistrictServiceLinks(city: typeof cities[0], district: { slug: string; name: string }) {
  return getDistrictSEOData(city, district).serviceFocus.map(slug => jobs.find(j => j.slug === slug)).filter(Boolean) as typeof jobs;
}

export function getSiblingDistricts(city: typeof cities[0], district: { slug: string; name: string }) {
  return city.districts.filter(d => d.slug !== district.slug) as typeof city.districts;
}

export function getDistrictFAQs(city: typeof cities[0], district: { slug: string; name: string }, dName: string, cName: string, dLoc: string) {
  const seoData = getDistrictSEOData(city, district);
  let pool = faqTemplates as any[];
  const wantedTopics = new Set(seoData.faqTopics);
  const filteredIndices: number[] = [];
  for (const topic of wantedTopics) {
    for (const idx of ((faqTopicMap as any)[topic] || [])) {
      if (!filteredIndices.includes(idx)) filteredIndices.push(idx);
    }
  }
  if (filteredIndices.length >= 3) pool = filteredIndices.map(i => (faqTemplates as any)[i]).filter(Boolean);
  return pickDeterministic(pool, `${city.slug}/${district.slug}`, 4).map((t: any) => ({ q: t.q(dName), a: t.a(dName, cName, dLoc) }));
}

export function getDistrictActionNote(city: typeof cities[0], district: { slug: string; name: string }) {
  return getDistrictSEOData(city, district).demandNote;
}