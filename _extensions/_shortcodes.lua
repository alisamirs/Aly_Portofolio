-- _shortcodes.lua
return {
  ['borderless-comparison'] = function(args, kwargs, meta)
    local left_text = kwargs['left'] or ""
    local right_text = kwargs['right'] or ""
    
    -- Replace regular newlines with LaTeX \newline commands
    left_text = string.gsub(left_text, "\n", "\\newline ")
    right_text = string.gsub(right_text, "\n", "\\newline ")

    local latex_out = [[\noindent
\begin{tabular}{@{} p{0.45\textwidth} @{\hspace{0.10\textwidth}} p{0.45\textwidth} @{}}
]] .. left_text .. " & " .. right_text .. [[ \\
\end{tabular}
\vspace{1em}]]

    if quarto.doc.is_format("pdf") then
      return pandoc.RawBlock("latex", latex_out)
    else
      -- Fallback text styling for HTML/other formats if needed
      return pandoc.Para({pandoc.Str(left_text), pandoc.Space(), pandoc.Str(right_text)})
    end
  end
}
