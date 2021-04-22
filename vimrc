"https://zhuanlan.zhihu.com/p/60880207
"vim ~/.vimrc
"输入下列参数，保存即可，默认C语言代码可以按control+p补全关键字
syntax on	" 自动语法高亮
set number " 显示行号
set cindent
set smartindent " 开启新行时使用智能自动缩进
set showmatch " 插入括号时，短暂地跳转到匹配的对应括号
set ruler " 打开状态栏标尺
:set mouse=a "在vim所有模式下开鼠标，复制文档就可以不包含行号了
