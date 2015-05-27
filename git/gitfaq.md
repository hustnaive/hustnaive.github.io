# 1、如果不小心把服务器密码账号等隐私信息提交到了远程库怎么办？
git reflog  查找这次提交的上一次提交，得到commitid <br />
git reset commitid 回退到这次提交 <br />
git push remotename -f 强制将回退后的本地提交记录push到远程库 <br />