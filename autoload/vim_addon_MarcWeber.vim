
let s:thisf = expand('<sfile>')

fun! vim_addon_MarcWeber#Activate(vam_features)
  let g:vim_addon_urweb = { 'use_vim_addon_async' : 1 }
  let g:netrw_silent = 0
  let g:linux=1
  let g:config = { 'goto-thing-handler-mapping-lhs' : 'gf' }

  let g:local_vimrc = {'names':['vl_project.vim']}

  let plugins = {
      \ 'always':
        \ [
            \ empty($XPTEMPLATE) ? 'snipmate-snippets' : 'xptemplate',
            \ 'vim-addon-commenting','vim-addon-local-vimrc','vim-addon-sql',"vim-addon-completion",
            \ 'vim-addon-async', 'tlib', "vim-addon-toggle-buffer",
            \ "vim-addon-git","vim-addon-mercurial","vim-addon-mw-utils","vim-addon-goto-thing-at-cursor","vim-addon-other",
            \ 'matchit.zip', 'syntastic2'
            \ ],
      \ 'extra' : ['textobj-diff', "textobj-function",  "narrow_region"],
      \ 'vim': ["reload", 'vim-dev-plugin'],
      \ 'sql': [],
      \ 'php': ["phpcomplete", "vim-addon-xdebug","ZenCoding",'vim-addon-php-manual'],
      \ 'scala': ["ensime", "vim-addon-scala","vim-addon-sbt"],
      \ 'sml': ["vim-addon-sml"],
      \ 'agda' : ["vim-addon-agda"],
      \ 'lilypond' : ['vim-addon-lilypond'],
      \ 'urweb': ["vim-addon-urweb"],
      \ 'ocaml' : ["vim-addon-ocaml"],
      \ 'haxe' : [ 'vim-haxe' ],
      \ 'as3': ["vim-addon-fcsh","Flex_Development_Support"],
      \ 'haskell' : [ "vim-addon-haskell"],
      \ 'haskell-scion' : [ "scion-backend-vim"],
      \ 'ruby' : [ "vim-ruby-debugger" ],
      \ 'delphi' : [ "vim-addon-delphi" ],
      \ 'nix' : ["vim-addon-nix"],
      \ 'coq' : ['vim-addon-coq'],
      \ }
  let activate = []
  for [k,v] in items(plugins)
    if k == 'always' 
          \ || (type(a:vam_features) == type([]) && index(a:vam_features, k) >= 0)
          \ || (type(a:vam_features) == type('') && a:vam_features == 'all')
      call extend(activate, v)
    endif
  endfor

  " trailing-whitespace.vim 
  " "yaifa",
  " "vim-addon-blender-scripting",
  " scion-backend-vim",
  " "JSON", 
  " "vim-addon-povray",
  " "vim-addon-lout",

    " \ "delimitMate",
  call vam#ActivateAddons(activate,{'auto_install':1})

  " command MergePluginFiles call vam#install#MergePluginFiles(g:merge+["tlib"], '\%(cmdlinehelp\|concordance\|evalselection\|glark\|hookcursormoved\|linglang\|livetimestamp\|localvariables\|loremipsum\|my_tinymode\|pim\|scalefont\|setsyntax\|shymenu\|spec\|tassert\|tbak\|tbibtools\|tcalc\|tcomment\|techopair\|tgpg\|tmarks\|tmboxbrowser\|tortoisesvn\|tregisters\|tselectbuffer\|tselectfile\|tsession\|tskeleton\|tstatus\|viki\|vikitasks\)\.vim_merged')
  " command UnmergePluginFiles call vam#install#UnmergePluginFiles()
  "

  let g:syntastic = { 'list_type': 'c'}

  noremap <m-w>/ /\<\><left><left>
  noremap <m-w>? ?\<\><left><left>
  noremap <c-,> :cprevious<cr-  set guioptions+=c
  set guioptions+=M
  set guioptions-=m
  set guioptions-=T
  set guioptions-=r
  set guioptions-=l
  noremap <c-c> :cnext<cr>
  inoremap <m-s-r> <esc>:w<cr>
  nnoremap <m-s-r> :w<cr>
  noremap <m-h> :h<space>
  cmap >fn <c-r>=expand('%:p')<cr>
  cmap >fd <c-r>=expand('%:p:h').'/'<cr>


  " inoremap <C-x><C-w> <c-o>:setlocal omnifunc=vim_addon_completion#CompleteWordsInBuffer<cr><c-x><c-o>
  inoremap <C-x><C-w> <c-r>=vim_addon_completion#CompleteUsing('vim_addon_completion#CompleteWordsInBuffer')<cr>

  if !has('gui_running')
    set timeoutlen=200
  endif

  set clipboard=unnamed

  fun! AddTagsFromEnv()
    let tags = split(&tags,',')
    for i in split(expand('$buildInputs'),'\s\+')
      call extend(tags, split(glob(i.'/src/*/*_tags'),"\n"))
    endfor
    call extend(tags, split($TAG_FILES,":"))
    call filter(tags, 'filereadable(v:val)')
    for t in tags
      if &tags !~ substitute(t, '/','\\/','g')
        exec "set tags+=".t
      endif
    endfor
  endf
  let g:vim_addon_haskell = {}
  let g:vim_addon_haskell.env_reloaded_hook_fun = 'AddTagsFromEnv'
  call AddTagsFromEnv()

  augroup ADD_CONFLICT_MARKERS_MATCH_WORDS
    " git onlny for now
    autocmd BufRead,BufNewFile * exec 'let b:match_words '.(exists('b:match_words') ? '.' : '').'= '.string(exists('b:match_words') ? ',' : ''.'<<<<<<<:=======:>>>>>>>')
  augroup end


  command! ASh call async_porcelaine#LogToBuffer({'cmd':'/bin/sh -i', 'move_last':1, 'prompt': '^.*\$[$] '})
  command! AGhci call async_porcelaine#LogToBuffer({'cmd':'ghci', 'move_last':1, 'prompt': '^.*\$[$] '})
  command! ACoq call async_porcelaine#LogToBuffer({'cmd':'coqtop', 'move_last':1, 'prompt': '^Coq < '})
  command! ARubyIrb call repl_ruby#RubyBuffer({'cmd':'irb','move_last' : 1})
  command! ARubySh call repl_ruby#RubyBuffer({'cmd':'/bin/sh','move_last' : 1})
  command! APython call repl_python#PythonBuffer({'cmd':'python -i','move_last' : 1, 'prompt': '^>>> '})
  command! ASMLNJ call repl_ruby#RubyBuffer({'cmd':'sml','move_last' : 1, 'prompt': '^- '})

  "autocommands:"{{{
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
  "}}}e
  
 
  "window cursor movement
  nnoremap <m-s-v><m-s-p> :exec "wincmd g\<c-]>" <bar> exec 'syntax keyword Tag '.expand('<cword>')<cr>
  vnoremap <m-s-v><m-s-p> y:sp<bar>tjump <c-r>"<cr>
   
  nnoremap <m-b><m-n> :bn<cr>
  nnoremap <m-b><m-p> :bp<cr>
  nnoremap <m-a> :b<space>

  imap <c-o> <c-x><c-o>
  imap <c-_> <c-x><c-u>

  noremap \a :ActionOnWrite<cr>
  noremap \A :ActionOnWrite!<cr>

  noremap \aps : if filereadable('pkgs/top-level/all-packages.nix') <bar> e pkgs/top-level/all-packages.nix <bar> else <bar> exec 'e '.expand("$NIXPKGS_ALL") <bar> endif<cr>

  noremap <m-s-f> :e! %<cr>

  command! SlowTerminalSettings :set slow-terminal| set sidescroll=20 | set scrolljump=10 | set noshowcmd
  noremap <m-s-l> :e test.sql<cr>

  noremap \sge :setlocal spell spelllang=de_de<cr>
  noremap \sen :setlocal spell spelllang=en_us<cr>

  noremap <leader>lt :set invlist<cr>
  noremap <leader>iw :set invwrap<cr>
  noremap <leader>ip :set invpaste<cr>
  noremap <leader>hl :set invhlsearch<cr>
  noremap <leader>dt :diffthis<cr>
  noremap <leader>do :diffoff<cr>
  noremap <leader>dg :diffget<cr>
  noremap <leader>du :diffupdate<cr>
  noremap <leader>ts :if exists("syntax_on") <Bar>
	\   syntax off <Bar>
	\ else <Bar>
	\   syntax enable <Bar>
	\ endif <CR>
  inoremap <s-cr> <esc>o
  noremap <m-s-e><m-s-n> :enew<cr>
  inoremap <c-cr> <esc>O
  noremap <m--> k$
  noremap <m-s-a> <esc>jA
  noremap <m-e> :e<space>

  noremap <m-s-s> :<c-u>tjump<space>
  noremap <m-s-t><m-s-p> :<c-u>tprevious<cr>
  noremap <m-s-t><m-s-n> :<c-u>tnext<cr>
  nnoremap <m-s-t> :tabnew<cr>
  exec "noremap <m-s-f><m-s-t><m-s-p> :exec 'e ".fnamemodify(s:thisf,':h:h')."/ftplugin/'.&filetype.'_mw.vim'<cr>"
  noremap \co :<c-u>exec 'cope '.&lines/3<cr>
  noremap <m-s-s><m-s-p> :SnipMateOpenSnippetFiles<cr>
  inoremap <c-e> :<esc>A<cr>

  if isdirectory('src/main/scala')
    noremap <m-s> :e src/main/scala/*
  endif

  set list listchars=tab:\ \ ,trail:·

  augroup FIX_YOUR_WORDING
    autocmd BufWritePost * call vim_addon_MarcWeber#FixYourWording()
  augroup end

  let g:snipMate = { 'scope_aliases' :
	  \ {'objc' :'c'
	  \ ,'cpp': 'c'
	  \ ,'cs':'c'
	  \ ,'xhtml': 'html'
	  \ ,'html': 'javascript'
	  \ ,'php': 'php,html,javascript'
	  \ ,'ur': 'html,javascript'
	  \ ,'mxml': 'actionscript'
	  \ ,'haml': 'html,javascript'
	  \ }}


  noremap <m-g><m-o> :call<space>vim_addon_MarcWeber#FileByGlobCurrentDir('**/*'.input('glob open ').'$',"\\.git<bar>\\.hg" )<cr>
endf

fun! vim_addon_MarcWeber#FixYourWording()
  if join(getline(1,'$'),' ') =~ '\cget\s*out\s*of\s*your'
    echoe "should be keep out of your way!"
  endif
endf


" TODO refactor: create glob function
function! vim_addon_MarcWeber#FileByGlobCurrentDir(glob, exclude_pattern)
  exec library#GetOptionalArg('caption', string('Choose a file'))
  " let files = split(glob(a:glob),"\n")
  let g = a:glob
  let replace = {'**': '.*','*': '[^/\]*','.': '\.'}
  let g = substitute(g, '\(\*\*\|\*\|\.\)', '\='.string(replace).'[submatch(1)]','g')

  let exclude = a:exclude_pattern == ''? '' : ' | grep -v -e '.shellescape(a:exclude_pattern)

  let cmd = 'find | grep -e '.shellescape(g).exclude
  let files = split(system(cmd),"\n")
  " for nom in a:excludes
  "   call filter(files,nom)
  " endfor
  if len(files) > 1000
    echoe "more than ".2000." files - would be too slow. Open the file in another way"
  else
    if empty(files)
      echoe "no file found"
    elseif len(files) == 1
      exec 'e '.files[0]
    else
      let g:abc=7
      call tovl#ui#filter_list#ListView({
            \ 'number' : 1,
            \ 'selectByIdOrFilter' : 1,
            \ 'Continuation' : library#Function('exec "e ".ARGS[0]'),
            \ 'items' : files,
            \ 'cmds' : ['wincmd J']
            \ })
    endif
  endif
endfunction
