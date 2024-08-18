call plug#begin('/home/okano/.config/nvim/plugged')

Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'is0n/fm-nvim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'prabirshrestha/vim-lsp'
Plug 'williamboman/nvim-lsp-installer'
Plug 'liuchengxu/vista.vim'
Plug 'kevinhwang91/nvim-bqf'
Plug 'ivechan/gtags.vim'
Plug 'glepnir/zephyr-nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'skywind3000/asyncrun.vim'
Plug 'tversteeg/registers.nvim'
Plug 'stevearc/conform.nvim'
Plug 'mechatroner/rainbow_csv'
Plug 'shortcuts/no-neck-pain.nvim'
Plug 'rhysd/vim-fixjson'
Plug 'johmsalas/text-case.nvim'
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'MunifTanjim/nui.nvim'
Plug 'folke/flash.nvim'
Plug 'sirver/UltiSnips'
Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }


" Python関連のプラグイン
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'dense-analysis/ale'
Plug 'neovim/pynvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-neotest/nvim-nio'

call plug#end()

set runtimepath+=~/.config/nvim/custom_help

" プラグインの設定をここに追加
" vista.vim
let g:vista_default_executive = 'nvim_lsp'
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\ }
nnoremap <silent> <Space>t :Vista!!<CR>

" NERDTree
nnoremap <C-t> :NvimTreeToggle <CR>

" vim-airline
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" fzf.vim
nnoremap <leader>p :Files<CR>
nnoremap <leader>g :Rg<CR>

" vim-gitgutter
let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0

" ALE
let g:ale_linters = {'python': ['flake8'], 'cpp': ['clangd']}
let g:ale_fixers = {'python': ['isort', 'black'], 'cpp': ['clang-format'], 'c':['clang-format']}
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_python_flake8_options = '--ignore=E501,W503'

let g:ale_c_clangformat_options = '"-style={
\ BasedOnStyle: google,
\ IndentWidth: 4,
\ ColumnLimit: 100,
\ AllowShortBlocksOnASingleLine: Always,
\ AllowShortFunctionsOnASingleLine: Inline,
\ FixNamespaceComments: true,
\ ReflowComments: false,
\ }"'

" python-syntax
" let g:python_highlight_all = 1

" vim-python-pep8-indent
let g:python_pep8_indent_multiline_string = -1


" ncm2
" autocmd BufEnter * call ncm2#enable_for_buffer()
" set completeopt=noinsert,menuone,noselect

" black
autocmd BufWritePre *.py execute ':Black'

"    cmd = {"clangd", "--compile-commands-dir=/home/okano/work/navilogix/solver"},

" vim-lspの各種オプション設定
lua << EOF
local clangd_cmd = {"clangd", "--compile-commands-dir=" .. vim.fn.getcwd()}
require'lspconfig'.pylsp.setup{}
require'lspconfig'.clangd.setup{
    cmd = clangd_cmd,
    on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- キーマップの設定: 定義へジャンプ
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap=true, silent=true})

        -- フォーマットのコマンド設定
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap=true, silent=true })
    end,
    -- ファイルを保存する際に自動的にフォーマットする設定
    settings = {
        ['clangd'] = {
            filetypes = {"c", "cpp", "cc"}, -- 対象とするファイルタイプ
            automaticFormatting = true
        }
    }
}
require'nvim-tree'.setup {}
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
})
require('bqf').setup({
    auto_enable = true, -- 自動でbqfの機能を有効にする
    preview = {
        win_height = 21,  -- プレビューウィンドウの高さ
        win_vheight = 21, -- 垂直分割時のプレビューウィンドウの高さ
        delay_syntax = 80, -- シンタックスハイライトの適用を遅延させる時間（ミリ秒）
        border = 'single'     -- プレビューウィンドウに境界線を表示する
    },
    func_map = {
        vsplit = '',      -- 垂直分割のキーマッピングを無効にする
        ptogglemode = 'z,', -- プレビューウィンドウの表示/非表示を切り替えるキー
        stoggleup = ''    -- 他のキーマッピングを無効にする（必要に応じて）
    },
    filter = {
        fzf = {
            action_for = {},  -- FZFのアクション設定をクリア
            extra_opts = {}   -- FZFの追加オプションをクリア
        }
    }
})

-- LSP Hover のカスタマイズ
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
--   vim.lsp.handlers.hover, {
--     -- ボーダーのスタイルを設定
--     border = "rounded",
-- 
--     -- 背景色を設定
--     focusable = false, -- ウィンドウがフォーカス可能かどうか
--     style = "minimal", -- ウィンドウスタイル
--     width = 100, -- ウィンドウの幅
--     height = 30,
--   }
-- )

require'lspconfig'.gopls.setup {
  on_attach = function(client, bufnr)
    -- その他の設定
  end,
  settings = {
      gopls = {
          gofumpt = true
      }
  }
}
require'lspconfig'.golangci_lint_ls.setup({ capabilities = capabilities })

