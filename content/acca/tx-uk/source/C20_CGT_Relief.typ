// Chapter-based numbering for books with appendix support
#let equation-numbering = it => {
  let pattern = if state("appendix-state", none).get() != none { "(A.1)" } else { "(1.1)" }
  numbering(pattern, counter(heading).get().first(), it)
}
#let callout-numbering = it => {
  let pattern = if state("appendix-state", none).get() != none { "A.1" } else { "1.1" }
  numbering(pattern, counter(heading).get().first(), it)
}
#let subfloat-numbering(n-super, subfloat-idx) = {
  let chapter = counter(heading).get().first()
  let pattern = if state("appendix-state", none).get() != none { "A.1a" } else { "1.1a" }
  numbering(pattern, chapter, n-super, subfloat-idx)
}
// Theorem configuration for theorion
// Chapter-based numbering (H1 = chapters)
#let theorem-inherited-levels = 1

// Appendix-aware theorem numbering
#let theorem-numbering(loc) = {
  if state("appendix-state", none).at(loc) != none { "A.1" } else { "1.1" }
}

// Theorem render function
// Note: brand-color is not available at this point in template processing
#let theorem-render(prefix: none, title: "", full-title: auto, body) = {
  block(
    width: 100%,
    inset: (left: 1em),
    stroke: (left: 2pt + black),
  )[
    #if full-title != "" and full-title != auto and full-title != none {
      strong[#full-title]
      linebreak()
    }
    #body
  ]
}
// Some definitions presupposed by pandoc's typst output.
#let content-to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(content-to-string).join("")
  } else if content.has("body") {
    content-to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms.item: it => block(breakable: false)[
  #text(weight: "bold")[#it.term]
  #block(inset: (left: 1.5em, top: -0.4em))[#it.description]
]

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let fields = old_block.fields()
  let _ = fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => {
          let subfloat-idx = quartosubfloatcounter.get().first() + 1
          subfloat-numbering(n-super, subfloat-idx)
        })
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => block({
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          })

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let children = old_title_block.body.body.children
  let old_title = if children.len() == 1 {
    children.at(0)  // no icon: title at index 0
  } else {
    children.at(1)  // with icon: title at index 1
  }

  // TODO use custom separator if available
  // Use the figure's counter display which handles chapter-based numbering
  // (when numbering is a function that includes the heading counter)
  let callout_num = it.counter.display(it.numbering)
  let new_title = if empty(old_title) {
    [#kind #callout_num]
  } else {
    [#kind #callout_num: #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block,
    block_with_new_content(
      old_title_block.body,
      if children.len() == 1 {
        new_title  // no icon: just the title
      } else {
        children.at(0) + new_title  // with icon: preserve icon block + new title
      }))

  align(left, block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1)))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color,
        width: 100%,
        inset: 8pt)[#if icon != none [#text(icon_color, weight: 900)[#icon] ]#title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}


// syntax highlighting functions from skylighting:
/* Function definitions for syntax highlighting generated by skylighting: */
#let EndLine() = raw("\n")
#let Skylighting(fill: none, number: false, start: 1, sourcelines) = {
   let blocks = []
   let lnum = start - 1
   let bgcolor = rgb("#f1f3f5")
   for ln in sourcelines {
     if number {
       lnum = lnum + 1
       blocks = blocks + box(width: if start + sourcelines.len() > 999 { 30pt } else { 24pt }, text(fill: rgb("#aaaaaa"), [ #lnum ]))
     }
     blocks = blocks + ln + EndLine()
   }
   block(fill: bgcolor, width: 100%, inset: 8pt, radius: 2pt, blocks)
}
#let AlertTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let AnnotationTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let AttributeTok(s) = text(fill: rgb("#657422"),raw(s))
#let BaseNTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let BuiltInTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let CharTok(s) = text(fill: rgb("#20794d"),raw(s))
#let CommentTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let CommentVarTok(s) = text(style: "italic",fill: rgb("#5e5e5e"),raw(s))
#let ConstantTok(s) = text(fill: rgb("#8f5902"),raw(s))
#let ControlFlowTok(s) = text(weight: "bold",fill: rgb("#003b4f"),raw(s))
#let DataTypeTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let DecValTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let DocumentationTok(s) = text(style: "italic",fill: rgb("#5e5e5e"),raw(s))
#let ErrorTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let ExtensionTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let FloatTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let FunctionTok(s) = text(fill: rgb("#4758ab"),raw(s))
#let ImportTok(s) = text(fill: rgb("#00769e"),raw(s))
#let InformationTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let KeywordTok(s) = text(weight: "bold",fill: rgb("#003b4f"),raw(s))
#let NormalTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let OperatorTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let OtherTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let PreprocessorTok(s) = text(fill: rgb("#ad0000"),raw(s))
#let RegionMarkerTok(s) = text(fill: rgb("#003b4f"),raw(s))
#let SpecialCharTok(s) = text(fill: rgb("#5e5e5e"),raw(s))
#let SpecialStringTok(s) = text(fill: rgb("#20794d"),raw(s))
#let StringTok(s) = text(fill: rgb("#20794d"),raw(s))
#let VariableTok(s) = text(fill: rgb("#111111"),raw(s))
#let VerbatimStringTok(s) = text(fill: rgb("#20794d"),raw(s))
#let WarningTok(s) = text(style: "italic",fill: rgb("#5e5e5e"),raw(s))



#let article(
  title: none,
  subtitle: none,
  authors: none,
  keywords: (),
  date: none,
  abstract-title: none,
  abstract: none,
  thanks: none,
  cols: 1,
  lang: "en",
  region: "US",
  font: none,
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: none,
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  mathfont: none,
  codefont: none,
  linestretch: 1,
  sectionnumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  // Set document metadata for PDF accessibility
  set document(title: title, keywords: keywords)
  set document(
    author: authors.map(author => content-to-string(author.name)).join(", ", last: " & "),
  ) if authors != none and authors != ()
  set par(
    justify: true,
    leading: linestretch * 0.65em
  )
  set text(lang: lang,
           region: region,
           size: fontsize)
  set text(font: font) if font != none
  show math.equation: set text(font: mathfont) if mathfont != none
  show raw: set text(font: codefont) if codefont != none

  set heading(numbering: sectionnumbering)

  show link: set text(fill: rgb(content-to-string(linkcolor))) if linkcolor != none
  show ref: set text(fill: rgb(content-to-string(citecolor))) if citecolor != none
  show link: this => {
    if filecolor != none and type(this.dest) == label {
      text(this, fill: rgb(content-to-string(filecolor)))
    } else {
      text(this)
    }
   }

  let has-title-block = title != none or (authors != none and authors != ()) or date != none or abstract != none
  if has-title-block {
    place(
      top,
      float: true,
      scope: "parent",
      clearance: 4mm,
      block(below: 1em, width: 100%)[

        #if title != none {
          align(center, block(inset: 2em)[
            #set par(leading: heading-line-height) if heading-line-height != none
            #set text(font: heading-family) if heading-family != none
            #set text(weight: heading-weight)
            #set text(style: heading-style) if heading-style != "normal"
            #set text(fill: heading-color) if heading-color != black

            #text(size: title-size)[#title #if thanks != none {
              footnote(thanks, numbering: "*")
              counter(footnote).update(n => n - 1)
            }]
            #(if subtitle != none {
              parbreak()
              text(size: subtitle-size)[#subtitle]
            })
          ])
        }

        #if authors != none and authors != () {
          let count = authors.len()
          let ncols = calc.min(count, 3)
          grid(
            columns: (1fr,) * ncols,
            row-gutter: 1.5em,
            ..authors.map(author =>
                align(center)[
                  #author.name \
                  #author.affiliation \
                  #author.email
                ]
            )
          )
        }

        #if date != none {
          align(center)[#block(inset: 1em)[
            #date
          ]]
        }

        #if abstract != none {
          block(inset: 2em)[
          #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
          ]
        }
      ]
    )
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  doc
}

#set table(
  inset: 6pt,
  stroke: none
)
#import "@preview/fontawesome:0.5.0": *
#let brand-color = (:)
#let brand-color-background = (:)
#let brand-logo = (:)

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
  columns: 1,
)
// Logo is handled by orange-book's cover page, not as a page background
// NOTE: marginalia.setup is called in typst-show.typ AFTER book.with()
// to ensure marginalia's margins override the book format's default margins
#import "@preview/orange-book:0.7.1": book, part, chapter, appendices

#show: book.with(
  title: [Chapter 20: CGT: Reliefs for individuals],
  main-color: brand-color.at("primary", default: blue),
  logo: {
    let logo-info = brand-logo.at("medium", default: none)
    if logo-info != none { image(logo-info.path, alt: logo-info.at("alt", default: none)) }
  },
  outline-depth: 3,
  supplement-chapter: "Chapter",
)


