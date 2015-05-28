# Git常用命令手册

|命令|说明|示例|
|---|----|---|
| git init | 初始化目录为工作区 | - |
| git status | 查看工作区状态 | - |
| git add | 将工作区修改添加到stage | git add < file > |
| git commit | 将stage中的内容提交到版本库 | git commit -m ‘commit log’ < file > <br />提交，或者只提交某文件的修改 |
| git reset | 版本恢复 <br /> --mixed 默认方式，保留源码，回退commit和stage/index <br /> --soft 只回退commit，保留stage/index（和mixed的区别联系？）<br /> --hard 彻底回退|git reset < -mixed &brvbar; -soft &brvbar; -hard > commitlogid <br />恢复到版本库的commitlogid版本 <br /><br /> git reset HEAD filename <br />将stage中未commit的内容放回工作区（unstage）|
| git rm | 将stage中的文件内容移除，并从工作区中删除 | git rm < file > |
| git diff | 比较工作区代码和stage/版本库代码差异 | git diff <br /> 比较当前工作区所有文件 <br /><br /> git diff  < file > <br />比较工作区file跟stage的差异 <br /><br /> git diff HEAD < file > <br /> 比较工作区file跟版本库的差异 <br /><br /> git diff --cached &brvbar; --staged <br /> 比较stage中文件与版本库中得代码差异 |
| git checkout | 检出文件/选择分支|git checkout -- < file > <br /> 从stage检出某文件（用于文件还没有add到stage，从暂存区恢复）<br /><br /> git checkout HEAD < file > <br /> 从版本库检出某文件（当文件已经add到了stage时，从版本库恢复）<br /><br />git checkout -b branchname <br /> 创建并切换到分支，相当于 <br /> git branch branchname; <br /> git checkout branchname; <br /> 两条指令 <br /><br /> git checkout branchname <br /> 选择切换分支 |
| git log | --stat 显示详细的文件修改记录 | git log < —stat >  < file &brvbar; dir > <br /> git reflog <br /> 查看所有分支的提交记录（包括commit和reset）| - |
| git branch | 创建/查看/删除分支 | git branch <br /> 查看所有分支 <br /><br /> git branch branchname <br /> 创建分支 <br /><br /> git branch -d branchname <br />删除某分支，如果分支没有merge掉，则会报错 <br /><br /> git branch -D branchname<br />强制删除分支 |
| git merge | 合并分支 | git merge branchname <br /> 使用fast-forward模式从目标分支将内容合并到当前分支，如果发生冲突，需要解决冲突之后commit<br /><br />git merge --no-ff branchname<br />no-fast-forward模式 |
| git stash | 缓存工作区 | git stash <br /> 将当前工作区入缓存堆栈 <br /><br /> git stash list <br /> 展示工作区缓存堆栈 <br /><br /> git stash apply stash@{n} <br /> 将堆栈中第n个缓存恢复到当前工作区 <br /><br /> git stash pop <br />将最后入栈的工作区缓存恢复到当前现场，同时从堆栈中移除 <br /><br /> git stash drop stash@{n} <br /> 从堆栈中删除某工作区缓存 |
| git remote | 查看/添加远程仓库 | git remote < -v > <br /> 查看远程仓库（详细信息） <br /><br /> git remote add remotename git@github.com:hustnaive/xxx.git <br /> 添加远程仓库remotename <br /><br />git remote rm remotename <br /> 删除远程仓库remotename |
| git pull | 将远程分支合并到本地 | git pull remotename branchname <br /> 将远程仓库的branchname分支合并到当前分支 |
| git push | 将本地分支合并到远程仓库 | git push remotename branchname <br /> 将当前分支推送到远程分支 |
| git reflog | 查看本地的提交日志 | - |
| git tag | 标签 | git tag <br /> 查看所有标签 <br /><br /> git tag tagname <br /> 打标签 <br /><br /> git tag -d tagname <br /> 删除标签 |
| git clone | 克隆，用于从远程拷贝代码仓库到本地 | git clone url < localdir > <br />将url对应的远程仓库克隆到本地的localdir目录 |
