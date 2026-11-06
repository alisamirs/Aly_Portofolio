export interface ArticleRecord {
  slug: string;
  title: string;
  summary: string;
  date: string;
  readTime: string;
  tags: string[];
  file: string;
  status: "published" | "draft";
}

/** The registry is the single place to add an article to the collection. */
export const articles: ArticleRecord[] = [
  {
    slug: "ifrs-1-first-time-adoption",
    title: "IFRS 1: A practical guide to first-time adoption",
    summary: "The objective of this IFRS is to ensure that an entity’s first IFRS financial statements, and its interim financial reports for part of the period covered by those financial statements, contain high quality information",
    date: "2026-11-04",
    readTime: "7 min read",
    tags: ["IFRS", "Financial reporting", "Transition"],
    file: "../articles/ifrs-1-first-time-adoption.md",
    status: "published",
  },
  {
    slug: "audit-planning",
    title: "Audit planning: a practical overview",
    summary: "A concise study note on why audit planning matters and how it supports a focused, effective assurance engagement.",
    date: "2026-10-28",
    readTime: "3 min read",
    tags: ["Audit & Assurance", "Planning"],
    file: "../articles/audit-planning.md",
    status: "draft",
  },
];