// Reset Quarto's custom figure counters at each chapter (level-1 heading).
// Orange-book only resets kind:image and kind:table, but Quarto uses custom kinds.
// This list is generated dynamically from crossref.categories.
#show heading.where(level: 1): it => {
  counter(figure.where(kind: "quarto-float-fig")).update(0)
  counter(figure.where(kind: "quarto-float-tbl")).update(0)
  counter(figure.where(kind: "quarto-float-lst")).update(0)
  counter(figure.where(kind: "quarto-callout-Note")).update(0)
  counter(figure.where(kind: "quarto-callout-Warning")).update(0)
  counter(figure.where(kind: "quarto-callout-Caution")).update(0)
  counter(figure.where(kind: "quarto-callout-Tip")).update(0)
  counter(figure.where(kind: "quarto-callout-Important")).update(0)
  counter(math.equation).update(0)
  it
}

#box(image("20260816074244.png"))

In certain situations, the tax payable on the disposal of an asset may be reduced or a gain may be delayed by claiming capital gains tax reliefs. The main reliefs available to individuals are as follows:

#box(image("20260816074541.png"))

= Private residence relief (PRR)
<private-residence-relief-prr>
PRR applies when an individual disposes of:

- a dwelling house (including normally up to half a hectare of adjoining land)
- which has at some time during their ownership been their only or main private residence.

The relief applies where the main residence has been occupied for either the whole or part of the period of ownership.

#box(image("20260816075843.png"))

== Calculating the relief
<calculating-the-relief>
Where there has been a period of absence from the main residence the procedure is:

+ Calculate the gain on the disposal of the property.
+ Compute the total period of ownership.
+ Calculate the periods of occupation (covered below).
+ Calculate the PRR as follows:

Gain × (Periods of occupation/Total period of ownership)

#block[
#set enum(numbering: "1.", start: 5)
+ Deduct the PRR from the gain on the property.
]

#strong[#emph[Periods of occupation]] \ The period of occupation includes periods of #strong[both actual occupation and deemed occupation].

Periods of deemed occupation are:

A. the #strong[#emph[last nine months]] of ownership (always exempt, unconditionally as long as the dwelling has been the main residence at some point) B. up to #strong[three years] of absence for any reason C. any period spent living #strong[overseas] due to employment D. up to four years of absence as a result of working elsewhere in the UK (employed or self-employed).

#block[
#callout(
body: 
[
The absences in (b) to (d) must be preceded and #emph[followed by a period of actual occupation].

The condition to reoccupy the property after the period of absence does not need to be satisfied for (c) and (d) where an employer requires the individual to work elsewhere immediately, thus making it impossible to resume occupation.

However, they have said that you should provide brief explanatory notes for periods of deemed occupation in PRR questions, and that such explanations will earn marks.

]
, 
title: 
[
Note
]
, 
background_color: 
rgb("#dae6fb")
, 
icon_color: 
rgb("#0758E5")
, 
icon: 
fa-info()
, 
body_background_color: 
white
)
]
#strong[#emph[Ownership of more than one residence]] \ Where there is ownership of more than one residence, the individual is entitled to nominate which of them is to be treated as the main residence for capital gains tax purposes by notifying HM Revenue & Customs (HMRC) in writing.

The election must be made #emph[within two years] of acquiring an additional residence, otherwise it is open to HMRC, as a question of fact, to decide which residence is the main residence.

A married couple or those in a civil partnership can only have one PRR between them, despite being separate taxpayers.

==== Example 1: Private residence relief
<example-1-private-residence-relief>
On 1 May 1998 Karim purchased a house in Southampton for #strong[£25,000]. He occupied the house as follows:

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Period], [Months],),
  table.hline(),
  [Lived in the house], [14],
  [Lived in a rental property in Southampton], [27],
  [Employed overseas], [12],
  [Lived with relatives], [4],
  [Lived in the house], [161],
  [Lived in a rental property in Newcastle], [115],
)
Karim remained in the rental property in Newcastle until he sold his Southampton house on 1 February 2026 for #strong[£95,000].

#strong[Calculate the chargeable gain after reliefs, if any, arising on the disposal of the house on 1 February 2026.]

#strong[Solution]

#strong[#emph[Chargeable gain for Private residence]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Sale proceeds], [95,000],
  [Less: Cost], [\(25,000)],
  [#strong[Gain]], [#strong[70,000]],
  [Less: Principal Private Residence Relief (W)], [\(47,718)],
  [#strong[Chargeable gain after reliefs]], [#strong[22,282]],
)
#strong[#emph[Working -- Chargeable and exempt periods of ownership]]

#table(
  columns: (66.27%, 9.64%, 9.64%, 14.46%),
  align: (auto,auto,auto,auto,),
  table.header([Period], [Total], [Exempt], [Chargeable],),
  table.hline(),
  [#strong[Lived in house] (actual occupation)], [14], [14], [],
  [#strong[Lived in Southampton rental] (absent -- any reason)], [27], [27], [],
  [#strong[Employed overseas] (absent -- employed abroad)], [12], [12], [],
  [#strong[Lived with relatives] (absent -- any reason)], [4], [4], [],
  [#strong[Lived in house] (actual occupation)], [161], [161], [],
  [#strong[Lived in Newcastle rental] (absent -- note 1)], [106], [], [106],
  [#strong[Lived in Newcastle rental] (final 9 months)], [9], [9], [],
  [#strong[Number of months]], [#strong[333]], [#strong[227]], [#strong[106]],
)
#strong[Total period of ownership (106 + 227) = 333 months.]

#strong[Exempt element of gain = (£70,000 × 227/333) = £47,718.]

#quote(block: true)[
n1: After Karim left his residence to live in Newcastle #strong[he never returned]. Consequently, the exemption for the #strong[remaining 5 months] (36 months -- 27 months -- 4 months) for 'any reason' is not available as there #emph[was not actual occupation both before and after the period] of absence.
]

In contrast, the final nine months of ownership is always exempt unconditionally, as long as the dwelling has been the taxpayer's main residence at some point, so there is no such restriction.

Where a chargeable gain arises on a residential property, but is not fully covered by PRR, then the gain is chargeable at CGT rates of #strong[18% or 24%] depending on the level of the taxpayer's taxable income and a payment on account will be due.

==== Example 2: Private residence relief
<example-2-private-residence-relief>
Andrea bought a house on 1 January 2004 and sold it on 30 September 2025 making a #strong[gain] of #strong[£189,000].

She occupied the house as follows:

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Period], [Months],),
  table.hline(),
  [Lived in the house], [24],
  [Employed overseas], [78],
  [Travelled the world], [66],
  [Lived in the house], [93],
)
Andrea made no other disposals in the tax year 2025/26 and had taxable income of #emph[£30,700].

#strong[Calculate Andrea's capital gains tax liability for the tax year 2025/26 assuming all available reliefs are claimed.]

#strong[Solution]

#strong[#emph[Business use]] \ Where a house, or part of it, is used wholly and exclusively for business purposes, #strong[#emph[this part loses its PRR and becomes taxable.]] It should be noted that:

- The taxpayer cannot benefit from the rules of deemed occupation for any part of the property used for business purposes.
- However, where part of the property was used for business purposes but was also at any time used as the taxpayer's main residence, the exemption for the last nine months applies to the whole property.
- The nine month exemption does not however apply to any part of the property used for business purposes throughout the whole period of ownership.

==== Example 3: Private residence relief
<example-3-private-residence-relief>
On 30 June 2025 Alex sold his house for £125,000, resulting in a capital gain of #strong[£70,000]. The house had been purchased on 1 July 2011, and #strong[#emph[one of the five rooms had always been used for business purposes]].

Calculate the #strong[chargeable gain] after reliefs arising on the disposal of the house.

#strong[Solution]

Alex owned the house for 14 years and used 1/5th of the house (one of the five rooms) for business purposes. The #strong[#emph[nine month exemption does not apply to the part of the property used for business purposes]] as it has never been used at any time for private purposes.

The chargeable gain is therefore: (£70,000 × 1/5) = £14,000

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Chargeable gain before reliefs], [70,000],
  [Less: PRR (£70,000 × 4/5)], [\(56,000)],
  [#strong[Chargeable gain after reliefs]], [#strong[14,000]],
)
==== Example 4: Private residence relief
<example-4-private-residence-relief>
On 30 September 2025 Hessa sold her house for £150,000, resulting in a chargeable gain before reliefs of #strong[£60,000]. The house had been purchased on 1 October 2016, and #strong[#emph[one of the seven rooms had always been used for business purposes]].

Calculate the chargeable gain after reliefs arising on the disposal of the house.

#strong[Solution]

In the TX examination, whilst you could be asked to calculate a chargeable gain after reliefs for a private residence that has also been used for commercial purposes, you will not be expected to calculate the capital gains tax liability for such a mixed use property.

#strong[#emph[Letting relief]] \ Letting relief is available where an individual's main residence is let out for residential use. \ It only applies when the owner lets part of the property whilst still occupying the remainder. However, if the owner has a lodger who lives as a member of the owner's family, sharing the accommodation and taking meals with them, then full PRR will be available and letting relief will not be considered.

Letting relief does not apply to a let property that is not the owner's main residence (e.g.~buy-to-let properties), or to main residences that are subsequently fully let out.

Letting relief is the lowest of:

+ £40,000
+ the amount of the gain exempted by the normal PRR rules
+ the part of the gain (still in charge) attributable to the letting period.

==== Example 5: Letting relief
<example-5-letting-relief>
Nicholas bought a house in Luton on 1 June 1999. He occupied the house as follows:

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Period], [Months],),
  table.hline(),
  [Lived in the house], [12],
  [Travelled the world], [84],
  [Lived in the house], [217],
)
Nicholas rented out #strong[one quarter of his house] in the #strong[#emph[final period of occupation]]. The tenant did not share any living space with Nicholas. He sold the house on 1 July 2025 realising a chargeable gain before reliefs of #strong[£209,730].

