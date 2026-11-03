const fs = require('fs');
const path = require('path');

const cities = [
['01','adana'],['02','adiyaman'],['03','afyonkarahisar'],['04','agri'],['05','amasya'],
['06','ankara'],['07','antalya'],['08','artvin'],['09','aydin'],['10','balikesir'],
['11','bilecik'],['12','bingol'],['13','bitlis'],['14','bolu'],['15','burdur'],
['16','bursa'],['17','canakkale'],['18','cankiri'],['19','corum'],['20','denizli'],
['21','diyarbakir'],['22','edirne'],['23','elazig'],['24','erzincan'],['25','erzurum'],
['26','eskisehir'],['27','gaziantep'],['28','giresun'],['29','gumushane'],['30','hakkari'],
['31','hatay'],['32','isparta'],['33','mersin'],['34','istanbul'],['35','izmir'],
['36','kars'],['37','kastamonu'],['38','kayseri'],['39','kirklareli'],['40','kirsehir'],
['41','kocaeli'],['42','konya'],['43','kutahya'],['44','malatya'],['46','kahramanmaras'],
['47','mardin'],['48','mugla'],['49','mus'],['50','nevsehir'],['51','nigde'],['52','ordu'],
['53','rize'],['54','sakarya'],['55','samsun'],['56','siirt'],['57','sinop'],['58','sivas'],
['59','tekirdag'],['60','tokat'],['61','trabzon'],['62','tunceli'],['63','sanliurfa'],['64','usak'],
['65','van'],['66','yozgat'],['67','zonguldak'],['68','aksaray'],['69','bayburt'],['70','karaman'],
['71','kirikkale'],['72','batman'],['73','sirnak'],['74','bartin'],['75','ardahan'],['76','igdir'],
['77','yalova'],['78','karabuk'],['79','kilis'],['80','osmaniye'],['81','duzce']
];

const targetDir = path.join(__dirname, 'data', 'seo-enrichment', 'cities');

if (!fs.existsSync(targetDir)) {
  fs.mkdirSync(targetDir, { recursive: true });
  console.log('Klasör oluşturuldu:', targetDir);
}

let created = 0;
cities.forEach(([code, slug]) => {
  const filePath = path.join(targetDir, `${code}-${slug}.ts`);
  if (!fs.existsSync(filePath)) {
    const content = `// PLACEHOLDER ${slug}
export const cityGeneric = { citySlug: '${slug}', cityName: '${slug}', note: 'Bu şehir için henüz teknik analiz eklenmedi.' };
export function getEnrichment() { return { city: cityGeneric, district: null, isFallback: true }; }
`;
    fs.writeFileSync(filePath, content, 'utf8');
    created++;
    console.log('Oluşturuldu:', filePath);
  }
});

console.log(`\nBİTTİ! ${created} dosya oluşturuldu.`);
console.log('Klasör:', targetDir);
