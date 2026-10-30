import { ThemePicker } from "./ThemePicker";

const collections = [
  {
    key: "tx-uk",
    eyebrow: "ACCA · PASSED EXAM",
    title: "Taxation — TX-UK",
    description:
      "Explore the first knowledge graph: UK tax concepts, computations, reliefs, and the links between them.",
    action: "Open Tax knowledge graph",
    available: true,
  },
  {
    key: "fm",
    eyebrow: "ACCA · PASSED EXAM",
    title: "Financial Management",
    description:
      "A future knowledge base for finance techniques, decision-making, valuation, and performance analysis.",
    action: "Collection coming soon",
    available: false,
  },
  {
    key: "aa",
    eyebrow: "ACCA · PASSED EXAM",
    title: "Audit & Assurance",
    description:
      "A future knowledge base for audit planning, risk, evidence, controls, and assurance conclusions.",
    action: "Collection coming soon",
    available: false,
  },
];

function openCollection(key: string) {
  const params = new URLSearchParams(window.location.search);
  params.set("collection", key);
  window.location.href = `${import.meta.env.BASE_URL}?${params.toString()}`;
}

export default function PortfolioHome() {
  return (
    <main className="min-h-screen overflow-auto bg-root text-text-primary noise-overlay">
      <div className="mx-auto max-w-6xl px-5 py-10 sm:px-8 lg:py-16">
        <div className="mb-2 flex justify-end">
          <ThemePicker />
        </div>
        <header className="flex flex-wrap items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl border border-accent/40 bg-accent/10 text-accent">
              <svg viewBox="0 0 24 24" className="h-5 w-5" fill="none" stroke="currentColor" strokeWidth="1.7">
                <circle cx="6" cy="12" r="2" />
                <circle cx="18" cy="6" r="2" />
                <circle cx="18" cy="18" r="2" />
                <path d="m8 11 8-4M8 13l8 4" />
              </svg>
            </div>
            <div>
              <p className="text-[10px] font-semibold uppercase tracking-[0.22em] text-accent">Ali Samir</p>
              <p className="font-heading text-sm tracking-wide text-text-secondary">Portfolio</p>
            </div>
          </div>
          <a
              href="https://www.linkedin.com/in/ali-samir-ifrdip-aa-and-fm-acca-in-progress-ab2b26109/"
              target="_blank"
              rel="noreferrer"
              className="rounded-lg border border-border-medium bg-elevated px-4 py-2 text-sm text-text-secondary transition-colors hover:border-accent/50 hover:text-accent"
          >
            LinkedIn profile ↗
          </a>
        </header>

        <section className="mt-16 max-w-3xl">
          <p className="text-xs font-semibold uppercase tracking-[0.25em] text-accent">Professional knowledge graph</p>
          <h1 className="mt-4 font-heading text-4xl leading-tight tracking-tight text-text-primary sm:text-6xl">
            A map of what I have learned, passed, and applied.
          </h1>
          <p className="mt-6 max-w-2xl text-base leading-7 text-text-secondary sm:text-lg">
            This portfolio connects qualifications, exam knowledge, practical skills, and experience. Choose a knowledge base below to explore one part of the journey.
          </p>
        </section>

        <section className="mt-14 grid gap-4 lg:grid-cols-3" aria-label="Knowledge base collections">
          {collections.map((collection, index) => (
            <article
              key={collection.key}
              className={`group relative flex min-h-[270px] flex-col rounded-2xl border p-6 transition-colors ${
                collection.available
                  ? "border-accent/45 bg-accent/[0.07] hover:border-accent hover:bg-accent/[0.12]"
                  : "border-border-subtle bg-surface/60"
              }`}
            >
              <div className="flex items-center justify-between">
                <span className="text-[10px] font-semibold uppercase tracking-[0.18em] text-accent">{collection.eyebrow}</span>
                <span className="font-heading text-2xl text-text-muted/50">0{index + 1}</span>
              </div>
              <h2 className="mt-8 font-heading text-2xl text-text-primary">{collection.title}</h2>
              <p className="mt-3 flex-1 text-sm leading-6 text-text-secondary">{collection.description}</p>
              {collection.available ? (
                <button
                  type="button"
                  onClick={() => openCollection(collection.key)}
                  className="mt-6 flex items-center justify-between rounded-lg border border-accent/50 bg-accent/10 px-4 py-3 text-left text-sm font-medium text-accent transition-colors hover:bg-accent/20"
                >
                  {collection.action}
                  <span aria-hidden="true">→</span>
                </button>
              ) : (
                <div className="mt-6 rounded-lg border border-border-subtle bg-elevated/60 px-4 py-3 text-sm text-text-muted">{collection.action}</div>
              )}
            </article>
          ))}
        </section>

        <section className="mt-14 grid gap-4 md:grid-cols-2">
          <div className="rounded-2xl border border-border-subtle bg-surface/60 p-6">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-text-muted">Professional profile</p>
            <h2 className="mt-3 font-heading text-xl text-text-primary">External Auditor · Senior Associate</h2>
            <p className="mt-3 text-sm leading-6 text-text-secondary">
              Experienced and resourceful external auditor with more than 5 years of experience in both the audit and assurance field. I’m currently working for Forvis Mazars – Audit Firm which provides audit and tax services for many industries and sectors such as banking, retailers, and many other Manufacturing companies.
            </p>
          </div>
          <div className="rounded-2xl border border-border-subtle bg-surface/60 p-6">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-text-muted">Professional Development</p>
            <h2 className="mt-3 font-heading text-xl text-text-primary">Certificates and Education</h2>
            <p className="mt-3 text-sm leading-6 text-text-secondary">
              Bachelor&apos;s degree in accounting, IFRS Diploma, and Passed ACCA Exames in Audit &amp; Assurance, Financial Management, and TX-UK. Public contact details remain excluded from this portfolio page.
            </p>
          </div>
          <div className="rounded-2xl border border-border-subtle bg-surface/60 p-6">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-text-muted">Computer Skills</p>
            <h2 className="mt-3 font-heading text-xl text-text-primary">Technical Experience</h2>
            <p className="mt-3 text-sm leading-6 text-text-secondary">
              •	Microsoft office Package (Using Python in excel). <br/> •	International Online Audit Platform Forvis Mazars "Atlas". <br/> •	Using Web Search Engines professionally for accounting and audit technical matters.
            </p>
          </div>
          <div className="rounded-2xl border border-border-subtle bg-surface/60 p-6">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-text-muted">Social Skills</p>
            <h2 className="mt-3 font-heading text-xl text-text-primary">Personal Experience</h2>
            <p className="mt-3 text-sm leading-6 text-text-secondary">
              •	Effective Communication and Adaptability. <br/> •	Presentation and Time Management. <br/> •	Confident in working with different Cultures.
            </p>
          </div>
          <div className="rounded-2xl border border-border-subtle bg-surface/60 p-6">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-text-muted">Work Experience</p>
            <h2 className="mt-3 font-heading text-xl text-text-primary">My Work Experience are the following:</h2>
            <p className="mt-3 text-sm leading-6 text-text-secondary">
•	Understanding the nature of company’s primary business activities and the industry in which company operates. <br/>
•	Evaluating internal control components through performing test of control for the company’s Internal Control. <br/>
•	Participating in Preparing Management Letters, Engagement Letters. <br/>
•	Performing analytical procedures on financial statements. <br/>
•	Checking and validating the Company’s Permanent Documents. <br/>
•	Checking company’s FS disclosures to verify the compliance with Egyptian accounting standards and Laws or any other regulations or official bodies (i.e., CBE rules). <br/>
•	Performing tailored audit procedures for specific cases under their circumstances and the nature of account and preparing working papers and obtain reasonable assurance with appropriate audit evidence that the financial statements are correct and free from material misstatement. <br/>
•	Preparing the auditor’s report that reflects audit results for reviewal then document the audit work process in accordance with regulatory requirements and ISAs using audit tools (i.e., Atlas). <br/>
•	Translating Financial Statements. <br/> 
            </p>
          </div>
        </section>

        <footer className="mt-16 border-t border-border-subtle pt-5 text-xs text-text-muted">
          Portfolio · Senior Associate · ACCA (IFRDip, AA, TX-UK and FM) 
        </footer>
      </div>
    </main>
  );
}
