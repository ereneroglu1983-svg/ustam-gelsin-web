const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const { VertexAI } = require("@google-cloud/vertexai");

// REVİZE: Timeout süresini 300 saniyeye (5 dk) çıkardık ve belleği 512MiB'a yükselttik.
setGlobalOptions({
  region: "europe-west3",
  timeoutSeconds: 300,
  memory: "512MiB"
});

const PROJECT_ID = "device-streaming-6f29b03c";
const LOCATION = "europe-west3";

const vertexAI = new VertexAI({
  project: PROJECT_ID,
  location: LOCATION,
});

// REVİZE: Model ismini stabil olması için 'gemini-1.5-flash' ile güncelledik.
const model = vertexAI.getGenerativeModel({
  model: "gemini-1.5-flash",
});

exports.hesaplaFiyat = onCall(async (request) => {
  const prompt = request.data.prompt;

  if (!prompt) {
    throw new HttpsError("invalid-argument", "Prompt boş olamaz.");
  }

  try {
    const result = await model.generateContent(prompt);
    const response = result.response;

    // Güvenlik: Yanıtın boş gelme ihtimaline karşı kontrol
    if (!response || !response.candidates || response.candidates.length === 0) {
      throw new Error("AI yanıt döndürmedi.");
    }

    const text = response.candidates[0].content.parts[0].text;
    return { fiyat: text.trim() };
  } catch (error) {
    console.error("Vertex AI Hata Detayı:", error);
    // Hata detayını cliente gönderiyoruz ki Flutter tarafında daha iyi yakalayalım
    throw new HttpsError("internal", "Fiyat hesaplanamadı: " + error.message);
  }
});