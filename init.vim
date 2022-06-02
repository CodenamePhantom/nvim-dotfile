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

"" -------- INSTALATIONS AND IMPORT --------

"" Plugin installation and calling
call plug#begin('~/.config/nvim/plugged')
  
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
    Plug 'folke/which-key.nvim'
    Plug 'xiyaowong/nvim-transparent'
    Plug 'christoomey/vim-tmux-navigator'

call plug#end()

"" Plugin importing with LUA
lua << eof
    --Lualine configuration
    require 'lualine'.setup{
        options = {
            theme = 'onedark',
            disabled_filetypes = { "NvimTree", "dashboard" }
        }
    }
    
    --Bufferline import
    require 'bufferline'.setup{
        options = {
            diagnostics = "coc",
            diagnostics_update_in_insert = true,
            offsets = {{filetype = "NvimTree", text = "Project Explorer", text_align = "left"}},
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
            hide_root_folder = true,
            height = "100%", 
            width = 30,
        }
    }

    --Nvim Treesitter configuration
    require 'nvim-treesitter.configs'.setup{
        ensure_installed = {
          "css",
          "c_sharp",
          "html", 
          "javascript",
          "python"
        },
        sync_install = true,
        highlight = {
            enable = true
        }
    }

    --Transparent initialization
    require 'transparent'.setup({
        enable = true,
    })
    
    --Which Key inicialization.
    require ("which-key").setup{}
eof

"" -------- TERMINAL APPEARANCE --------

"" Terminal encoding
set encoding=UTF-8

"" Nvim theme setup
set termguicolors
:colorscheme atom-dark 
let g:clap_theme = 'atom-dark'
highlight NvimTreeNormal guibg=#2c323c

"" -------- DASHBOARD CONFIGURATION --------

"" Create a file explorer function for the dashboard
function! FileManager(managingType) abort
    if a:managingType == "create"
        let folder = system('zenity --file-selection --directory --save')
    elseif a:managingType == "open"
        let folder = system('zenity --file-selection --directory')
    endif
    let g:formatedFolder = escape(folder, " #")
    if g:formatedFolder == "" 
        echo "Canceled"
    else
        DashboardNewFile
        set showtabline=2
        execute 'cd' g:formatedFolder
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

"" Dashboard global configurations
let g:dashboard_default_executive='clap'
let g:dashboard_custom_section={
  \ 'open_project': {
    \ 'description': [' Open project folder                 SPC o f'],
    \ 'command': 'OpenFileManager'
  \ },
  \ 'file_history': {
    \ 'description': [' Recently open files                 SPC f f'],
    \ 'command': 'Clap history'
  \ },
  \ 'create_project': {
    \ 'description': [' Create a new Project                SPC c n'],
    \ 'command': 'CreateFileManager'
  \ },
  \ 'open_session': {
    \ 'description': [' Open last session                   SPC o s'],
    \ 'command': function('HandleLoad')
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

"" -------- COC.NVIM CONFIGURATION --------

"" Default Coc language servers
let g:coc_global_extensions = [
\ 'coc-tsserver',
\ 'coc-pyright',
\ 'coc-java',
\ 'coc-json',
\ 'coc-css',
\ 'coc-html'
\]

"" -------- OMNISHARP CONFIGURATION --------

"" Require dotnet core 6 processing on OmniSharp
let g:OmniSharp_server_use_net6 = 1

"" -------- ALE FIXERS AND KEY MAPPINGS --------

"" Ale configuration for ESLint, prettier and python
let g:ale_fixers = {
\    'cs': ['dotnet-format'],
\    'python': ['pyright', 'autopep8'],
\    'javascriptreact': ['prettier', 'eslint'],
\    'javascript': ['prettier', 'eslint'],
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
    if &filetype == "dashboard"
        highlight StatusLine guibg=NONE guifg=NONE
    else
        highlight StatusLine guibg=#2c323c guifg=#2c323c
        highlight StatusLineNC guibg=#2c323c guifg=#2c323c
    endif
    highlight EndOfBuffer guifg=#2c323c
endfunction
autocmd FileType NvimTree call RemoveSL()
autocmd FileType dashboard call RemoveSL()

"" Custom Nvim commands
command DotnetRun terminal dotnet run
command AleSave ALEFix || w
