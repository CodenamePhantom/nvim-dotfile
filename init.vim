"" -------- VIM BASIC CONFIG --------

"" Nvim basic setup
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with
set cursorline              " enable line location for the cursor position
set hlsearch                " highlight search 
set incsearch               " incremental search
set visualbell              " dont make noise
set updatetime=1000         " Set the CursorHold timer to 1 second
set tabstop=2               " number of columns occupied by a tab 
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=2            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set smartindent             " smart indentation
set wrap                    " line wrap
set number                  " add line numbers
set ruler                   " add ruler
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
filetype plugin on
set laststatus=3
set signcolumn=yes

"" -------- INSTALATIONS AND IMPORT --------

"" Plugin installation and calling
call plug#begin('~/.config/nvim/plugged')
  
    Plug 'neoclide/coc.nvim'
    Plug 'OmniSharp/omnisharp-vim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'tpope/vim-fugitive'
    Plug 'dense-analysis/ale'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'akinsho/bufferline.nvim', {'tag': '*'}
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'glepnir/dashboard-nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'liuchengxu/vim-clap'
    Plug 'sonph/onehalf', {'rtp': 'vim/'}
    Plug 'pineapplegiant/spaceduck'
    Plug 'marko-cerovac/material.nvim'
    Plug 'folke/which-key.nvim'
    
call plug#end()

"" Plugin importing with LUA
lua << eof
    --Lualine configuration
    require 'lualine'.setup{
        options = {
            theme = 'material-nvim',
                disabled_filetypes = { "dashboard" }
        }
    }
    
    --Bufferline import
    require 'bufferline'.setup{
        options = {
            diagnostics = "coc",
            diagnostics_update_in_insert = true,
            offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left"}},
            separator_style = "slant"
        }
    }
    
    --web-devicons configuration
    require 'nvim-web-devicons'.setup {
        default = true
    }
    require 'nvim-web-devicons'.get_icons()

    require 'nvim-tree'.setup{
        hijack_netrw = true,
        view = {
            height = "100%", 
            width = 30,
        },
        renderer = {
            add_trailing = true,
            indent_markers = {
                enable = true
            }
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true
        }
    }

    --Nvim Treesitter configuration
    require 'nvim-treesitter.configs'.setup{
        ensure_installed = {
          "css",
          "c_sharp",
          "html", 
          "javascript",
          "java",
          "python"
        },
        sync_install = true,
        highlight = {
            enable = true
        }
    }

    --Which Key inicialization.
    require ("which-key").setup{}
eof

"" -------- TERMINAL APPEARANCE --------

"" Terminal encoding
set encoding=UTF-8

"" Nvim theme setup
let g:material_style='deep ocean'
set termguicolors
:colorscheme material
let g:clap_theme = 'material'

"" -------- DASHBOARD CONFIGURATION --------

"" Create a file explorer function for the dashboard
function! FileManager(managingType) abort
    if a:managingType == "create"
        let folder = system('zenity --file-selection --directory --save')
    elseif a:managingType == "open"
        let folder = system('zenity --file-selection --directory')
    endif
    let formatedFolder = escape(folder, " #")
    let searchCode = "ls " . formatedFolder
    let hasItens = system(searchCode)
    if formatedFolder == "" 
        echo "Canceled"
    else
        if hasItens == ""
            terminal
        else
            DashboardNewFile
        endif
        set showtabline=2
        execute 'cd' formatedFolder
        NvimTreeOpen
    endif
endfunction

command OpenFileManager call FileManager("open")
command CreateFileManager call FileManager("create")

"" SessionLoad handler
function! HandleLoad() abort
    SessionLoad
    set showtabline=2
    NvimTreeToggle
endfunction

"" Open config file
function! OpenConfig() abort
    e ~/.config/nvim/init.vim
    cd %:p:h
    set showtabline=2
    NvimTreeOpen
endfunction

