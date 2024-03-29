" Environment {
    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
    " }
    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }
" }

" 加载Vundles{
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" 通用设置 {
    set background=dark
    filetype plugin indent on   " 自动检测文件类型
    syntax on                   " 开启语法高亮
    scriptencoding utf-8
    set shortmess+=filmnrxoOtT          " 过滤'hit enter to continue'
    set viewoptions=folds,options,cursor,unix,slash " Unix / Windows 兼容性设置
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0]) "git commit 默认在第一行进行
    " 恢复关闭时的位置
    if has("autocmd")
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif
    " Rainbow!
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
" }

" UI设置 {
    colorscheme molokai
    set showmode                    " 显示当前
    set cursorline                  " 高亮当前行
    highlight clear SignColumn      " 光标背景
    highlight clear LineNr          " 行标背景

    if has('cmdline_info')
        set ruler                   " 显示ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " ruler格式
        set showcmd                 " 显示正在输入的指令
    endif

    if has('statusline')
        set laststatus=2
        set statusline=%<%f\                     " 文件名
        set statusline+=%w%h%m%r                 " 选项
        set statusline+=\ [%{&ff}/%Y]            " 文件类型
        set statusline+=\ [%{getcwd()}]          " 当前目录
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " 导航信息
    endif

    set backspace=indent,eol,start  " Backspace键调整
    set whichwrap=b,s,h,l,<,>,[,]   " 光标在行首行末时自动换行
    set linespace=0                 " 行间距
    set nu                          " 开启行号
    "{搜索匹配
    set showmatch                   " 匹配高亮
    set incsearch                   " 实时搜索
    set hlsearch                    " 高亮匹配项
    set ignorecase                  " 忽略大小写
    set smartcase                   " 搜索输入含大写时切换为大小写敏感
    "}
    "{ 显示多余空白字符
    set list                        
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
    "}
" }

" 格式 {
    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    " 定义函数AutoSetFileHead，自动插入文件头
    autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
    function! AutoSetFileHead()
        "如果文件类型为.sh文件
        if &filetype == 'sh'
            call setline(1, "\#!/bin/bash")
        endif
        "如果文件类型为python
        if &filetype == 'python'
            call setline(1, "\#!/usr/bin/env python")
            call append(1, "\# encoding: utf-8")
        endif
        normal G
        normal o
        normal o
    endfunc
    " 关闭时自动清除多余空格
    fun! <SID>StripTrailingWhitespaces()
        let l = line(".")
        let c = col(".")
        %s/\s\+$//e
        call cursor(l, c)
    endfun
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> : call <SID>StripTrailingWhitespaces()
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
" }

" Key Bindings {
    let mapleader = ','
    " 从光标位置复制到行末
    nnoremap Y y$
    " <leader>+/ 去除搜索高亮
    noremap <silent><leader>/ :nohls<CR>
    " ;快速进入命令行
    nnoremap ; :
" }

" Plugins {
    " Misc {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            let g:NERDShutUp=1
        endif
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> <plug>NERDTreeTabsToggle<CR>
            map <leader>n :NERDTreeFind<CR>
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
        endif
    " }

    " Tabularize {
        if isdirectory(expand("~/.vim/bundle/tabular"))
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /=<CR>
            vmap <Leader>a= :Tabularize /=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        endif
    " }

    " PyMode {
        if !has('python')
            let g:pymode = 0
        endif

        if isdirectory(expand("~/.vim/bundle/python-mode"))
            let g:pymode_lint_checkers = ['pyflakes']
            let g:pymode_trim_whitespaces = 0
            let g:pymode_options = 0
            let g:pymode_rope = 0
        endif
    " }

    " TagBar {
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
    "}

    " indent_guides {
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
    " }

    " vim-airline {
        if isdirectory(expand("~/.vim/bundle/vim-airline/"))
            let g:airline_theme = 'solarized'
            let g:airline_powerline_fonts=1
        endif
    " }

    " NeoComplete {
        hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=darkcyan
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=darkcyan cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=green ctermbg=darkcyan cterm=NONE
        let g:acp_enableAtStartup = 0
        let g:neocomplete#enable_at_startup = 1
        let g:neocomplete#enable_smart_case = 1
        let g:neocomplete#sources#syntax#min_keyword_length = 3
        let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
        let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
                \ }
        " Define keyword.
        if !exists('g:neocomplete#keyword_patterns')
            let g:neocomplete#keyword_patterns = {}
        endif
        let g:neocomplete#keyword_patterns['default'] = '\h\w*'
        " Plugin key-mappings.
        inoremap <expr><C-g>     neocomplete#undo_completion()
        inoremap <expr><C-l>     neocomplete#complete_common_string()
        " Recommended key-mappings.
        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
        " AutoComplPop like behavior.
        let g:neocomplete#enable_auto_select = 1
        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        " Enable heavy omni completion.
        if !exists('g:neocomplete#sources#omni#input_patterns')
          let g:neocomplete#sources#omni#input_patterns = {}
        endif
    " }
" }
" GUI Settings {
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
    endif
" }

" Functions {
    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
" }
