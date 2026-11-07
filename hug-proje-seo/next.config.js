/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  basePath: '/hug-proje',
  trailingSlash: true,
  images: { unoptimized: true },
  outputFileTracingRoot: __dirname,
}

module.exports = nextConfig