"" Dashboard global configurations
let g:dashboard_default_executive='clap'
let g:dashboard_custom_section={
    \ 'open_project': {
        \ 'description': [' Open project folder                                 SPC o f'],
        \ 'command': 'OpenFileManager'
    \ },
    \ 'file_history': {
        \ 'description': [' Recently open files                                 SPC f f'],
        \ 'command': "Clap history"
    \ },
    \ 'create_project': {
        \ 'description': [' Create a new Project                                SPC c n'],
        \ 'command': 'CreateFileManager'
    \ },
    \ 'open_session': {
        \ 'description': [' Open last session                                   SPC o s'],
        \ 'command': function('HandleLoad')
    \ },
    \ 'update_plugins': {
        \ "description": [' Update installed plugins                            SPC u p'],
        \ "command": 'PlugUpdate',
    \ },
    \ 'update_lsp': {
        \ "description": [' Update installed language servers                   SPC u l'],
        \ "command": 'CocUpdate'
    \ },
    \ 'config_file': {
        \ "description": [' Open configuration file                             SPC o i'],
        \ "command": function('OpenConfig')
    \ }
\ }
let g:dashboard_custom_header = [
\'     ╓N          j╖                                                                                 ',
\'   φ╫Ñ▒Ñµ        j╫▓▄                                                                               ',
\',╦╫╫╫╫▒▒▒N       j▓▓▓▓W                                                      ▓▓▓─                   ',
\'1▒▒╫╫╫▒▒▒▒@.     j▓▓▓▓▓▌                                        ,,,      ,,, ,,,  ,,,  ,╓,    ,╓,   ',
\'╫▒▒▒▒╫▒▒▒▒▒▒µ    j▓▓▓▓▓▌      J▌╓M╙"╙▀▓µ   ▄M╙└`"╙▄   ,▄▀"╙╙╙▓▄ └▓▓▌     █▓▌ ▓▓▓─ ╫▓▓▓█▀█▓█▄▓█▀▀█▓▓ ',
\'╫▒▒▒▒▒╨╫ÑÑÑÑÑ@   j▓▓▓▓▓▌      J█       █  ▓Ö       ▓ J▌       ▐▓ ▐▓▓▄   ▓▓█  ▓▓▓─ ╫▓▓H   ▐▓▓▌   J▓▓▌',
\'╫▒▒▒▒▒  ╝ÑÑÑÑÑÑµ j▓▓▓▓▓▌      J▓       ▓  ▓ªªªªªªªª▀ ▓h        ▓H ▀▓▓µ ▓▓█   ▓▓▓─ ╫▓▓H   ▐▓▓▌    ▓▓▌',
\'╫▒▒▒▒▒   ²╫ÑÑÑÑÑ@▐▓▓▓▓▓▌      J▓       ▓  █          ▀▌        ▓   ▀▓█▐▓█    ▓▓▓─ ╫▓▓H   ▐▓▓▌    ▓▓▌',
\'╫ÑÑÑÑÑ     ╫╫╫╫╫╫╫▓▓▓▓▓▌      J▓       ▓  `▓▄     ,µ  ▀▄     ,▓╜    █▓▓▓╛    ▓▓▓─ ╫▓▓H   ▐▓▓▌    ▓▓▌',
\'╫ÑÑÑÑÑ      ╙╫╫╫╫╫▓▓▓▓▓▓       ╙       ╙    `╙╙╨╨╙      ╙╙*╜╙`       ""`     """  """    `""`    ""╙',
\'ª╫ÑÑÑÑ       `╫╫╫╫▓▓▓▓▓╨                                                                            ',
\'  ²╫╫╫         ╙╫╫▓▓▓"                                                                              ',
\'    `╝          `▓▀`                                                                                '
\]

"" Exclude indentline and bufferline from the dashboard
let g:indentLine_fileTypeExclude = ['dashboard']
autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2

"" -------- CLAP DASHBOARD AUTOMATION --------

"" Variable used to cast the initial automation of the Clap files only on
"" the initialization of the app.
let g:dashOpen=1

"" Automaticaly open a blank file if a folder is open instead of a file. If
"" the buffer is closed on the dashboard or after the initialization, the
"" automation doesn't apply.
function! BufferCheck()
    if g:dashOpen == 1
        if &filetype == 'dashboard'
            "do nothing
        else
            cd %:p:h
            NvimTreeOpen
            let g:dashOpen=0
        endif
    endif
