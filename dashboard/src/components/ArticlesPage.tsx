import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { ThemePicker } from "./ThemePicker";

interface Article {
  slug: string;
  title: string;
  summary: string;
  date: string;
  readTime: string;
  tags: string[];
  file: string;
}

const articles: Article[] = [
  {
    slug: "audit-planning",
    title: "Audit planning: a practical overview",
    summary:
      "An introduction to audit planning, why it matters, and further reading around ISA 300.",
    date: "2026-11-04",
    readTime: "3 min read",
    tags: ["Audit", "Planning", "ISA 300"],
    file: "../articles/audit-planning.md",
  },
];

// Markdown is bundled as raw text by Vite, so articles work on GitHub Pages
// without a server or a separate workflow copy step.
const articleBodies = import.meta.glob<string>("../articles/*.md", {
  eager: true,
  query: "?raw",
  import: "default",
});

function articleUrl(slug?: string): string {
  const url = new URL(import.meta.env.BASE_URL, window.location.origin);
  url.searchParams.set("collection", "articles");
  if (slug) url.searchParams.set("article", slug);
  return `${url.pathname}${url.search}`;
}

export default function ArticlesPage() {
  const params = new URLSearchParams(window.location.search);
  const selectedSlug = params.get("article");
  const selectedArticle = articles.find((article) => article.slug === selectedSlug);
  const articleContent = selectedArticle
    ? articleBodies[selectedArticle.file]
    : undefined;

  return (
    <main className="min-h-screen overflow-auto bg-root text-text-primary noise-overlay">
      <div className="mx-auto max-w-5xl px-5 py-8 sm:px-8 sm:py-12">
        <header className="flex items-center justify-between gap-4 border-b border-border-subtle pb-5">
          <a
            href={articleUrl()}
            className="font-heading text-lg text-text-primary transition-colors hover:text-accent"
            aria-label="Articles home"
          >
            Ali Samir <span className="text-text-muted">/ Articles</span>
          </a>
          <div className="flex items-center gap-3">
            <a
              href={import.meta.env.BASE_URL}
              className="rounded-lg border border-border-medium bg-elevated px-3 py-2 text-sm text-text-secondary transition-colors hover:border-accent/50 hover:text-accent"
            >
              Portfolio
            </a>
            <ThemePicker />
          </div>
        </header>

        {selectedSlug ? (
          selectedArticle && articleContent ? (
            <article className="mx-auto max-w-3xl py-10 sm:py-14">
              <a
                href={articleUrl()}
                className="mb-8 inline-flex items-center gap-2 text-sm text-text-muted transition-colors hover:text-accent"
              >
                <span aria-hidden="true">←</span> All articles
              </a>
              <div className="mb-4 flex flex-wrap items-center gap-2 text-xs text-text-muted">
                <time dateTime={selectedArticle.date}>
                  {new Date(`${selectedArticle.date}T00:00:00`).toLocaleDateString(
                    undefined,
                    { year: "numeric", month: "long", day: "numeric" },
                  )}
                </time>
                <span aria-hidden="true">·</span>
                <span>{selectedArticle.readTime}</span>
              </div>
              <h1 className="font-heading text-3xl leading-tight text-text-primary sm:text-5xl">
                {selectedArticle.title}
              </h1>
              <p className="mt-5 border-b border-border-subtle pb-8 text-lg leading-8 text-text-secondary">
                {selectedArticle.summary}
              </p>
              <div className="mt-8 flex flex-wrap gap-2">
                {selectedArticle.tags.map((tag) => (
                  <span
                    key={tag}
                    className="rounded-full border border-accent/25 bg-accent/10 px-3 py-1 text-xs text-accent"
                  >
                    {tag}
                  </span>
                ))}
              </div>
              <div className="article-prose mt-10 text-base leading-7 text-text-secondary">
                <ReactMarkdown
                  remarkPlugins={[remarkGfm]}
                  components={{
                    h1: ({ children }) => (
                      <h2 className="mb-4 mt-10 font-heading text-2xl text-text-primary first:mt-0">
                        {children}
                      </h2>
                    ),
                    h2: ({ children }) => (
                      <h2 className="mb-3 mt-9 border-b border-border-subtle pb-2 font-heading text-xl text-text-primary">
                        {children}
                      </h2>
                    ),
                    h3: ({ children }) => (
                      <h3 className="mb-2 mt-7 font-heading text-lg text-text-primary">
                        {children}
                      </h3>
                    ),
                    p: ({ children }) => <p className="mb-5">{children}</p>,
                    a: ({ children, href }) => (
                      <a
                        href={href}
                        target="_blank"
                        rel="noreferrer"
                        className="text-accent underline decoration-accent/40 underline-offset-4 hover:decoration-accent"
                      >
                        {children}
                      </a>
                    ),
                    ul: ({ children }) => (
                      <ul className="mb-5 list-disc space-y-2 pl-6">{children}</ul>
                    ),
                    ol: ({ children }) => (
                      <ol className="mb-5 list-decimal space-y-2 pl-6">{children}</ol>
                    ),
                    blockquote: ({ children }) => (
                      <blockquote className="mb-5 border-l-2 border-accent/50 pl-4 italic text-text-muted">
                        {children}
                      </blockquote>
                    ),
                    code: ({ children }) => (
                      <code className="rounded bg-elevated px-1.5 py-0.5 font-mono text-sm text-accent">
                        {children}
                      </code>
                    ),
                    hr: () => <hr className="my-8 border-border-subtle" />,
                  }}
                >
                  {articleContent}
                </ReactMarkdown>
              </div>
              <footer className="mt-12 border-t border-border-subtle pt-5 text-xs leading-5 text-text-muted">
                Articles are shared for general educational purposes and are not
                professional advice. Refer to current authoritative guidance for
                your circumstances.
              </footer>
            </article>
          ) : (
            <section className="py-16 text-center">
              <p className="text-sm text-text-muted">Article not found.</p>
              <a
                href={articleUrl()}
                className="mt-4 inline-block text-sm text-accent hover:underline"
              >
                Browse all articles
              </a>
            </section>
          )
        ) : (
          <>
            <section className="max-w-3xl py-12 sm:py-16">
              <p className="text-xs font-semibold uppercase tracking-[0.25em] text-accent">
                Writing · Audit · Accounting
              </p>
              <h1 className="mt-4 font-heading text-4xl leading-tight text-text-primary sm:text-6xl">
                Articles
              </h1>
              <p className="mt-5 text-base leading-7 text-text-secondary sm:text-lg">
                Practical notes and perspectives on audit, accounting, and
                professional development.
              </p>
            </section>

            <section aria-label="Articles" className="grid gap-4 sm:grid-cols-2">
              {articles.map((article) => (
                <a
                  key={article.slug}
                  href={articleUrl(article.slug)}
                  className="group flex min-h-64 flex-col rounded-2xl border border-border-subtle bg-surface/70 p-6 transition-all hover:-translate-y-0.5 hover:border-accent/50 hover:bg-accent/[0.04]"
                >
                  <div className="flex flex-wrap gap-2">
                    {article.tags.map((tag) => (
                      <span
                        key={tag}
                        className="rounded-full bg-accent/10 px-2.5 py-1 text-[10px] font-semibold uppercase tracking-wider text-accent"
                      >
                        {tag}
                      </span>
                    ))}
                  </div>
                  <h2 className="mt-6 font-heading text-2xl text-text-primary transition-colors group-hover:text-accent">
                    {article.title}
                  </h2>
                  <p className="mt-3 flex-1 text-sm leading-6 text-text-secondary">
                    {article.summary}
                  </p>
                  <div className="mt-6 flex items-center justify-between border-t border-border-subtle pt-4 text-xs text-text-muted">
                    <time dateTime={article.date}>
                      {new Date(`${article.date}T00:00:00`).toLocaleDateString(
                        undefined,
                        { year: "numeric", month: "short", day: "numeric" },
                      )}
                    </time>
                    <span className="flex items-center gap-2 text-accent">
                      Read article <span aria-hidden="true">→</span>
                    </span>
                  </div>
                </a>
              ))}
            </section>
          </>
        )}
      </div>
    </main>
  );
}
