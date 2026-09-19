export async function onRequestPost(context) {
  const { request, env } = context;
  try {
    const body = await request.json().catch(() => ({}));
    const { slug, type } = body;
    const secret = request.headers.get('x-secret-key');
    if (!env.REVALIDATE_SECRET || secret !== env.REVALIDATE_SECRET) {
      return new Response(JSON.stringify({ error: 'Yetkisiz!' }), { status: 401, headers: { 'Content-Type': 'application/json' } });
    }
    return new Response(JSON.stringify({ revalidated: true, now: Date.now(), slug, message: 'Cache temizlendi' }), { headers: { 'Content-Type': 'application/json' } });
  } catch (e) {
    return new Response(JSON.stringify({ error: e.message }), { status: 500, headers: { 'Content-Type': 'application/json' } });
  }
}
export async function onRequestGet(context) {
  return new Response(JSON.stringify({ ok: true }), { headers: { 'Content-Type': 'application/json' } });
}