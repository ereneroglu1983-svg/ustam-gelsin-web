class TextCleaner {
  static String clean(dynamic input) {
    if (input == null) return "";

    String text = input.toString();

    // 1. Unicode normalize (gizli karakterleri temizler)
    text = text
        .replaceAll('\u0307', '') // combining dot
        .replaceAll('\u0327', '') // cedilla vs
        .replaceAll('\u200B', '') // zero width space
        .replaceAll('\uFEFF', '') // BOM
        .trim();

    // 2. Türkçe bozuk i düzeltme (en çok bu sorun çıkar)
    text = text.replaceAll('i̇', 'i');

    // 3. lowercase güvenli
    return text.toLowerCase();
  }
}