local saga = require 'lspsaga'
saga.setup({
  -- border_style = "round",
  symbol_in_winbar = {
    enable = true,
  },
  show_outline = {
    win_width = 50,
    -- auto_preview = false,
  },
})
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "markdown" }, -- 必要なパーサーをここに追加
  highlight = {
    enable = true,              -- falseにすると全ての言語のハイライトが無効化されます
    additional_vim_regex_highlighting = { "python" },
  },
}

vim.keymap.set({'n', 't'}, '<A-t>', '<cmd>Lspsaga term_toggle<CR>')

require('dap-python').setup('python')
require('dap').adapters.python = {
  type = 'server',
  host = '127.0.0.1',
  port = 5678,
}



require('dap').configurations.python = {
  {
    type = 'python',
    request = 'attach',
    name = 'Attach to FastAPI',
    host = '127.0.0.1',
    port = 5678,
    pathMappings = {
      {
        localRoot = '/home/okano/work/navilogix/solver',
        remoteRoot = '/usr/src/app',
      },
    },
  },
}

require("dapui").setup()
-- -- 例外発生時にカーソルを自動的に移動させるイベントリスナーの設定
-- require('dap').listeners.after.event_stopped['exception'] = function(session, body)
--   local frame = body.threadId and session:request('stackTrace', { threadId = body.threadId })
--   if frame and frame.body and frame.body.stackFrames and #frame.body.stackFrames > 0 then
--     local stack_frame = frame.body.stackFrames[1]
--     local filename = stack_frame.source.path
--     local line = stack_frame.line
--     vim.fn.execute('edit ' .. filename)
--     vim.fn.execute(':' .. line)
--   end
-- end

-- init.lua の追加設定
function GoToErrorLine(error_message)
  -- エラーメッセージから行番号を抽出
  local line_number = error_message:match("line (%d+),")
  if line_number then
    vim.cmd(string.format(":%s", line_number))
  else
    print("行番号が見つかりませんでした")
  end
end

-- デバッグセッション中にエラーが発生した場合に呼び出される関数
function OnErrorReceived(event)
  if event.body and event.body.output then
    local error_message = event.body.output
    GoToErrorLine(error_message)
  end
end

-- DAPのイベントリスナーにエラー処理を追加
require('dap').listeners.after.event_stopped['custom_error_handler'] = function(event)
  OnErrorReceived(event)
end


require('registers').setup{}

-- 保存時に自動フォーマット
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- 保存時に自動フォーマット
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    if client.supports_method("textDocument/formatting") then
      local set_auto_format = function(lsp_name, pattern)
        if client.name == lsp_name then
          print(string.format("[%s] Enable auto-format on save", lsp_name))
          vim.api.nvim_clear_autocmds({ group = augroup })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            pattern = pattern,
            callback = function()
              print("[LSP] " .. client.name .. " format")
              vim.lsp.buf.format({ buffer = ev.buf, async = false })
            end,
          })
        end
      end

      set_auto_format("gopls", { "*.go" })
    end
  end,
})


require("conform").setup({
  -- Map of filetype to formatters
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    go = { "goimports" },
  }
})  
vim.api.nvim_set_keymap('n', '<F5>', '<Cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', '<Cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', '<Cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>b', '<Cmd>lua require"dap".toggle_breakpoint()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dr', '<Cmd>lua require"dap".repl.open()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dl', '<Cmd>lua require"dap".run_last()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dui', '<Cmd>lua require"dapui".toggle()<CR>', { noremap = true, silent = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

function ReplaceFuncCall()
    local line = vim.api.nvim_get_current_line()
    local prefix, func_name, args = string.match(line, '(.-)(%w+)%((.+)%)')
    if func_name and args then
        local new_args = {}
        for arg in string.gmatch(args, '([^,]+)') do
            arg = vim.trim(arg)
            table.insert(new_args, arg .. '=' .. arg)
        end
        local new_line = prefix .. func_name .. '(' .. table.concat(new_args, ', ') .. ')'
        vim.api.nvim_set_current_line(new_line)
    end
end



-- vim.api.nvim_set_keymap('n', '<leader>a', ':lua ReplaceFuncCall()<CR>', { noremap = true, silent = true })


-- require("no-neck-pain").setup({
--   width = 120,
--   autocmds = {
--     enableOnVimEnter = true,
--   },
--   buffers = {
--     colors = { background = "tokyonight-moon" },
--   },
-- })

vim.keymap.set("n", "<M-n>", ":NoNeckPain<CR>", { silent = true })
require('textcase').setup {}
require('flash').setup({
})

EOF




let g:lsp_signs_enabled = 0
let g:lsp_diagnostics_echo_cursor = 0

" カーソルがエラーまたは警告の上にある時に、その内容をエコー表示する
autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})


nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K <cmd>Lspsaga hover_doc<CR>
" nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
" 名前変更
nnoremap <Leader>R <cmd>lua vim.lsp.buf.rename()<CR>
" 参照検索
nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>
" Lint結果をQuickFixで表示
nnoremap <LocalfLeader>f <cmd>lua vim.diagnostic.setqflist()<CR>

