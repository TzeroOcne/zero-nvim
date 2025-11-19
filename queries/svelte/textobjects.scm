;; Capture the whole snippet statement as @snippet.outer
(snippet_statement) @snippet.outer

(snippet_statement
  (snippet_start)
  (_)* @snippet.inner
  (snippet_end))
