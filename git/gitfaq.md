## 1、如果不小心把服务器密码账号等隐私信息提交到了远程库怎么办？
git reflog  查找这次提交的上一次提交，得到commitid <br />
git reset commitid 回退到这次提交 <br />
git push remotename -f 强制将回退后的本地提交记录push到远程库 <br />

另外，你还可以使用如下指令让git忽略掉某个文件的变更

	// 假设文件无改动，作用于版本库中已存在的文件。
	// 此方法将确保本地文件不提交，并且版本库中此文件的变更无法影响本地文件。
	git update-index --assume-unchanged app/config/mail.php
	// 取消并恢复为普通文件
	git update-index --no-assume-unchanged app/config/mail.php

## 2、如果不小心将某个文件从暂存区删除了，如何恢复？
假设不小心git rm file-a，这个时候如何恢复？<br />
git reset file-a 将暂存区未commit的内容恢复到工作区 <br />
如果这个时候，需要将file-a修改的内容去掉，从上次提交的版本中恢复 <br />
git checkout file-a

## 3、如何删除GitHub上的一个远程分支？
git push remotename :remotebranch <br />
将本地分支空白覆盖远程分支remotebranch，即为删除远程分支