if exists("b:current_syntax")
  finish
endif

" % tags (section headers)
syntax match NaviTag "\v^\%.*$"

" # descriptions
syntax match NaviComment "\v^\#.*$"

" ; metacomments (ignored by navi)
syntax match NaviMeta "\v^\;.*$"

" $ variable definitions
syntax match NaviVar "\v^\$.*$"

" @ extends (tag inheritance)
syntax match NaviExtends "\v^\@.*$"

" <variable> placeholders inline
syntax match NaviPlaceholder "\v\<.{-}\>"

highlight def link NaviTag      Statement
highlight def link NaviComment  Operator
highlight def link NaviMeta     Comment
highlight def link NaviVar      Type
highlight def link NaviExtends  PreProc
highlight def link NaviPlaceholder String

let b:current_syntax = "cheat"
