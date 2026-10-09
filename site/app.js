const state = { graph: null, nodes: [], edges: [], selected: null, query: "", type: "all" };
const colors = { article:"#58a6ff", topic:"#bc8cff", entity:"#3fb950", claim:"#f0883e", source:"#f778ba" };
const svg = d3.select("#graph");
const width = () => document.querySelector(".graph-panel").clientWidth;
const height = () => document.querySelector(".graph-panel").clientHeight;

async function load() {
  state.graph = await fetch("./data/knowledge-graph.json").then(r => r.json());
  state.nodes = state.graph.nodes.map(n => ({ ...n })); state.edges = state.graph.edges.map(e => ({ ...e }));
  const types = [...new Set(state.nodes.map(n => n.type))].sort();
  document.querySelector("#typeFilter").innerHTML += types.map(t => `<option value="${t}">${t}</option>`).join("");
  document.querySelector("#stats").textContent = `${state.nodes.length} nodes · ${state.edges.length} relationships · ${(state.graph.layers || []).length} study categories`;
  draw();
}
function label(n) { return n.name || n.id.replace(/^(article|topic|entity|claim|source):/, ""); }
function matches(n) { const q = state.query.toLowerCase(); return (state.type === "all" || n.type === state.type) && (!q || `${label(n)} ${n.summary || ""} ${(n.tags || []).join(" ")}`.toLowerCase().includes(q)); }
function draw() {
  svg.selectAll("*").remove(); const w = width(), h = height(); svg.attr("viewBox", `0 0 ${w} ${h}`);
  const nodeIds = new Set(state.nodes.map(n => n.id)); const links = state.edges.filter(e => nodeIds.has(e.source) && nodeIds.has(e.target)).map(e => ({ ...e }));
  const sim = d3.forceSimulation(state.nodes).force("link", d3.forceLink(links).id(d => d.id).distance(90).strength(.35)).force("charge", d3.forceManyBody().strength(-170)).force("center", d3.forceCenter(w/2,h/2)).force("collide", d3.forceCollide(17));
  const zoomLayer = svg.append("g"); svg.call(d3.zoom().scaleExtent([.2,4]).on("zoom", e => zoomLayer.attr("transform", e.transform)));
  const link = zoomLayer.append("g").selectAll("line").data(links).join("line").attr("class","edge");
  const node = zoomLayer.append("g").selectAll("circle").data(state.nodes).join("circle").attr("class","node").attr("r", d => d.type === "topic" ? 10 : 7).attr("fill", d => colors[d.type] || "#8b949e").on("click", (_, d) => selectNode(d)).call(d3.drag().on("start", (e,d) => { if(!e.active)sim.alphaTarget(.3).restart(); d.fx=d.x;d.fy=d.y; }).on("drag",(e,d)=>{d.fx=e.x;d.fy=e.y;}).on("end",(e,d)=>{if(!e.active)sim.alphaTarget(0);d.fx=null;d.fy=null;}));
  const text = zoomLayer.append("g").selectAll("text").data(state.nodes).join("text").attr("class","label").text(d => label(d).slice(0,28));
  sim.on("tick", () => { link.attr("x1",d=>d.source.x).attr("y1",d=>d.source.y).attr("x2",d=>d.target.x).attr("y2",d=>d.target.y); node.attr("cx",d=>d.x).attr("cy",d=>d.y); text.attr("x",d=>d.x+9).attr("y",d=>d.y+3); applyDim(node,text); });
  state.sim = sim;
}
function applyDim(node,text) { node.classed("dim", d => !matches(d)); text.classed("dim", d => !matches(d)); }
function selectNode(n) { state.selected = n; document.querySelector("#selected").innerHTML = `<h2>${escapeHtml(label(n))}</h2><p>${escapeHtml(n.summary || "")}</p><div class="tags">${(n.tags||[]).map(t=>`<span>${escapeHtml(t)}</span>`).join("")}</div>${n.filePath ? `<button id="readNotes">Open study notes</button>` : ""}<h3>Connected topics</h3><div id="related"></div>`; const rel = state.edges.filter(e=>e.source===n.id||e.target===n.id).map(e=>state.nodes.find(x=>x.id===(e.source===n.id?e.target:e.source))).filter(Boolean); document.querySelector("#related").innerHTML = rel.slice(0,14).map(x=>`<button class="related" data-id="${x.id}">${escapeHtml(label(x))}</button>`).join("") || '<p class="muted">No direct connections.</p>'; document.querySelectorAll(".related").forEach(b=>b.onclick=()=>selectNode(state.nodes.find(x=>x.id===b.dataset.id))); if(n.filePath) document.querySelector("#readNotes").onclick=()=>openNotes(n); }
async function openNotes(n) { const content = await fetch(`./${n.filePath}`).then(r=>r.text()); document.querySelector("#readerTitle").textContent=label(n); document.querySelector("#readerContent").innerHTML=marked.parse(content); document.querySelector("#reader").showModal(); }
function escapeHtml(s) { return String(s).replace(/[&<>"']/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c])); }
document.querySelector("#search").oninput=e=>{state.query=e.target.value;draw();}; document.querySelector("#typeFilter").onchange=e=>{state.type=e.target.value;draw();}; document.querySelector("#reset").onclick=()=>draw(); document.querySelector("#closeReader").onclick=()=>document.querySelector("#reader").close(); load().catch(e=>{document.querySelector("#stats").textContent=`Unable to load graph: ${e.message}`;});
