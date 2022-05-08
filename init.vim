"" Nvim basic setup
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with
set cursorline              " enable line location for the cursor position
set cursorcolumn            " enable column location for the cursor position
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
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on

"" Plugin installation and calling
call plug#begin('~/.config/nvim/plugged')
   
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'tpope/vim-fugitive'
    Plug 'dense-analysis/ale'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'akinsho/bufferline.nvim', {'tag': '*'}
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'sonph/onehalf', {'rtp': 'vim/'}

call plug#end()

"" Terminal theme setup
:colorscheme onehalfdark
hi Normal ctermbg=NONE


"" Ale configuration for ESLint, prettier and python
let g:ale_fixers = {
\    'python': ['pyright', 'autopep8'],
\    'javascriptreact': ['prettier', 'eslint'],
\    'javascript': ['prettier', 'eslint'],
\    'css': ['prettier']
\}
let g:ale_completion_enabled = 1

"" CMP_Vim menu config
set completeopt=menu,menuone,noselect

lua << eof
    -- cmp with LuaSnip configuration
    local cmp = require 'cmp'
    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true })
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' }
        }, {
            { name = 'buffer' }
        })
    })
    
    --Lualine configuration
    require 'lualine'.setup{
        options = {
            theme = 'onedark'
        }
    }
    
    --Bufferline import
    require 'bufferline'.setup{}
    
    --web-devicons configuration
    require 'nvim-web-devicons'.setup {
        default = true
    }
    require 'nvim-web-devicons'.get_icons()

    --NvimTree configuration
    require 'nvim-tree'.setup{
        hijack_cursor = false,
        hijack_netrw = false,
        view = {
            width = 34
        },
        render = {
            icons = {
                webdev_colors = true,
            },
        },
    }

    --Nvim Treesitter configuration
    require 'nvim-treesitter.configs'.setup{
        ensure_installed = {"css", "html", "javascript"},
        sync_install = true,
        highlight = {
            enable = true
        }
    }

    --LSPConfig with CMP setup
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    require 'lspconfig'.emmet_ls.setup{
        capabilities = capabilities
    }
    require 'lspconfig'.html.setup{
        capabilities = capabilities
    }
    require 'lspconfig'.cssls.setup{
        capabilities = capabilities
    }
    require 'lspconfig'.tsserver.setup{
        capabilities = capabilities
    }
    require 'lspconfig'.tailwindcss.setup{
        capabilities = capabilities
    }
    require 'lspconfig'.pyright.setup{
        capabilities = capabilities
    }
eof

"" NvimTree auto close and open
:NvimTreeToggle
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

"" Terminal encoding
set encoding=UTF-8

"" NvimTree Mappings
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <C-r> :NvimTreeRefresh<CR>

"" Telescope Mappings
nnoremap <leader>ff :Telescope find_files<CR>

""Bufferline Mappings
nnoremap <silent>\b :BufferLineCyclePrev<CR>
nnoremap <silent>\f :BufferLineCycleNext<CR>

"" FTerm Mappings
nnoremap <C-t> :lua require("FTerm").toggle()<CR>

nnoremap <silent>\af :ALEFix<CR>

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