endfunction
autocmd User ClapOnExit call BufferCheck()

nnoremap <C-l> <Plug>(coc-snippets-expand)<CR>

"" -------- COC CONFIGURATION --------

"" Default Coc language servers
let g:coc_global_extensions = [
\ 'coc-highlight',
\ 'coc-emmet',
\ 'coc-snippets',
\ 'coc-lightbulb',
\ 'coc-pairs',
\ 'coc-tsserver',
\ 'coc-tailwindcss',
\ 'coc-pyright',
\ 'coc-java',
\ 'coc-json',
\ 'coc-css',
\ 'coc-html',
\ 'coc-html-css-support'
\]

nnoremap <leader>rn <Plug>(coc-rename)


"" -------- OMNISHARP CONFIGURATION --------

"" Require dotnet core 6 processing on OmniSharp
let g:OmniSharp_server_use_net6 = 1

let g:OmniSharp_server_display_loading = 1

let g:OmniSharp_highlighting = 3

let g:OmniSharp_selector_ui = ''

let extension = expand('%:e')

    
"" -------- ALE FIXERS AND KEY MAPPINGS --------

let g:ale_disable_lsp=1
let g:ale_echo_cursor=0
let g:ale_cursor_detail=1
let g:ale_cspell_executable=''
let g:ale_hover_to_preview=1
let g:ale_cspell_use_global=0
set previewheight=3
set splitbelow

let g:ale_sign_error = ''
let g:ale_sign_warning = ''

"" Ale configuration for ESLint, prettier and python
let g:ale_fixers = {
\    'cs': ['dotnet-format'],
\    'python': ['pyright', 'autopep8'],
\    'javascriptreact': ['prettier', 'eslint'],
\    'javascript': ['prettier', 'eslint'],
\    'java': ['javac'],
\    'css': ['prettier']
\}

"" Ale Key Mapping
nnoremap <silent>\af :ALEFix<CR>

"" -------- NVIM TREE KEYMAPINGS --------

nnoremap <silent>n :NvimTreeFocus<CR>
nnoremap <C-n> :NvimTreeOpen<CR>
nnoremap <C-r> :NvimTreeRefresh<CR>
nnoremap <C-t> :NvimTreeToggle<CR>

"" -------- BUFFERLINE KEY MAPPINGS --------

nnoremap <silent>\b :BufferLineCyclePrev<CR>
nnoremap <silent>\f :BufferLineCycleNext<CR>

"" -------- MISC CONFIGS AND AUTOMATIONS --------

"" Open terminal bellow files
let g:term_buf = 0
let g:term_win = 0

function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction
nnoremap <silent>\t :call TermToggle(10)<CR>

"" Remove StatusLine from NvimTree
function! RemoveSL() abort
    let color=synIDattr(hlID("Normal"), "bg")
    execute "highlight StatusLine guibg="color "guifg="color
    execute "highlight EndOfBuffer guifg="color
endfunction
autocmd FileType dashboard call RemoveSL()

"" Switch Highlight and codeAction between Coc and OmniSharp
function! CurrentLSP() abort
    augroup AutoSave
        autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent w | echo "Auto Save" | endif
    augroup END
    if expand('%:e') == 'cs'
        echo "OmniSharp controls enabled"
        nnoremap <C-q> :OmniSharpGetCodeAction<CR>
        autocmd! OmniDoc silent OmniSharpDocumentation
        autocmd CursorMoved * silent OmniSharpHighlight
        autocmd TextChanged,InsertLeave * silent OmniSharpCodeFormat
    elseif expand('%:e') == ''
        autocmd! AutoSave
    else
        echo "CoC.nvim controls enabled"
        nnoremap <C-q> :call CocAction('codeAction', ['cursor', 'quickfix'])<CR>
        command! CocDoc silent call CocAction('doHover')
        autocmd CursorMoved * silent call CocAction('highlight')
        autocmd TextChanged,InsertLeave * silent call CocAction('format')
    endif
endfunction
autocmd BufEnter * call CurrentLSP()

"" Custom Nvim commands
command DotnetRun terminal dotnet run
