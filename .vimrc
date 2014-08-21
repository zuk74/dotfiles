set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
"  call neobundle#rc(expand('~/.vim/bundle/'))
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
" ファイルオープンを便利にする
NeoBundle 'Shougo/unite.vim'
" Unite.vimで最近使ったファイルを表示
NeoBundle 'Shougo/neomru.vim'
" Rubyのendキーワードを自動挿入
NeoBundle 'tpope/vim-endwise'
" インデントの深さを視覚化する(gVim only)
"NeoBundle 'nathanaelkane/vim-indent-guides'
" シンプルなインデントの深さ視覚化
"if has('conceal')
"  NeoBundleLazy 'Yggdroot/indentLine', {'autoload': { 'commands':['IndentLinesReset','IndentLinesToggle']}}
"endif
" アライン
NeoBundleLazy 'junegunn/vim-easy-align', {'autoload': { 'commands':['EasyAlign']}}

" Install    :NeoBundleInstall
" Uninstall  :NeoBundleClean
call neobundle#end()

filetype plugin indent on
filetype indent on
syntax on

" -----------------------------------------------------------------------------
" 行番号表示
set number
" ルーラー表示
set ruler
" タブ表示
"set list
"set listchars=tab:>\ 
" 行を折り返した時の右側のマージン
set wrapmargin=1
" 常にステータス行を表示
set laststatus=2
" コマンドをステータス行に表示
set showcmd

"set highlight
"
" - - - - - - - - - -
" タブに関する設定
" - - - - - - - - - -
" ファイルのタブの幅
set tabstop=2
" 編集中でのタブの幅
set softtabstop=2
" インデントの幅
set shiftwidth=2
" タブに shiftwidth を使用
set smarttab
" タブをスペースに展開しない
"set noexpandtab
" タブをスペースに展開
set expandtab
"
" - - - - - - - - - -
" 編集に関する設定
" - - - - - - - - - -
" カッコの対応付
set showmatch
" 自動的にインデント
set autoindent
" インデントを shiftwidth に丸める
set shiftround
" #から始まる行は先頭の行に残るようにする
set smartindent
" バックスペースで上行末尾の文字を1文字消す
set backspace=2
"
" - - - - - - - - - - - -
" 折り畳みに関する設定
" - - - - - - - - - - - -
" 折り畳み有効
"set foldenable
" 折り畳みレベル設定
"set foldlevel=0
" インデントを折り畳む
"set foldmethod=indent
" 指定したマーカーで折り畳む
"set foldmethod=marker
" フォールドする始めの文字と終わりの文字指定
"set foldmarker={,}
" カーソルを移動したとき自動で折り畳みを開く
"set foldopen=all
"
" - - - - - - - - - -
" その他の関する設定
" - - - - - - - - - -
" テキストの貼り付けの切り替え
set pastetoggle=<f11>
" 早い端末を使う
set ttyfast
" 今使っているモードを表示する
set showmode
" C言語の自動インデントを設定
"set cindent
" 補完候補を表示
set wildmenu
" シフトキーと十字キーで選択できる
set keymodel=startsel
" バックアップディレクトリの指定
"set backupdir=$HOME/tmp
" スワップファイル保存ディレクトリの指定
"set directory=$HOME/tmp
" スキン設定
"colorscheme elflord
"colorscheme evening
"
" - - - - - - - - - - - -
" 文字コードに関する設定
" - - - - - - - - - - - -


" 文字エンコーディング＆改行コード取得
"set statusline=%y%{GetStatusEx()}%F%m%r%=<%c:%l>
" set statusline=%y%{GetStatusEx()}%F%m%r%=<%c:%l>
" function! GetStatusEx()
"  let str = ''
"  let str = str . '' . &fileformat . ']'
"  if has('multi_byte') && &fileencoding != ''
"   let str = '[' . &fileencoding . ':' . str
"  endif
"  return str
" endfunction
if has('iconv')
  set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}%=[0x%{FencB()}]\ (%v,%l)/%L%8P\
else
  set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}%=\ (%v,%l)/%L%8P\
endif

function! FencB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return s:Byte2hex(s:Str2byte(c))
endfunction

function! s:Str2byte(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function! s:Byte2hex(bytes)
  return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
endfunction

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

set cindent

" autocmd BufNewFile,BufRead *.sv set filetype=verilog

set nrformats-=octal

" 連番を振る
nnoremap <silent> co :ContinuousNumber <C-a><CR>
vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor


"syntax on