#strong[Calculate the chargeable gain after reliefs arising on the sale of the house.]

#strong[Solution]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Chargeable gain before reliefs], [209,730],
  [Less: PRR (W1)], [\(142,724)],
  [#strong[Chargeable gain after PRR]], [#strong[67,006]],
  [Less: Letting relief (W2)], [\(34,843)],
  [#strong[Chargeable gain after reliefs]], [#strong[32,163]],
)
#strong[\(Workings 1 PRR)]

#table(
  columns: (60.56%, 11.27%, 11.27%, 16.9%),
  align: (auto,auto,auto,auto,),
  table.header([Period], [Total], [Exempt], [Chargeable],),
  table.hline(),
  [#strong[Lived in house]], [12], [], [],
  [Actual occupation], [], [12], [],
  [#strong[Travelled the world]], [84], [], [],
  [3 years -- any reason], [], [36], [],
  [Rest of period -- chargeable], [], [], [48],
  [#strong[Lived in house]], [217], [], [],
  [Last 9 months], [], [9], [],
  [Rest of period:], [], [], [],
  [-- 3/4 actual occupation], [], [156], [],
  [-- 1/4 let \*], [], [], [52],
  [#strong[Total months]], [#strong[313]], [#strong[213]], [#strong[100]],
)
#quote(block: true)[
- 1/4 let = (217 - 9) × 1/4
]

#strong[PRR = (£209,730 × 213/313) = £142,724]

#strong[\(Workings 2 letting relief)]

One quarter of the house was let in the final chargeable period and therefore, letting relief is available for this period.

Letting relief = lowest of:

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Relief type], [£],),
  table.hline(),
  [1. Maximum], [40,000],
  [2. PRR], [142,724],
  [3. Gain on letting (£209,730 × 52/313)], [34,843],
  [#strong[Letting relief]], [#strong[34,843]],
)
An alternative working for the gain on letting is (£67,006 × 52/100) = £34,843. This uses the gain after PRR and only the chargeable months. Either method would be acceptable in the exam.

==== Example 6: Letting relief
<example-6-letting-relief>
On 30 September 2025, Eleni made a gift of a house to her grandson, Kostas. The house had been bought by Eleni on 1 September 2012 for £45,000 and was extended at a cost of £10,600 during June 2013. A market value of £140,000 at 30 September 2025 had been agreed by HMRC.

Eleni occupied the house as her main residence until 30 September 2021 a period of 109 months. During this period, Eleni rented out one third of the house for 96 months. The tenant did not share any living space with Eleni.

Eleni then went to live with her sister for the remaining 48 months, until 30 September 2025.

Calculate the chargeable gain after reliefs arising on the gift.

#strong[Solution]

==== Example 7: Letting relief
<example-7-letting-relief>
On 31 August 2025, Puja sold her house, realising a gain of #strong[£50,600]. \ Puja had bought the house on 1 September 2020 and occupied the house as her main residence for the whole period of ownership.

From 1 September 2024, Puja rented out a room in the house to a tenant, who was free to use any part of the house and who took meals with Puja.

#strong[Calculate the chargeable gain after reliefs arising on the disposal of the house.]

#strong[Solution]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Chargeable gain], [50,600],
  [Less: PRR], [\(50,600)],
  [#strong[Chargeable gain after reliefs]], [#strong[0]],
)
#strong[Note:] Puja occupied the property for the entire period of ownership, meaning that the whole period is exempt. Since the tenant had access to the whole property and shared meals with Puja, letting relief is not required, as full PRR is still available.

= Business asset disposal relief
<business-asset-disposal-relief>
The rate of tax on disposals of business assets which qualify for business asset disposal relief (BADR) is #strong[#emph[14%]].

The relief operates as follows:

+ The #strong[first £1 million of gains] on 'qualifying business disposals' is taxed at #strong[14%], regardless of the level of the taxpayer's income.

+ Any gains above the £1 million limit are #emph[taxed at the usual rate depending on the individual's taxable income].

+ Gains qualifying for BADR #emph[are set against any unused basic rate band (BRB)] before non-qualifying gains.

+ The 14% CGT rate is calculated after the deduction of:

  - allowable losses, and
  - the AEA.

  However, the taxpayer can choose to set losses (other than any losses on assets that are part of the disposal of the business) and the AEA against non-qualifying gains first, in order to maximise the relief.

+ It is therefore helpful to keep gains which qualify for BADR separate from those which do not qualify. The relief must be claimed within #emph[12 months of the 31 January] following the end of the tax year in which the disposal is made.

For disposals in the tax year 2025/26, the relief must be claimed by 31 January 2028. \ The £1 million limit is a #strong[#emph[lifetime]] limit which is diminished each time a claim for the relief is made.

#strong[#emph[Qualifying business disposals]] \ The relief applies to the disposal of:

- the whole or a substantial part of an unincorporated trading business carried on by the individual either alone or in partnership

- assets of the individual's or a partnership's trading business that has now ceased

- shares; provided:

  - the shares are in the individual's 'personal trading company', and
  - the individual is an #strong[employee] of the company (part-time or full-time).

For the purposes of the TX examination an individual's 'personal trading company' is one in which the individual:

- owns at least #strong[5%] of the ordinary shares
- which carry at least #strong[5%] of the voting rights.

#block[
#callout(
body: 
[
Note that:

- the disposal of an individual business asset used for the purposes of a continuing trade does not qualify. #strong[#emph[There must be a disposal of the whole of the trading business or a substantial part (meaning part of the business which is capable of separate operation).]] The #emph[sale of an asset in isolation does not qualify].
- Where the disposal is a disposal of assets (i.e.~not shares), relief is not available on gains arising from the disposal of those assets held for #emph[investment purposes].
- There is no requirement to restrict the gain qualifying for relief on shares by reference to any non-business assets held by the company.
- There are no minimum working hours for an employee to qualify.

]
, 
title: 
[
Note
]
, 
background_color: 
rgb("#dae6fb")
, 
icon_color: 
rgb("#0758E5")
, 
icon: 
fa-info()
, 
body_background_color: 
white
)
]
#strong[#emph[Qualifying ownership period]] \ In the case of the disposal of a business it must have been owned by the individual making the disposal in the #strong[two years] prior to the disposal.

In the case of shares the individual must have been an #strong[employee] of the company and the company must have been their personal trading company for at least #strong[two years] prior to the disposal.

Where the disposal is an asset of the individual's or the partnership's trading business that has now ceased, the business must have been owned for at #emph[least two years prior to the date of cessation] and the disposal of the asset must also take place #emph[within three years of the cessation of trade].

==== Example 1: Business asset disposal relief
<example-1-business-asset-disposal-relief>
In the tax year 2025/26, Katie sold her #strong[trading business] which she set up in 2013 and realised the following gains and losses:

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Asset], [£],),
  table.hline(),
  [Factory], [275,000],
  [Goodwill], [330,000],
  [Warehouse], [\(100,000)],
  [Commercial investment property], [191,000],
)
Katie also sold her shares in an unquoted trading company and realised a gain of #strong[£400,000]. She owned 25% of the ordinary shares of the company, which she purchased #emph[ten years ago]. She has #strong[worked] for the company on a part time basis for the last three years.

Katie has not made any other capital disposals in the tax year 2025/26, but she has #strong[#emph[capital losses brought forward of £7,800]]. She has never claimed any BADR in the past.

Her only source of income is a trading profit of #strong[£43,920].

Calculate Katie's capital gains #strong[tax payable] for the tax year 2025/26.

#strong[Solution]

