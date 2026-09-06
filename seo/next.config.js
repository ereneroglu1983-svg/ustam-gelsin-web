/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: { unoptimized: true } // Cloudflare'de mecbur
}
module.exports = nextConfig