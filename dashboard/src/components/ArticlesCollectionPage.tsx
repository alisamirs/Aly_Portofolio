import { useEffect, useMemo, useState } from "react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { articles, type ArticleRecord } from "../data/articles";
import { ThemePicker } from "./ThemePicker";

const articleBodies = import.meta.glob<string>("../articles/*.md", { eager: true, query: "?raw", import: "default" });

function articleUrl(slug?: string) {
  const url = new URL(import.meta.env.BASE_URL, window.location.origin);
  url.searchParams.set("collection", "articles");
  if (slug) url.searchParams.set("article", slug);
  return `${url.pathname}${url.search}`;
}

function navigate(slug?: string) {
  window.history.pushState({}, "", articleUrl(slug));
  window.dispatchEvent(new PopStateEvent("popstate"));
}

function date(value: string, month: "short" | "long") {
  return new Date(`${value}T00:00:00`).toLocaleDateString(undefined, { year: "numeric", month, day: "numeric" });
}

function Card({ article }: { article: ArticleRecord }) {
  return <button type="button" onClick={() => navigate(article.slug)} className="group flex min-h-64 w-full flex-col rounded-2xl border border-border-subtle bg-surface/70 p-6 text-left transition-all hover:-translate-y-0.5 hover:border-accent/50 hover:bg-accent/[0.04]">
    <div className="flex items-start justify-between gap-3"><div className="flex flex-wrap gap-2">{article.tags.map((tag) => <span key={tag} className="rounded-full bg-accent/10 px-2.5 py-1 text-[10px] font-semibold uppercase tracking-wider text-accent">{tag}</span>)}</div><span className={`shrink-0 text-[10px] font-semibold uppercase tracking-wider ${article.status === "published" ? "text-emerald-400" : "text-text-muted"}`}>{article.status}</span></div>
    <h2 className="mt-6 font-heading text-2xl text-text-primary transition-colors group-hover:text-accent">{article.title}</h2>
    <p className="mt-3 flex-1 text-sm leading-6 text-text-secondary">{article.summary}</p>
    <div className="mt-6 flex items-center justify-between border-t border-border-subtle pt-4 text-xs text-text-muted"><span>{date(article.date, "short")} · {article.readTime}</span><span className="text-accent">Open article →</span></div>
  </button>;
}

function Reader({ article }: { article: ArticleRecord }) {
  const content = articleBodies[article.file];
  const index = articles.findIndex((item) => item.slug === article.slug);
  const previous = articles[index - 1];
  const next = articles[index + 1];
  return <article className="mx-auto max-w-3xl py-10 sm:py-14">
    <button type="button" onClick={() => navigate()} className="mb-8 text-sm text-text-muted hover:text-accent">← All articles</button>
    <div className="mb-4 flex flex-wrap items-center gap-2 text-xs text-text-muted"><time dateTime={article.date}>{date(article.date, "long")}</time><span>·</span><span>{article.readTime}</span><span>·</span><span className="text-emerald-400">{article.status}</span></div>
    <h1 className="font-heading text-3xl leading-tight text-text-primary sm:text-5xl">{article.title}</h1>
    <p className="mt-5 border-b border-border-subtle pb-8 text-lg leading-8 text-text-secondary">{article.summary}</p>
    <div className="article-prose mt-10 text-base leading-7 text-text-secondary">{content ? <ReactMarkdown remarkPlugins={[remarkGfm]}>{content}</ReactMarkdown> : <p>Article content is not available yet.</p>}</div>
    <nav className="mt-12 grid gap-3 border-t border-border-subtle pt-5 sm:grid-cols-2" aria-label="Article navigation">
      {previous ? <button type="button" onClick={() => navigate(previous.slug)} className="rounded-xl border border-border-subtle p-4 text-left hover:border-accent/50"><span className="text-xs text-text-muted">← Previous</span><span className="mt-1 block text-sm text-text-primary">{previous.title}</span></button> : <span />}
      {next && <button type="button" onClick={() => navigate(next.slug)} className="rounded-xl border border-border-subtle p-4 text-right hover:border-accent/50"><span className="text-xs text-text-muted">Next →</span><span className="mt-1 block text-sm text-text-primary">{next.title}</span></button>}
    </nav>
  </article>;
}