#table(
  columns: (45.88%, 24.71%, 29.41%),
  align: (auto,auto,auto,),
  table.header([], [Qualifying for BADR], [Not qualifying for BADR],),
  table.hline(),
  [Sale of investment property], [], [191,000],
  [#strong[Sale of trading business:]], [], [],
  [Factory], [275,000], [],
  [Goodwill], [330,000], [],
  [Warehouse (Note 2)], [\(100,000)], [],
  [#strong[Total trading business]], [#strong[505,000]], [],
  [Sale of trading company shares], [400,000], [],
  [#strong[Total gains before reliefs]], [#strong[905,000]], [#strong[191,000]],
  [Less: AEA (Note 3)], [0], [\(3,000)],
  [Less: Capital losses b/f (Note 3)], [0], [\(7,800)],
  [#strong[Taxable gains]], [#strong[905,000]], [#strong[180,200]],
)
#strong[#emph[Capital gains tax]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Qualifying gains (£905,000 × 10%)], [90,500],
  [Non-qualifying gains (£180,200 × 24%) (Note 4)], [43,248],
  [#strong[Total CGT payable]], [#strong[133,748]],
)
#quote(block: true)[
#strong[#emph[n4:]] that there is no need to calculate the remaining BR band because even if Katie had no taxable income, the gains qualifying for BADR are \> £37,700, therefore the non-qualifying gains must all be taxed at 24%.
]

#quote(block: true)[
#strong[#emph[n3:]] Capital losses and the AEA are first set against gains not qualifying for BADR.
]

==== Example 2: Business asset disposal relief
<example-2-business-asset-disposal-relief>
Luka disposed of a business in November 2025, realising a net chargeable gain of £660,000. He had started the business in January 2016 and has used all the chargeable assets for business use throughout the period of ownership.

He has previously claimed BADR for qualifying gains of £400,000. He also disposed of a holiday home in February 2026, realising a chargeable gain of £11,900. The home had never been his main residence.

Luka had taxable income of £40,000 in the tax year 2025/26.

Calculate Luka's capital gains tax payable for the tax year 2025/26.

#strong[Solution]

==== Example 3: Business asset disposal relief
<example-3-business-asset-disposal-relief>
In the tax year 2025/26 Ari sold shares in Dual Ltd, an unquoted trading company, and realised a gain of £43,000. Ari has worked for Dual Ltd for eight years and has owned 10% of the ordinary shares of the company for the last five years.

Ari set up a trading business in 2019 and in the tax year 2025/26 they sold a warehouse used in the business, realising a gain of £243,000.

Ari's trading profit was £38,270 in the tax year 2025/26. They did not have any other taxable income.

In the tax year 2026/27 Ari sold the rest of the business and realised the following gains:

- Factory: £649,500
- Goodwill: £6,700

Ari also sold an antique table in the tax year 2026/27 and realised a chargeable gain of £3,225.

Ari's trading profit in the tax year 2026/27 was £51,620, and prior to the tax year 2025/26 Ari has claimed BADR of £350,000.

#strong[Calculate Ari's CGT payable for the tax years 2025/26 and 2026/27.]

Assume that the AEA and rates for the tax year 2025/26 continue in the future.

#strong[Solution]

= Investors' relief
<investors-relief>
BADR is only available on a disposal of shares if the shares are in the individual's personal trading company (i.e.~the individual holds 5% of the shares) and the individual is also an officer or employee of the company.

Investors' relief (IR) #strong[extends] the benefits of BADR to certain investors who do not meet the conditions for BADR.

IR applies to the disposal of:

- #strong[unlisted] ordinary shares in a trading company (including AIM shares).
- #strong[subscribed] for (i.e.~newly issued shares).
- which have been held for a #strong[#emph[minimum period of three years]].
- by an individual that #strong[is not an employee] of the company.

IR is subject to a separate lifetime limit of £1 million of qualifying gains, which are taxed at 14%.

==== Example 1: Investors' relief
<example-1-investors-relief>
Alma #strong[subscribed] for 50,000 £1 ordinary shares in Artwell Ltd, an #strong[unquoted] trading company, in June 2022, at their par value.

She needed to raise funds to start her own business so she sold all the shares in Artwell Ltd in January 2026 for #strong[£140,700].

Alma has #strong[never worked] for Artwell Ltd and is a #emph[higher rate taxpayer]. Alma has not previously claimed investors' relief.

#strong[Calculate Alma's capital gains tax payable for the tax year 2025/26.]

#strong[Solution]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Sale proceeds], [140,700],
  [Less: Cost], [\(50,000)],
  [#strong[Chargeable gain]], [#strong[90,700]],
  [Less: AEA], [\(3,000)],
  [#strong[Taxable gains]], [#strong[87,700]],
)
#strong[#emph[Capital gains tax]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([#strong[CGT payable]], [],),
  table.hline(),
  [Qualifying gains for IR (£87,700 × 14%)], [#strong[12,278]],
)
#quote(block: true)[
Alma can claim investors' relief on the sale as she subscribed for shares, in an unlisted trading company, and has held them for #strong[more than three years]. Additionally, she has never worked for Artwell Ltd.
]

==== Example 2: Investors' relief
<example-2-investors-relief>
Dwight subscribed for 95,000 £1 ordinary shares in Dart Ltd, at par value, on 1 November 2022.

Dwight purchased a 6% shareholding in Beta Ltd in June 2023 for £40,000.

In December 2025 Dwight sold the shares in Dart Ltd for £150,000 and the shares in Beta Ltd for £54,000.

Both companies are unquoted trading companies and Dwight has never worked for either company.

Dwight has not previously claimed investors' relief or business asset disposal relief and had taxable income of £60,000 in 2025/26.

Calculate Dwight's CGT liability for 2025/26.

#strong[Solution]

= Replacement of business asset relief (Rollover relief)
<replacement-of-business-asset-relief-rollover-relief>
Rollover relief (ROR) allows the gain arising on the disposal of a qualifying business asset to be rolled over (i.e.~#strong[deferred]) when the sale proceeds are #strong[reinvested] in a #strong[replacement] qualifying business asset.

The relief is available to both #strong[#emph[individuals and companies]].

== The relief 'Rollover / Deferred'
<the-relief-rollover-deferred>
The relief operates as follows:

- The gain arising on the disposal of the #strong[qualifying business asset] is deducted from (rolled over against) the acquisition cost of the #strong[replacement asset].

- Provided the net sale proceeds are fully reinvested, no tax is payable at the time of the disposal.

- ROR effectively increases the gain arising on the disposal of the replacement asset, as its base #strong[cost is reduced] by the amount of deferred gain.

- Gains may be 'rolled over' a number of times such that a tax liability will only arise when there is a disposal without replacement.

- When the deferred gain crystallises, it is taxed at the appropriate CGT rate applicable at that time (not the rate applicable at the time of the deferral).

- The relief is not automatic, it must be claimed.

- An individual must claim the relief within 4 years of the later of the end of the tax year in which the:

  - disposal is made, and
  - replacement asset is acquired.

- A disposal in the tax year 2025/26 which is reinvested in a new asset in the tax year 2026/27 requires a claim by 5 April 2031.

==== Example 1: Rollover relief
<example-1-rollover-relief>
Anaya purchased an asset qualifying for ROR in January 2008 for #strong[£160,000]. In August 2025, she sold the asset for #strong[£180,000] and spent £200,000 in November 2025 on a new qualifying asset.

#strong[Calculate the chargeable gain arising on the disposal of the asset assuming that ROR is claimed.]

#strong[Calculate the base cost of the new asset acquired.]

#strong[Solution]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([#strong[Gain on disposal of asset]], [£],),
  table.hline(),
  [Sale proceeds], [180,000],
  [Less: Cost], [\(160,000)],
  [#strong[Gain before ROR]], [#strong[20,000]],
  [Less: ROR (deferred gain)], [\(20,000)],
  [#strong[Chargeable gain]], [#strong[0]],
)

#horizontalrule

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([#strong[Base cost of new asset]], [£],),
  table.hline(),
  [Acquisition cost], [200,000],
  [Less: ROR (deferred gain)], [\(20,000)],
  [#strong[Revised base cost]], [#strong[180,000]],
)
== Conditions
<conditions>
To qualify for ROR, there must be a disposal of, and reinvestment in, a #emph[qualifying business asset], within the #emph[qualifying time period]. The replacement asset must be brought into business use when it is acquired. Qualifying business assets The main categories of assets qualifying for ROR on a disposal by an #strong[#emph[individual]] are:

- goodwill
- land and buildings
- fixed plant and machinery (i.e.~not movable).

Both the old and the replacement assets must be qualifying business assets which are used in the trade.

== Qualifying time period
<qualifying-time-period>
The replacement assets must be acquired within a period:

- beginning one year before, and
- ending three years after #strong[#emph[the date of sale of the old asset]].

==== Example 2: Rollover relief
<example-2-rollover-relief>
Jenna purchased a warehouse in February 2014 for #strong[£170,000]. In July 2025, she sold the warehouse for #strong[£300,000]. She used the warehouse for the purposes of her trade throughout the period of ownership.

In December 2027 Jenna bought a new warehouse for #strong[£360,000] for the purposes of her trade. She plans to sell the warehouse in January 2029 for £550,000.

#strong[Calculate the chargeable gains arising on the two sales assuming rollover relief is claimed.]

#strong[Solution]

#strong[#emph[First warehouse -- July 2025 -- 2025/26]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Sale proceeds], [£],),
  table.hline(),
  [Less: Cost], [\(170,000)],
  [#strong[Total gain before relief]], [#strong[130,000]],
  [Less: ROR (Note)], [\(130,000)],
  [#strong[Chargeable gain]], [#strong[0]],
)
#strong[Note:]

- The full gain of £130,000 can be rolled over (i.e.~deferred) as:
  - the asset disposed of is a qualifying business asset
  - the replacement asset is a qualifying business asset
  - the reinvestment has been made in December 2027 (i.e.~within the qualifying period of July 2024 to July 2028)
  - the amount reinvested exceeds the sale proceeds received (i.e.~purchase price of new warehouse of £360,000 exceeds the sale proceeds of £300,000).

#strong[#emph[Second warehouse -- January 2029 -- 2028/29]]

#table(
  columns: (62.96%, 18.52%, 18.52%),
  align: (auto,auto,auto,),
  table.header([], [£], [£],),
  table.hline(),
  [Sale proceeds], [], [550,000],
  [#strong[Less: Base cost]], [], [],
  [Cost], [360,000], [],
  [Less: ROR], [\(130,000)], [],
  [#strong[Total base cost]], [], [#strong[\(230,000)]],
  [#strong[Chargeable gain]], [], [#strong[320,000]],
)
#strong[Note:] This gain can also be rolled over (i.e.~deferred) if a qualifying replacement asset is purchased in the qualifying time period.

However, assuming the gain is not rolled over, it will be taxed in the tax year 2028/29 at 18% or 24% depending on the level of taxable income in that tax year.

The gain does not qualify for #strong[BADR] as this is the disposal of an individual asset used for the purposes of a #strong[continuing business]. The business itself is not being disposed of.

==== Example 3: Rollover relief
<example-3-rollover-relief>
Feng acquired a freehold commercial building in April 2007. In May 2010 he sold the building for £100,000 and realised a gain of £56,360. In August 2011, he bought another freehold commercial building for £140,000 and this was sold in November 2025 for £380,000.

All of the buildings were used for the purposes of a trade by Feng.

Calculate the chargeable gain that arises in the tax year 2025/26, assuming rollover relief was claimed on the sale of the first building.

#strong[Solution]

#block[
#callout(
body: 
[
#strong[#emph[Partial reinvestment of proceeds]] \ Full ROR is only available when all of the net sale proceeds from the sale of the old asset are reinvested.

Where there is partial reinvestment of the proceeds, part of the gain is chargeable at the time of the disposal.

The gain that is chargeable (cannot be rolled over) is the lower of:

+ the amount of the proceeds not reinvested
+ the full gain.

]
, 
title: 
[
Caution
]
, 
background_color: 
rgb("#ffe5d0")
, 
icon_color: 
rgb("#FC5300")
, 
icon: 
fa-fire()
, 
body_background_color: 
white
)
]
==== Example 4: Rollover relief
<example-4-rollover-relief>
Sherifa bought a factory in September 2008 and in December 2025, wishing to move to a more convenient location, she sold the factory for £750,000. The cost of the factory was £635,000.

Sherifa moved into a rented factory until March 2026 when she purchased and moved into a new factory.

Calculate the amount of the gain, which is chargeable, if any, on the sale of the original factory and calculate the base cost of the new factory assuming the new factory was purchased for:

#block[
#set enum(numbering: "(a)", start: 1)
+ £700,000, or \
+ £550,000
]

#strong[Solution]

#block[
#callout(
body: 
[
#strong[#emph[Non-business use]] \ Full ROR is only available where the old asset being replaced was used entirely for trade purposes throughout the trader's period of ownership.

Where this condition is not met, ROR is still available but it is #strong[scaled down in proportion to the non-trade use].

]
, 
title: 
[
Note
]
, 
background_color: 
rgb("#dae6fb")
, 
icon_color: 
rgb("#0758E5")
, 
icon: 
fa-info()
, 
body_background_color: 
white
)
]
==== Example 5: Rollover relief
<example-5-rollover-relief>
Robert acquired a freehold commercial building in April 2006 for #strong[£65,500]. He only used #strong[#emph[60% of the freehold building for the purposes of his trade]]. The building was sold in November 2025 for #strong[£162,000].

A replacement building was acquired in January 2025 for #strong[£180,000] and this was used 100% for trade purposes by Robert.

The replacement building was sold for #strong[£250,000] in May 2026.

Calculate the gain rolled over and the chargeable gains arising on the disposals in November 2025 and May 2026.

#strong[Solution]

#strong[#emph[First building -- November 2025 -- 2025/26]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Sale proceeds], [162,000],
  [Less: Cost], [\(65,500)],
  [#strong[Chargeable gain before reliefs]], [#strong[96,500]],
)

#horizontalrule

#strong[Note:] The asset disposed of is a qualifying business asset for ROR purposes, but as only 60% of the building has been used for trade purposes, the gain eligible for ROR must be restricted to 60%.

#table(
  columns: (32.5%, 32.5%, 35%),
  align: (auto,auto,auto,),
  table.header([], [Business portion (60%)], [Non-business portion (40%)],),
  table.hline(),
  [Split of chargeable gain], [57,900], [38,600],
  [Less: ROR (Note)], [\(57,900)], [\(n/a)],
  [#strong[Chargeable gain]], [#strong[0]], [#strong[38,600]],
)
#strong[Note:] \ - the replacement asset is a qualifying business asset, used 100% for the purposes of the trade. \ - the reinvestment has been made in January 2025 (i.e.~within the qualifying period of November 2024 to November 2028). \ - the amount reinvested for the purposes of the trade (i.e.~purchase price of new building of £180,000) exceeds the sale proceeds received on the first building relating to the trade use of the building (i.e.~£162,000 × 60% = £97,200). \ - therefore ROR is available on all of the business portion of the gain.

#horizontalrule

#strong[#emph[Sale of replacement building -- May 2026 -- 2026/27]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Sale proceeds], [£],),
  table.hline(),
  [Less: Base cost], [],
  [Cost], [180,000],
  [Less: ROR], [\(57,900)],
  [#strong[Total base cost]], [#strong[\(122,100)]],
  [#strong[Chargeable gain]], [#strong[127,900]],
)
#strong[Note:] \ Assuming there is no replacement of this asset and the rates of CGT remain unchanged, the gains in the tax years 2025/26 and 2026/27 will be taxed at 18% or 24% depending on the level of taxable income in those years.

The gains do not qualify for BADR as the disposal of an individual asset used for the purposes of a continuing business does not qualify. The business itself is not being disposed of.

==== Example 6: Rollover relief
<example-6-rollover-relief>
Hadley purchased a factory in November 1999 and not needing all the space, he let out 15% of it.

In August 2025 he sold the factory for £560,000 and realised a capital gain of £45,000.

In October 2025 Hadley bought another factory, for £500,000, which he used 100% for business purposes. He claimed ROR.

#block[
#set enum(numbering: "(a)", start: 1)
+ Calculate the chargeable gain arising on the disposal in August 2025. \
+ Calculate the base cost of the new factory.
]

#strong[Solution]

== Depreciating assets
<depreciating-assets>
ROR is modified where the new asset is a #emph[depreciating asset]:

If the replacement asset acquired is a #strong[depreciating asset], the gain cannot be rolled over. Instead, it is #strong[deferred] until the earliest of the following three events:

+ Disposal of replacement asset.
+ The replacement asset ceases to be used for the purposes of the trade.
+ Ten years from the date of acquisition of the replacement asset.

- The deferred gain #strong[is not deducted] from the cost of the replacement asset.
- The deferred gain is just #strong[#emph['frozen']] and becomes chargeable on the earliest of the three events above.
- When the deferred gain crystallises, it is taxed at the appropriate CGT rate applicable at that time (not the rate applicable at the time of the deferral).
- If prior to the deferred gain crystallising, a non-depreciating asset is bought, then the original deferred gain can now be rolled over.

A depreciating asset is a #strong[wasting asset] (i.e.~with a predictable life of #strong[50 years or less]), or an asset that will become a wasting asset within ten years.

The only depreciating assets that you need to be aware of for the purposes of the TX examination are:

- Fixed plant and machinery
- #emph[Leasehold property with ≤ 60 years] remaining on the lease.

==== Example 1: Depreciating assets
<example-1-depreciating-assets>
Lily purchased a freehold factory in June 1997 for £250,000. In May 2024 she sold it for £420,000 and in June 2024 bought fixed plant and machinery for £450,000. In March 2026, Lily sold the fixed plant and machinery for £475,000.

#strong[Calculate the chargeable gains arising in the tax years 2024/25 and 2025/26 assuming Lily claims ROR relief where possible.]

#strong[Solution]

#strong[Freehold factory -- May 2024 -- 2024/25]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Sale proceeds], [420,000],
  [Less: Cost], [\(250,000)],
  [#strong[Gain before relief]], [#strong[170,000]],
  [Less: Deferred gain (Note)], [\(170,000)],
  [#strong[Chargeable gain]], [#strong[0]],
)

#horizontalrule

#strong[Note:]

- the asset disposed of is a qualifying business asset
- the replacement asset is a qualifying business asset, but is a #strong[#emph[depreciating asset]] (fixed plant and machinery)
- the reinvestment has been made in June 2024 (i.e.~within the qualifying period of May 2023 to May 2027)
- the amount reinvested (i.e.~the purchase price of the new plant and machinery of £450,000) exceeds the sale proceeds received on the factory of £420,000
- therefore all of the gain can be deferred, but the deferred gain is #strong[not] deducted from the base cost of the plant and machinery
- the gain of £170,000 is frozen and becomes chargeable on the earliest of:
  - the sale of the fixed plant and machinery (March 2026)
  - the date the plant and machinery ceases to be used in the trade (presumably March 2026)
  - ten years from the acquisition of the plant and machinery (June 2034).

#strong[#emph[Sale of plant and machinery -- March 2026 -- 2025/26]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Sale proceeds], [475,000],
  [Less: Cost], [\(450,000)],
  [#strong[Capital gain on plant and machinery]], [#strong[25,000]],
  [Plus: Deferred gain becomes chargeable], [170,000],
  [#strong[Total chargeable gains]], [#strong[195,000]],
)
#strong[Note:] Assuming there is no replacement of this asset the gains in 2025/26 will be taxed at 18% or 24% depending on the level of taxable income in that year.

The gains do not qualify for BADR as this is the disposal of an individual asset used for the purposes of a continuing business. The business itself is not being disposed of.

==== Example 2: Depreciating assets
<example-2-depreciating-assets>
Amir purchased a freehold factory in May 1999 and in May 2013 he sold it for £350,000 realising a capital gain of £150,000. In July 2015 Amir bought fixed plant and machinery for £400,000. In March 2027 Amir sold the fixed plant and machinery for £500,000.

Calculate the chargeable gains arising in respect of the sale of the freehold factory and the fixed plant and machinery, assuming Amir claims ROR where possible.

Clearly identify in which tax year the gains arise.

#strong[Solution]

= Gift of business assets -- gift holdover relief (gift relief)
<gift-of-business-assets-gift-holdover-relief-gift-relief>
The gift of an asset is a #strong[chargeable disposal], which gives rise to a capital gains tax liability for the donor. However, the donor has not received any funds with which to pay the tax.

Gift relief is referred to as gift holdover relief by the ACCA. Both terms are acceptable to use in the examination.

Gift holdover relief (GR) allows the gain arising on the gift of qualifying business assets to be held over (i.e.~#strong[deferred]) until the asset is eventually sold by the donee. The relief however is only available for:

- qualifying business assets
- gifts by individuals.

== The relief
<the-relief>
The relief operates as follows:

#block[
#block[
== 👤 Donor
<donor>
- Normal capital gain is calculated using #strong[market value] as proceeds
- The gain is #strong[not chargeable] on the donor; it is #strong[deferred] against the base cost of the asset acquired by the donee

]
#block[
== 👥 Donee
<donee>
- Acquisition cost = deemed to be #strong[market value] at the date of gift
- Base cost = Acquisition cost #strong[less] the gain deferred by the donor

]
]
- Both the donor and the donee must make a joint claim for the relief.
- For 2025/26 gifts, the claim must be made #strong[by 5 April 2030], (i.e.~#strong[within four years] from the end of the tax year in which the gift was made).

On the subsequent sale of the asset by the donee:

- the base cost is compared with the sale proceeds received to calculate the chargeable gain.
- the chargeable gain is taxed at the appropriate rate of CGT applicable when the donee disposes of the asset.
- assuming the rates of CGT remain unchanged, the gain will be taxed at: 14% if the disposal qualifies for BADR #strong[#emph[from the donee's point of view]], or usual rates (18% or 24%) depending on the level of the donee's taxable income in the year of disposal and the type of asset.

==== Example 1: Gift relief
<example-1-gift-relief>
Advik bought a business asset for #strong[£25,000] in August 2014. In August 2025 he gave it to Oti, when its market value was #strong[£40,000]. Advik and Oti have made an election to holdover any gain arising.

#strong[Show Advik's capital gains tax position on the gift to Oti and calculate Oti's base cost of the asset.]

#strong[Solution]

#strong[Advik's CGT position]

#strong[Gift to Oti -- August 2025]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Market value of asset], [40,000],
  [Less: Cost], [\(25,000)],
  [#strong[Gain before holdover]], [#strong[15,000]],
  [Less: GR (holdover relief)], [\(15,000)],
  [#strong[Advik's chargeable gain]], [#strong[0]],
)

#horizontalrule

#strong[Oti's base cost]

Oti has allowable expenditure to set against a future disposal, calculated as follows:

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Market value of asset acquired], [40,000],
  [Less: GR (holdover relief)], [\(15,000)],
  [#strong[Base cost]], [#strong[25,000]],
)
== Qualifying assets
<qualifying-assets>
The relief is only available where there is a gift of a qualifying asset. The following are the main categories of qualifying asset:

+ Assets used in the trade of:

  + the donor (i.e.~where the donor is a sole trader)
  + the donor's personal company (this extends the relief to assets owned by the individual personally but used in the donor's personal company directly for trading purposes).

+ Unquoted shares and securities of any trading company.

+ Quoted shares or securities of the donor's personal trading company.

A company qualifies as an individual's personal trading company if at least 5% of the voting rights are owned by the individual.

However, unlike BADR, there is no minimum holding period and no requirement for the individual to work for the company to qualify for GR.

== Rate of CGT -- tax planning
<rate-of-cgt-tax-planning>
The outright gift of a qualifying asset results in:

- no chargeable gain arising on the donor at the time of the gift
- a higher gain arising on the donee on the subsequent disposal of the asset by the donee.

the gain being taxed at the appropriate rate depending on:

#Skylighting(([#NormalTok("- the availability of the donee's AEA, ");],
[#NormalTok("- the availability of BADR or IR from the donee's point of view or, if not available, the level of the donee's taxable income in that tax year.  ");],));
However, claiming GR is optional, and if it is not claimed:

- the gain arising at the time of the gift is taxed on the donor
- the gain is taxed at the appropriate rate depending on the same factors from the donor's perspective.

Consequently; the donor may choose not to claim GR in order to:

#Skylighting(([#NormalTok("- crystallise a gain and utilise their AEA or a brought forward loss, and/or");],
[#NormalTok("- claim BADR or IR ");],
[#NormalTok("ensure the gain is taxed at 0% or 14% now rather than potentially at a higher rate later. ");],));
This may be advantageous if:

- the donor qualifies for BADR or IR now, but the donee will not qualify for BADR or IR when the asset is subsequently disposed of (for example on the gift of shares if the donee would not satisfy the employment condition for BADR or the subscription condition for IR)
- the donor has no other gains and therefore the AEA is available, and/or is a basic rate taxpayer whereas the donee is likely to be a higher rate taxpayer when the asset is disposed of.

#quote(block: true)[
Note that the donor and donee are independent persons and thus in the above two situations the donor may be more concerned about their own tax liability on the gift than the donee's liability on the ultimate disposal.
]

#strong[#emph[Sales at an undervalue]] \ The relief applies not just to outright gifts but also to sales for less than market value (i.e.~where there is an element of gift).

For sales at an undervalue the relief is modified as follows:

- Any #strong[#emph[proceeds received]] that exceed the original cost of the asset gifted are chargeable to CGT on the donor #strong[at the date of the gift].
- The rest of the gain may be deferred (held over).

The chargeable gain arising on the donor will be taxed at the appropriate rate depending on the same factors mentioned earlier.

==== Example 2: Gift holdover relief
<example-2-gift-holdover-relief>
Ronald bought a warehouse on 4 July 2013 for #strong[£20,000]. He gave the warehouse to his son, Regan, on 1 September 2015 when the market value was #strong[£52,000]. Ronald and Regan made a joint election to #strong[hold over any gain arising]. Regan sold the warehouse on 18 December 2025 for #strong[£95,000].

#block[
#set enum(numbering: "(a)", start: 1)
+ Calculate the gain 'held over' and the chargeable gain arising on the eventual disposal by Regan in the tax year 2025/26.

+ Calculate the gain eligible for GR and the base cost for Regan, assuming the same facts as above, but Regan pays his father on 1 September 2015:

+ £28,000 or \
]

#block[
#set enum(numbering: "(i)", start: 2)
+ £18,000.
]

#strong[Solution]

#strong[#emph[\(a) Ronald -- Capital gains computation -- 2015/16]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Deemed disposal proceeds (MV at date of gift)], [52,000],
  [Less: Acquisition cost], [\(20,000)],
  [#strong[Gain before holdover]], [#strong[32,000]],
  [Less: GR], [\(32,000)],
  [#strong[Chargeable gain]], [#strong[0]],
)
As Ronald and Regan have made a joint election, all of the gain of £32,000 can be 'held over' (i.e.~deferred) from Ronald to Regan.

Therefore there would be no chargeable gain on Ronald in the tax year 2015/16.

#strong[#emph[Regan -- Capital gains computation -- 2025/26]]

#table(
  columns: (64.56%, 17.72%, 17.72%),
  align: (auto,auto,auto,),
  table.header([], [£], [£],),
  table.hline(),
  [Sale proceeds], [], [95,000],
  [Less: Base cost], [], [],
  [Market value at date of gift], [52,000], [],
  [Less: Gain held over from Ronald], [\(32,000)], [],
  [#strong[Total base cost]], [], [#strong[\(20,000)]],
  [#strong[Chargeable gain]], [], [#strong[75,000]],
)

#horizontalrule

#strong[Note:] This gain will be taxed at 18% or 24% depending on the level of Regan's taxable income in that year. The gain does not qualify for BADR. This is because this is the gift of an individual asset, not the disposal of a whole or substantial part of a business.

#horizontalrule

#strong[#emph[\(b) Sale at undervaluation]] \ #strong[#emph[\(i) Ronald -- Capital gains computation -- 2015/16]]

#table(
  columns: (66.2%, 16.9%, 16.9%),
  align: (auto,auto,auto,),
  table.header([], [£], [£],),
  table.hline(),
  [Deemed disposal proceeds (MV at date of gift)], [52,000], [],
  [Less: Acquisition cost], [\(20,000)], [],
  [#strong[Potential gain (as before)]], [], [#strong[32,000]],
  [], [], [],
  [Actual proceeds received], [28,000], [],
  [Less: Original cost], [\(20,000)], [],
  [#strong[Excess proceeds over cost chargeable now]], [], [#strong[\(8,000)]],
  [], [], [],
  [#strong[Gain eligible to be held over]], [], [#strong[24,000]],
  [#strong[Chargeable gain '= Excess proceeds']], [#strong[8,000]], [],
)

#horizontalrule

This gain was taxed on Ronald at the rate of CGT applicable in 2015/16.

#horizontalrule

#strong[#emph[Regan -- Base cost (for future disposal)]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Deemed acquisition cost (MV at date of gift)], [52,000],
  [Less: Gain held over from Ronald], [\(24,000)],
  [#strong[Base cost]], [#strong[28,000]],
)
#strong[#emph[\(ii) Ronald -- Capital gains computation -- 2015/16]]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Deemed disposal proceeds (MV at date of gift)], [52,000],
  [Less: Acquisition cost], [\(20,000)],
  [#strong[Potential gain (as before)]], [#strong[32,000]],
  [Less: Gain eligible to be held over n1], [\(32,000)],
  [#strong[Chargeable gain]], [#strong[0]],
)
#quote(block: true)[
#strong[#emph[n1:]] Actual proceeds of £18K are less than OC of £20K ∴ the entire gain is eligible for GR.
]

#horizontalrule

#strong[Regan -- Base cost (for future disposal)]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Deemed acquisition cost (MV at date of gift)], [52,000],
  [Less: Gain held over from Ronald], [\(32,000)],
  [#strong[Base cost]], [#strong[20,000]],
)
==== Example 3: Gift holdover relief
<example-3-gift-holdover-relief>
Alice bought an industrial storage unit, which she used in her trade in May 2017 for £120,000. She gave it to her brother, Adam, on 29 June 2022 when the market value was £150,000. Alice and Adam made a joint election to holdover any gain arising. Adam sold the unit on 1 May 2025 for £180,000.

#block[
#set enum(numbering: "(a)", start: 1)
+ Calculate the gain 'held over' and the chargeable gain arising on the disposal by Adam in the tax year 2025/26. \
+ Calculate the gain eligible for gift holdover relief and the base cost for Adam if, instead of giving the asset to Adam, Alice had sold it to him for £130,000.
]

#strong[Solution]

#block[
#callout(
body: 
[
#strong[#emph[Assets not used wholly for trade purposes]] \ The relief is restricted where either:

- only part of an asset is used for trading purposes, or
- an asset is used for trading purposes for only part of the donor's period of ownership.

#strong[#emph[Assets other than shares]] \ Only the gain relating to the period that the asset was used in the trade or the part of the asset used for trading purposes is eligible for GR. \ The restriction to the relief operates in the same way as ROR where assets have not been wholly used in the trade.

]
, 
title: 
[
Tip
]
, 
background_color: 
rgb("#ccf1e3")
, 
icon_color: 
rgb("#00A047")
, 
icon: 
fa-lightbulb()
, 
body_background_color: 
white
)
]
==== Example 4: Assets not used wholly for trade purposes
<example-4-assets-not-used-wholly-for-trade-purposes>
Davina acquired a freehold commercial building in May 2016 for #strong[£160,000]. She used #strong[60%] of the freehold building in her trade for business purposes.

In September 2025 she gave the building to her son, Ben, when its market value was #strong[£250,000]. Davina and Ben signed an election to holdover the gain arising on the gift.

#strong[Calculate the gain held over and the chargeable gain arising on the gift of the building in September 2025.]

#strong[Solution]

#strong[Davina -- Capital gains computation -- 2025/26]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Market value at date of gift], [250,000],
  [Less: Acquisition cost], [\(160,000)],
  [#strong[Potential gain]], [#strong[90,000]],
  [Less: Gain eligible to be held over (60% × £90k) n1], [\(54,000)],
  [#strong[Chargeable gain (40% of £90,000)]], [#strong[36,000]],
)
#quote(block: true)[
#strong[#emph[n1:]] As only 60% of the building has been used for the purposes of a trade, the gain eligible to be held over must also be restricted to 60%.
]

#horizontalrule

#strong[Note:] This gain is taxed at 18% or 24% depending on the level of Davina's taxable income in the tax year 2025/26. The gain does not qualify for BADR. This is because this is the gift of an individual asset, not the disposal of a whole or substantial part of a business.

== Shares in a personal trading company
<shares-in-a-personal-trading-company>
Where the assets being gifted are shares; the gain eligible to be held over is restricted if:

- the shares are in the donor's personal company (i.e.~at least 5% of the voting rights are owned by the donor) -- whether quoted or unquoted, and
- the company owns #strong[#emph[chargeable non-business assets]]. In this situation the gain eligible for GR is:

$ upright("Total gain") times upright("MV of chargeable business assets (CBA)") / upright("MV of chargeable assets (CA)") $

Note that where the donor holds less than 5% of the voting rights:

- for unquoted shares -- the restriction does not apply; full relief is available
- for quoted shares -- GR is not available at all.

#strong[#emph[Chargeable assets (CA)]] \ A chargeable asset is one that, if sold, would give rise to a chargeable gain or an allowable loss (i.e.~capital assets that are chargeable).

#emph[Exempt assets such as cars are therefore excluded.]

Inventory, receivables, cash, etc. are also excluded as they are not capital assets and therefore not chargeable.

#strong[#emph[Chargeable business assets (CBA)]] \ These are chargeable assets (as defined above) that are used for the purposes of a trade. \ Chargeable business assets therefore exclude shares, securities or other assets owned by the business but held for investment purposes.

Consequences of restricting GR \ Note that if the individual disposes of shares in a personal trading company: GR is available:

- subject to the (CBA/CA) restriction above
- whether or not the individual works for the company

A chargeable gain will arise at the time of the gift on the donor as not all of the gain can be deferred

The chargeable gain will be taxed on the donor at 0%, 14%, 18% or 24% depending on:

- the availability of the donor's AEA
- the availability of BADR or IR from the donor's point of view and, if not available
  - the level of the donor's taxable income in that tax year.

==== Example 5: GR - chargeable non-business assets
<example-5-gr---chargeable-non-business-assets>
Jin Ming has been a #strong[full time working director] of Porcelain Products Ltd since 1 December 2005 and #strong[purchased 10%] of the company's ordinary shares on 1 December 2009.

He resigned from the company in 2016 but kept the shares until 1 December 2025 when he gave his 10% shareholding, #strong[valued at £950,000], to his daughter Jun Ying.

The agreed capital #strong[#emph[gain]] on the disposal of the shares was #strong[£700,000]. Jin and Jun signed an election to holdover the gain on the gift.

The market values of the assets held by the company at 1 December 2025 were:

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Asset], [Value],),
  table.hline(),
  [Land and buildings], [550,000],
  [Cars], [80,000],
  [Cash], [45,000],
  [Receivables], [35,000],
  [Inventory], [50,000],
  [Shares held as investments], [60,000],
)
#strong[Calculate Jin Ming's chargeable gain in the tax year 2025/26 and the base cost of the shares acquired by Jun Ying.]

#horizontalrule

#strong[Solution]

#strong[Jin Ming -- Capital gains computation -- 2025/26]

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([], [£],),
  table.hline(),
  [Total gain on disposal of shares], [700,000],
  [Less: GR (Working) £700,000 × (£550,000/£610,000)], [\(631,148)],
  [#strong[Chargeable gain]], [#strong[68,852]],
)

#horizontalrule

#strong[Working:]

Market value of chargeable assets (CA) = Land and buildings (£550,000) + Shares held as investments (£60,000) = #strong[£610,000]

Market value of chargeable business assets (CBA) = Land and buildings = #strong[£550,000]

#horizontalrule

#strong[Note:] The gain will be taxed at 18% or 24% depending on the level of Jin Ming's taxable income in 2025/26. The gain does not qualify for BADR because Jin Ming #strong[did not work for the company in the two years before the disposal]. The gain does not qualify for IR as Jin purchased and #strong[did not subscribe] for the shares.

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Base cost for Jun Ying], [£],),
  table.hline(),
  [Market value at date of gift], [950,000],
  [Less: GR (held over gain)], [\(631,148)],
  [#strong[Base cost]], [#strong[318,852]],
)
==== Example 6: GR - chargeable non-business assets
<example-6-gr---chargeable-non-business-assets>
Fred purchased 100% of the shares in Fred Ltd in June 2005. He worked for the company until he became unwell in October 2019, when his son stepped in and ran the company for Fred.

