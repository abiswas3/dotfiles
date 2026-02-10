" Alternative: Place this file in ~/.config/nvim/after/syntax/markdown.vim
" This keeps syntax highlighting separate from your main config
" (Choose either this OR the lua config above, not both)

" Define Badgers red color scheme for theorem environments
highlight TheoremDiv guifg=#C5050C guibg=#FFE5E6 gui=bold ctermfg=160 ctermbg=224
highlight LemmaDiv guifg=#C5050C gui=bold ctermfg=160
highlight DefinitionDiv guifg=#800408 guibg=#FFC2C4 gui=bold ctermfg=88 ctermbg=217
highlight RemarkDiv guifg=#800408 gui=italic ctermfg=88
highlight QuestionDiv guifg=#FFFFFF guibg=#C5050C gui=bold ctermfg=231 ctermbg=160
highlight GoalDiv guifg=#FFFFFF guibg=#800408 gui=bold ctermfg=231 ctermbg=88
highlight FencedDivEnd guifg=#C5050C gui=bold ctermfg=160

" Match fenced div opening lines
syntax match TheoremDivOpen /^:::\s*{\.theorem\(\s.*\)\?}.*$/
syntax match LemmaDivOpen /^:::\s*{\.lemma\(\s.*\)\?}.*$/
syntax match CorollaryDivOpen /^:::\s*{\.corollary\(\s.*\)\?}.*$/
syntax match PropositionDivOpen /^:::\s*{\.proposition\(\s.*\)\?}.*$/
syntax match DefinitionDivOpen /^:::\s*{\.definition\(\s.*\)\?}.*$/
syntax match ClaimDivOpen /^:::\s*{\.claim\(\s.*\)\?}.*$/
syntax match RemarkDivOpen /^:::\s*{\.remark\(\s.*\)\?}.*$/
syntax match ProofDivOpen /^:::\s*{\.proof\(\s.*\)\?}.*$/
syntax match QuestionDivOpen /^:::\s*{\.question\(\s.*\)\?}.*$/
syntax match ProblemDivOpen /^:::\s*{\.problem\(\s.*\)\?}.*$/
syntax match GoalDivOpen /^:::\s*{\.goal\(\s.*\)\?}.*$/
syntax match FencedDivClose /^:::$/

" Link to highlight groups
highlight link TheoremDivOpen TheoremDiv
highlight link LemmaDivOpen LemmaDiv
highlight link CorollaryDivOpen LemmaDiv
highlight link PropositionDivOpen LemmaDiv
highlight link DefinitionDivOpen DefinitionDiv
highlight link ClaimDivOpen DefinitionDiv
highlight link RemarkDivOpen RemarkDiv
highlight link ProofDivOpen RemarkDiv
highlight link QuestionDivOpen QuestionDiv
highlight link ProblemDivOpen QuestionDiv
highlight link GoalDivOpen GoalDiv
highlight link FencedDivClose FencedDivEnd

" Zola shortcode regions — whole block gets a subtle background
highlight ZolaBlockBody guibg=#1e1e2e ctermfg=NONE ctermbg=234
highlight ZolaBlockDelim guifg=#585b70 guibg=#1e1e2e gui=bold ctermfg=240 ctermbg=234

syntax region ZolaBlock matchgroup=ZolaBlockDelim start=/^{%\s*theorem(.\{-})\s*%}$/ end=/^{%\s*end\s*%}$/ contains=@Spell,@markdownInline keepend
highlight link ZolaBlock ZolaBlockBody