export default function ArticlesCollectionPage() {
  const [selectedSlug, setSelectedSlug] = useState(() => new URLSearchParams(window.location.search).get("article"));
  const [query, setQuery] = useState("");
  const [activeTag, setActiveTag] = useState("All topics");
  useEffect(() => {
    const handleHistoryChange = () => {
      setSelectedSlug(new URLSearchParams(window.location.search).get("article"));
    };
    window.addEventListener("popstate", handleHistoryChange);
    return () => window.removeEventListener("popstate", handleHistoryChange);
  }, []);
  const go = (slug?: string) => { navigate(slug); setSelectedSlug(slug ?? null); };
  const topics = ["All topics", ...new Set(articles.flatMap((article) => article.tags))];
  const filtered = useMemo(() => articles.filter((article) => {
    const text = [article.title, article.summary, ...article.tags].join(" ").toLowerCase();
    return (!query.trim() || text.includes(query.toLowerCase())) && (activeTag === "All topics" || article.tags.includes(activeTag));
  }), [activeTag, query]);
  const selected = articles.find((article) => article.slug === selectedSlug);
  const published = articles.filter((article) => article.status === "published").length;

  return <main className="min-h-screen overflow-auto bg-root text-text-primary noise-overlay"><div className="mx-auto max-w-6xl px-5 py-8 sm:px-8 sm:py-12">
    <header className="flex items-center justify-between gap-4 border-b border-border-subtle pb-5"><button type="button" onClick={() => go()} className="font-heading text-lg text-text-primary hover:text-accent">Ali Samir <span className="text-text-muted">/ Articles</span></button><div className="flex items-center gap-3"><a href={import.meta.env.BASE_URL} className="rounded-lg border border-border-medium bg-elevated px-3 py-2 text-sm text-text-secondary hover:border-accent/50 hover:text-accent">Portfolio</a><ThemePicker /></div></header>
    {selected ? <Reader article={selected} /> : <>
      <section className="max-w-3xl py-12 sm:py-16"><p className="text-xs font-semibold uppercase tracking-[0.25em] text-accent">Writing · Audit · Accounting</p><h1 className="mt-4 font-heading text-4xl leading-tight text-text-primary sm:text-6xl">Articles</h1><p className="mt-5 text-base leading-7 text-text-secondary sm:text-lg">A growing collection of practical notes on audit, accounting, and professional development.</p></section>
      <section className="grid gap-3 sm:grid-cols-3" aria-label="Article collection status">{[["Articles", articles.length, "in the collection"], ["Published", published, "ready to read"], ["Topics", topics.length - 1, "areas covered"]].map(([label, value, detail]) => <div key={label} className="rounded-2xl border border-border-subtle bg-surface/70 p-5"><p className="text-xs uppercase tracking-[0.18em] text-text-muted">{label}</p><p className="mt-2 font-heading text-3xl text-accent">{value}</p><p className="text-xs text-text-secondary">{detail}</p></div>)}</section>
      <section className="mt-8 rounded-2xl border border-border-subtle bg-surface/60 p-4 sm:p-5" aria-label="Find an article"><div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between"><label className="lg:max-w-sm lg:flex-1"><span className="sr-only">Search articles</span><input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Search articles, topics, or tags" className="w-full rounded-lg border border-border-medium bg-elevated px-3 py-2.5 text-sm text-text-primary outline-none placeholder:text-text-muted focus:border-accent" /></label><div className="flex flex-wrap gap-2">{topics.map((topic) => <button key={topic} type="button" onClick={() => setActiveTag(topic)} className={`rounded-full border px-3 py-1.5 text-xs ${activeTag === topic ? "border-accent/60 bg-accent/15 text-accent" : "border-border-subtle text-text-muted hover:border-accent/40 hover:text-text-secondary"}`}>{topic}</button>)}</div></div><p className="mt-4 text-xs text-text-muted">Showing {filtered.length} of {articles.length} articles</p></section>
      <section aria-label="Articles" className="mt-5 grid gap-4 sm:grid-cols-2">{filtered.map((article) => <Card key={article.slug} article={article} />)}{filtered.length === 0 && <p className="rounded-xl border border-dashed border-border-medium p-8 text-sm text-text-muted sm:col-span-2">No articles match that search.</p>}</section>
    </>}
  </div></main>;
}
