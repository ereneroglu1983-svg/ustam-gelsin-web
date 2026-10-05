import Link from "next/link";

type Crumb = {
  name: string;
  href: string; // sonunda / olacak, örn: /adana/
};

export default function Breadcrumb({ items }: { items: Crumb[] }) {
  return (
    <nav aria-label="breadcrumb" className="text-sm text-gray-600 mb-6">
      <ol className="flex flex-wrap items-center gap-1">
        <li>
          <Link href="/" className="hover:text-black hover:underline">Ana Sayfa</Link>
          <span className="mx-2">/</span>
        </li>
        {items.map((item, i) => {
          const isLast = i === items.length - 1;
          return (
            <li key={item.href} className={isLast ? "text-gray-900 font-semibold" : ""}>
              {isLast ? (
                <span>{item.name}</span>
              ) : (
                <>
                  <Link href={item.href} className="hover:text-black hover:underline">
                    {item.name}
                  </Link>
                  <span className="mx-2">/</span>
                </>
              )}
            </li>
          );
        })}
      </ol>

      {/* Google için zorunlu olan kısım */}
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify({
            "@context": "https://schema.org",
            "@type": "BreadcrumbList",
            itemListElement: [
              {
                "@type": "ListItem",
                position: 1,
                name: "Ana Sayfa",
                item: "https://hemenustamgelsin.com/",
              },
              ...items.map((it, idx) => ({
                "@type": "ListItem",
                position: idx + 2,
                name: it.name,
                item: `https://hemenustamgelsin.com${it.href}`,
              })),
            ],
          }),
        }}
      />
    </nav>
  );
}