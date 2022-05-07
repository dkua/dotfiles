vim9script

const NETRW_DIR: string = $HOME .. '/.vim/pack/mine/start/netrw'

mkdir(NETRW_DIR, 'p')
for file in glob($VIMRUNTIME .. '/**/*netrw*.vim', false, true)
    var copy_file: string = file->substitute($VIMRUNTIME, NETRW_DIR, '')
    mkdir(copy_file->fnamemodify(':h'), 'p')
    readfile(file)->writefile(copy_file)
endfor
var patch: list<string> =<< DATA
From 9e2b8779cdd2bd511b621637e2b31beaf19dffb7 Mon Sep 17 00:00:00 2001
From: joeran <dummy@fake.mail>
Date: Tue, 6 Nov 2018 20:11:27 +0100
Subject: [PATCH] runtime/autoload/netrw: Correct symlink handling in tree
 liststyle

Fixes #2386 #445

The actual implementation of s:NetrwTreeDir causes symlinks to be
handled wrong in case the current netrw_liststyle is the tree view
('3'). This happens for file and for directory symlinks, which are
edited itself.
---
 runtime/autoload/netrw.vim | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/runtime/autoload/netrw.vim b/runtime/autoload/netrw.vim
index 76485c2f3815..cf80cc55516c 100644
--- a/runtime/autoload/netrw.vim
+++ b/runtime/autoload/netrw.vim
@@ -8878,7 +8878,7 @@ fun! s:NetrwTreeDir(islocal)
 "    call Decho("treedir<".treedir.">",'~'.expand("<slnum>"))
    elseif curline =~ '@$'
 "    call Decho("handle symbolic link from current line",'~'.expand("<slnum>"))
-    let treedir= resolve(substitute(substitute(getline('.'),'@.*$','','e'),'^|*\s*','','e'))
+    let potentialdir= resolve(substitute(substitute(getline('.'),'@.*$','','e'),'^|*\s*','','e'))
 "    call Decho("treedir<".treedir.">",'~'.expand("<slnum>"))
    else
 "    call Decho("do not extract tree subdirectory from current line and set treedir to empty",'~'.expand("<slnum>"))
@@ -8900,21 +8900,17 @@ fun! s:NetrwTreeDir(islocal)
 "    call Decho(".user not attempting to close treeroot",'~'.expand("<slnum>"))
    endif
 
-"   call Decho("islocal=".a:islocal." curline<".curline.">",'~'.expand("<slnum>"))
-   let potentialdir= s:NetrwFile(substitute(curline,'^'.s:treedepthstring.'\+ \(.*\)@$','\1',''))
-"   call Decho("potentialdir<".potentialdir."> isdir=".isdirectory(potentialdir),'~'.expand("<slnum>"))
-
-   " COMBAK: a symbolic link may point anywhere -- so it will be used to start a new treetop
-"   if a:islocal && curline =~ '@$' && isdirectory(s:NetrwFile(potentialdir))
-"    let newdir          = w:netrw_treetop.'/'.potentialdir
-" "   call Decho("apply NetrwTreePath to newdir<".newdir.">",'~'.expand("<slnum>"))
-"    let treedir         = s:NetrwTreePath(newdir)
-"    let w:netrw_treetop = newdir
-" "   call Decho("newdir <".newdir.">",'~'.expand("<slnum>"))
-"   else
+   if a:islocal && curline =~ '@$'
+"    call Decho("potentialdir<".potentialdir."> isdir=".isdirectory(potentialdir),'~'.expand("<slnum>"))
+    if isdirectory(s:NetrwFile(potentialdir))
+     " COMBAK: a symbolic link may point anywhere -- so it will be used to start a new treetop...at least for directories
+     let treedir         = w:netrw_treetop.'/'.potentialdir.'/'
+     let w:netrw_treetop = treedir
+    endif
+   else
 "    call Decho("apply NetrwTreePath to treetop<".w:netrw_treetop.">",'~'.expand("<slnum>"))
     let treedir = s:NetrwTreePath(w:netrw_treetop)
-"   endif
+   endif
   endif
 
   " sanity maintenance: keep those //s away...
DATA
system('cd ' .. NETRW_DIR .. ' && patch -p2', patch)