On 20 February 2026, Fred made a gift of his shares to his son, and this resulted in a chargeable gain of £420,000.

At the time of the gift the market value of the assets owned by Fred Ltd were as follows:

#table(
  columns: 2,
  align: (auto,auto,),
  table.header([Asset], [Value],),
  table.hline(),
  [Freehold trading premises], [£400,000],
  [Investments -- Shares in UK companies], [£100,000],
  [Inventory and work in progress], [£130,000],
  [Receivables], [£100,000],
  [Cash], [£30,000],
  [#strong[Total]], [#strong[£760,000]],
)
Calculate the amount of Fred's chargeable gain and the amount that can be held over using gift holdover relief.

#strong[Solution]

= Practices on Additional aspects
<practices-on-additional-aspects>
== Objective Test (OT) questions
<objective-test-ot-questions>
=== Q1: Rollover Relief ROR
<q1-rollover-relief-ror>
#block[
#callout(
body: 
[
Kalid purchased a freehold building in September 1999 and sold it for #strong[£550,000] in May 2025, generating a capital gain of #strong[£290,000]. He purchased a new building in February 2026 for #strong[£515,000]. \ Both buildings were used in his sole trader business.

Assuming a claim for #strong[rollover relief] is made, what amount of gain is chargeable in the tax year 2025/26?

A. £290,000 \ B. £255,000 \ #strong[C. £35,000] \ D. £0

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
=== Q2: Private Residence Relief PRR - period of her occupation
<q2-private-residence-relief-prr---period-of-her-occupation>
#block[
#callout(
body: 
[
Martha has owned her house since 1 January 2014. She moved in as soon as she bought it and occupied it until 1 January 2015 when she left to travel the world. Whilst travelling, she got married and moved to London and did not reoccupy the property. She sold the house on 1 January 2026.

In calculating the amount of #strong[#emph[private residence relief]] available to Martha, what is the #strong[period of her occupation]? \ Include periods of both actual and deemed occupation.

A. 144 months \ B. 57 months \ #strong[C. 21 months] \ D. 12 months

#strong[#emph[12 + 9]]

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
=== Q3: Rollover Relief ROR
<q3-rollover-relief-ror>
#block[
#callout(
body: 
[
Leon is a sole trader. He sold a factory in December 2025 which he had used in his business since 2009.

Leon can claim to rollover the gain on the factory against which of the following?

#strong[A. The purchase of a new factory in May 2025 which will be used in Leon's trade] B. The purchase of a commercial property in January 2026 which will be let to tenants for 7 years C. The purchase of a shop in December 2025 which will be rented by his sister D. The purchase of a new forklift truck in December 2025 for use in Leon's trade

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
=== Q4: CGT - BADR
<q4-cgt---badr>
#block[
#callout(
body: 
[
Josefine has taxable income of £18,200 for the tax year 2025/26. She also has capital gains of #strong[£17,000] on quoted shares not qualifying for business asset disposal (BADR) relief and #strong[£40,000] of gains qualifying for BADR relief.

What is her capital gains tax liability for the tax year 2025/26?

A. £8,120 \ B. £8,960 \ C. £8,660 \ #strong[D. £9,680]

#quote(block: true)[
Gains qualifying for BADR are taxed at 14%. They are #strong[deemed to use up the taxpayer's basic rate band] before the non-qualifying gains.
]

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
=== Q5: Gift Relief GR
<q5-gift-relief-gr>
#block[
#callout(
body: 
[
Paul gives an antique vase to his son for his birthday. It has a market value of £7,000.

Which of the following reliefs are available, if any?

A. Rollover relief \ B. Business asset disposal relief \ C. Gift holdover relief \ #strong[D. None of the above]

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
==== Q6: Available reliefs
<q6-available-reliefs>
#block[
#callout(
body: 
[
On 5 July 2025 David #strong[subscribed] for new ordinary shares in Gardening Ltd, an #strong[unquoted trading company]. He works for the company and his shareholding represents 4% of the company's ordinary shares. He intends to continue working for the company and to own the shares for the next 10 years when he will give the shares to his daughter.

Which of the following reliefs are available?

A. Investors' relief \ B. Business asset disposal relief \ #strong[C. Gift holdover relief] \ D. None of the above

#quote(block: true)[
Investors' relief is not available as David works for the company. Business asset disposal relief is not available as David does not own 5% of the shares.
]

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
== Objective Test Cases (OTC)
<objective-test-cases-otc>
=== Q1: Philip and Charles
<q1-philip-and-charles>
Philip and Charles are father and son. The following information is available for the tax year 2025/26.

#strong[Philip Wind] \ Philip retired at the age of 55. During the tax year 2025/26 Philip received pension income of £15,000 and building society interest of £14,600.

#strong[Charles Wind] \ Charles is self-employed, and his tax adjusted trading profit for the year ended 31 March 2026 was £112,400. \ During the tax year 2025/26 Charles made a gift aid donation of £800 (gross) to a national charity.

Charles has been a member of a personal pension scheme since May 2023. He made a gross contribution of £45,000 in the tax year 2023/24 but has not made any subsequent contributions.

==== Q1.1: Nil frist 5k Band and Nil Saving band
<q1.1-nil-frist-5k-band-and-nil-saving-band>
#block[
#callout(
body: 
[
#strong[What is Philip's income tax liability for the tax year 2025/26?]

#strong[A. £2,692] \ B. £2,892 \ C. £3,206 \ D. £3,406

#box(image("20260902123910.png"))

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
==== Q1.2: PA Tampering
<q1.2-pa-tampering>
#block[
#callout(
body: 
[
#strong[Charles is entitled to a personal allowance of £\_\_\_\_\_\_\_\_\_\_ for the tax year 2025/26.] \ Select the appropriate answer from the options below.

A. £12,570 \ B. £6,770 \ C. £6,870 \ #strong[D. £5,800]

#quote(block: true)[
\(12400-800)/2
]

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
==== Q1.3: Class 4 NIC
<q1.3-class-4-nic>
#block[
#callout(
body: 
[
#strong[What is the amount of class 4 national insurance liability in respect of Charles for the tax year 2025/26?]

#strong[3,505]

#quote(block: true)[
\(37700 \* 0.06)+((112400-50270) \* 0.02)
]

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
==== Q1.4: Available Annual Allowance AA
<q1.4-available-annual-allowance-aa>
#block[
#callout(
body: 
[
What was the total available annual allowance available to Charles for pension contribution purposes in the tax year 2025/26?

#strong[A. £135,000] \ B. £60,000 \ C. £175,000 \ D. £75,000

#quote(block: true)[
Charles has been a member of a personal pension scheme since May 2023.
]

- Tax year 2023/24 b/f AA: 60,000 - 45,000 = 15,000
- Tax year 2024/25 b/f AA: 60,000
- Tax year 2025/26 AA: 60,000 + 60,000 + 15,000 = #strong[135,000]

]
, 
title: 
[
None
]
, 
background_color: 
rgb("#e6e6e6")
, 
icon_color: 
rgb("#909090")
, 
icon: 
none
, 
body_background_color: 
white
)
]
==== Q1.5:
<q1.5>
#block[
]
== Constructed response questions
<constructed-response-questions>
=== Q1:
<q1>



#bibliography(("mdpi-template.bib"))

