// app/[city]/[slug]/helpers.ts - FIXED v16.1 Uyumlu
// Ana koddaki orijinal yardımcı fonksiyonlar

export function getLastVowel(word: string): string | null {
  for (let i = word.length - 1; i >= 0; i--) {
    const ch = word[i].toLowerCase();
    if (['a', 'e', 'ı', 'i', 'o', 'ö', 'u', 'ü'].includes(ch)) return ch;
  }
  return null;
}

const hardConsonants = new Set(['f', 's', 't', 'k', 'ç', 'ş', 'h', 'p', 'F', 'S', 'T', 'K', 'Ç', 'Ş', 'H', 'P']);
export function endsWithHardConsonant(word: string): boolean {
  return word ? hardConsonants.has(word[word.length - 1]) : false;
}

export function getLocativeSuffix(word: string): string {
  const lastVowel = getLastVowel(word);
  const isHard = endsWithHardConsonant(word);
  if (!lastVowel) return isHard ? "'te" : "'de";
  const isFront = ['e', 'i', 'ö', 'ü'].includes(lastVowel);
  return isFront ? (isHard ? "'te" : "'de") : (isHard ? "'ta" : "'da");
}

// ANA FONKSİYON - BU KESİNLİKLE lowercase DEĞİL
export const loc = (name: string) => `${name}${getLocativeSuffix(name)}`;

export function countWords(text: string): number {
  return text.trim().split(/\s+/).filter(Boolean).length;
}

export function hashString(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = ((hash << 5) - hash) + str.charCodeAt(i);
    hash |= 0;
  }
  return Math.abs(hash);
}

export function pickDeterministic<T>(arr: T[], seed: string, count: number): T[] {
  if (arr.length <= count) return [...arr];
  const start = hashString(seed) % arr.length;
  const result: T[] = [];
  for (let i = 0; i < count; i++) {
    result.push(arr[(start + i) % arr.length]);
  }
  return result;
}