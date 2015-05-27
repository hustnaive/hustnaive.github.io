# Git常用命令手册

|命令|说明|示例|
|---|----|---|
|git init|初始化目录为工作区| - |
|git status|查看工作区状态| - |
|git add|将工作区修改添加到stage|git add < file > |
|git commit|将stage中的内容提交到版本库 |git commit -m ‘commit log’ < file > <br />提交，或者只提交某文件的修改|
|git reset|版本恢复 <br /> --mixed 默认方式，保留源码，回退commit和stage/index <br /> --soft 只回退commit，保留stage/index（和mixed的区别联系？）<br /> --hard 彻底回退|git reset < -mixed &aelig; -soft &aelig; -hard > commitlogid <br />恢复到版本库的commitlogid版本 <br /><br /> git reset HEAD filename <br />将stage中未commit的内容放回工作区（unstage）|
|git diff|比较工作区代码和stage/版本库代码差异| |

git diff

git diff  < file >
比较工作区file跟stage的差异

git diff HEAD < file >
比较工作区file跟版本库的差异
git checkout
检出文件/选择分支
git checkout -- < file >
从stage检出某文件（用于文件还没有add到stage，从暂存区恢复）

git checkout HEAD < file >
从版本库检出某文件（当文件已经add到了stage时，从版本库恢复）

git checkout -b branchname
创建并切换到分支，相当于
git branch branchname;
git checkout branchname;
两条指令

git checkout branchname
选择分支
git log
--stat 显示详细的文件修改记录
git log < —stat >  < file|dir >
git reflog
查看所有分支的提交记录（包括commit和reset）
-
git branch
创建/查看/删除分支
git branch
查看所有分支

git branch branchname
创建分支

git branch -d branchname
删除某分支，如果分支没有merge掉，则会报错

git branch -D branchname
强制删除分支
git merge
合并分支
git merge branchname
使用fast-forward模式从目标分支将内容合并到当前分支，如果发生冲突，需要解决冲突之后commit

git merge --no-ff branchname
fast-forward模式
git stash
缓存工作区
git stash
将当前工作区入缓存堆栈

git stash list
展示工作区缓存堆栈

git stash apply stash@{n}
将堆栈中第n个缓存恢复到当前工作区

git stash pop 
将最后入栈的工作区缓存恢复到当前现场，同时从堆栈中移除

git stash drop stash@{n}
从堆栈中删除某工作区缓存
git remote
查看/添加远程仓库
git remote < -v >
查看远程仓库（详细信息）

git remote add remotename git@github.com:hustnaive/xxx.git
添加远程仓库remotename

git remote rm remotename
删除远程仓库remotename

git pull
将远程分支合并到本地
git pull remotename branchname
将远程仓库的branchname分支合并到当前分支
git push
将本地分支合并到远程仓库
git push remotename branchname
将当前分支推送到远程分支