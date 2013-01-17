setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

" syntastic jslint options
let g:syntastic_javascript_jslint_conf = ""

" jsbeautify
noremap <leader>b :call JsBeautify()<cr>
