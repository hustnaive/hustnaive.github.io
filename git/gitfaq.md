## 1、如果不小心把服务器密码账号等隐私信息提交到了远程库怎么办？
git reflog  查找这次提交的上一次提交，得到commitid <br />
git reset commitid 回退到这次提交 <br />
git push remotename -f 强制将回退后的本地提交记录push到远程库 <br />

## 2、如果不小心将某个文件从暂存区删除了，如何恢复？
假设不小心git rm file-a，这个时候如何恢复？
git reset file-a 将暂存区未commit的内容恢复到工作区 <br />
如果这个时候，需要将file-a修改的内容去掉，从上次提交的版本中恢复 <br />
git checkout file-a