" テキスト整形
nnoremap <Leader>f <cmd>lua vim.lsp.buf.formatting()<CR>

nnoremap <Leader>di <cmd>Lspsaga diagnostic_jump_next<CR>


" オムニ補完を利用する場合、定義の追加
set omnifunc=lsp#complete


" マウスを有効化
set mouse=a

" タブ移動
nnoremap <C-l> :bnext<CR>
nnoremap <C-h> :bprevious<CR>

" 行番号を表示
" set number

" タブをスペース4つに展開
set expandtab
set tabstop=4
set shiftwidth=4

" 検索結果をハイライト
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" インクリメンタルサーチを有効化
set incsearch

" 大文字と小文字を区別しない検索
set ignorecase
set smartcase

" ファイルタイプに基づいたインデントを有効化
filetype plugin indent on

" クリップボードを共有
set clipboard=unnamed

" ビープ音を無効化
set noerrorbells
set novisualbell

" バックアップファイルを作成しない
set nobackup
set nowritebackup
set noswapfile

" ウィンドウの下部にステータスラインを表示
set laststatus=2

" 256色モードを有効化
set t_Co=256

" カーソル行を強調表示
set cursorline

" 不可視文字を表示
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

" 対応する括弧を強調表示
set showmatch


set guifont=RictyDiminished\ Nerd\ Font:h14
set encoding=UTF-8


" ハイライト表示
highlight NormalFloat guibg=#1f2335 guifg=#c0caf5 ctermbg=236 ctermfg=145
highlight FloatBorder guifg=white guibg=#1f2335 ctermfg=15 ctermbg=236

" set termguicolors
colorscheme zephyr


" 行番号の切り替え
nnoremap <F2> :set number!<CR>
" サインカラムの表示/非表示をトグルする
function! ToggleSignColumn()
  " 現在のsigncolumnの値を取得
  let l:current_value = &signcolumn
  " signcolumnが'yes'に設定されている場合は'no'に、それ以外の場合は'yes'に設定
  if l:current_value == 'yes'
    set signcolumn=no
  else
    set signcolumn=yes
  endif
endfunction

" F3キーにToggleSignColumn関数をマッピング
nnoremap <F3> :call ToggleSignColumn()<CR>

" vimagit
" マジックウィンドウを開くためのキーマッピング
nnoremap <leader>M :Magit<CR>

" コミットメッセージを編集するためのキーマッピング
nnoremap <leader>mc :MagitCommit<CR>

" ステージングを行うためのキーマッピング
nnoremap <leader>ms :MagitStage<CR>

" Make コマンド実行後にクイックフィックスを自動で開く
autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost l* lwindow

set errorformat=%f:%l:%c:\ %t%*[^:]:\ %m
set errorformat+=%.%#File\ \"%f\"\\,\ line\ %l%.%#
" set makeprg=make\ docker-build

vnoremap <C-c> :w !clip.exe<CR>

let g:pydocstring_doq_path = '/home/okano/.local/bin/doq'
let g:pydocstring_formatter = 'numpy'
nmap <leader>L <Plug>(pydocstring)

" gtags
" 検索結果Windowを閉じる
nnoremap <C-q> <C-w><C-w><C-w>q
" Grep 準備
nnoremap <C-g><C-g> :Gtags -g <C-r><C-w><CR>
" このファイルの関数一覧
nnoremap <C-g><C-l> :Gtags -f %<CR>
" カーソル以下の定義元を探す
nnoremap <C-g><C-j> :Gtags <C-r><C-w><CR>
" カーソル以下の使用箇所を探す
"nnoremap <C-g><C-k> :Gtags -r <C-r><C-w><CR>
nnoremap <C-g><C-k> :vimgrep /\W<C-r><C-w>\W\C/ **/*.cpp **/*.h **/*.cc<CR>

let g:asyncrun_open = 6

" Goファイル保存時にgofumptを実行する
" autocmd BufWritePre *.go execute ':silent! !gofumpt -w %'

" 変更を再読み込み
" autocmd BufWritePre *.go :edit

noremap! <C-j> <esc>


nnoremap gau :lua require('textcase').current_word('to_upper_case')<CR>
nnoremap gal :lua require('textcase').current_word('to_lower_case')<CR>
nnoremap gas :lua require('textcase').current_word('to_snake_case')<CR>
nnoremap gad :lua require('textcase').current_word('to_dash_case')<CR>
nnoremap gan :lua require('textcase').current_word('to_constant_case')<CR>
nnoremap gad :lua require('textcase').current_word('to_dot_case')<CR>
nnoremap gaa :lua require('textcase').current_word('to_phrase_case')<CR>
nnoremap gac :lua require('textcase').current_word('to_camel_case')<CR>
nnoremap gap :lua require('textcase').current_word('to_pascal_case')<CR>
nnoremap gat :lua require('textcase').current_word('to_title_case')<CR>
nnoremap gaf :lua require('textcase').current_word('to_path_case')<CR>


let g:deoplete#enable_at_startup = 1
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
