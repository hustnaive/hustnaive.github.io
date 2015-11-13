---
layout: page
title: 基于GIT的敏捷开发发布流程
categories: git,scrum
tags: git,scrum
---

# 基于GIT的敏捷开发发布流程

![流程图](/img/git-dev-process.jpg)

## 上冲刺发布后，下冲刺开始前

1. 锁定MASTER分支，只有SM有权限，防止误提交
2. 进行本冲刺需求规划与分析，确定功能分支和各功能间依赖关系

### 锁定MASTER分支

GitLab提供`protected branches`功能，允许锁定某分支，这样，非masters组的人不能提交代码到此分支（这要求不能所有的的开发小组成员都有masters组权限，不然锁定就失去意义了）

![锁定MASTER分支](/img/protected-branch.png)

### 开启功能分支

Git For Windows：<https://git-for-windows.github.io/>

建议以Git Bash方式运行，这样更加了解每个动作后面做的事情，GUI各家背后做的事情完全对用户屏蔽，对程序员而言非常不友好。

```
git bash:

cd /path/to/proj
git fetch origin
git checkout -b feature1 origin/master
git branch -a

```

1. 进入源代码目录
2. 将远程代码拉取到本地
3. 从远程master分支创建功能分支feature1并切换到分支下
4. 查看本地分支列表

### 将功能分支push到远程仓库

有时候，我们需要异地，或者协同开发，这个时候，可能需要把远程分支push到仓库，然后，从另外一个地方checkout功能分支代码

```
git bash:

cd /path/to/proj
git checkout feature1
git push origin feature1

```

1. 进入源代码目录
2. 切换到功能分支
3. 将功能分支push到远程仓库的对应分支上（并自动合并，如果有冲突或者有更改可能需要先pull）

这样，在另外一个地方，我们可以如下获取功能分支代码


```
git bash:

cd /path/to/proj
git fetch origin
git checkout -b feature1 origin/feature1

```

1. 进入源码目录
2. 拉取远程仓库的最新代码
3. 建立本地分支，并跟踪远程分支

上述命令的作用是拉取远程仓库的最新代码，建立本地分支feature1和远程分支origin/feature1的跟踪关系。
首次拉取需要fetch和从远程分支建立本地分支，以后只需要pull远程分支到本地即可：

```
git checkout feature1
git pull origin feature1
```

1. 切换到featrue1分支
2. 从远程分支拉取最新代码并合并到本地分支

就可以拉取远程origin/feature1分支的最新代码，并合并到本地feature1分支

## 本冲刺迭代

在功能迭代完成，需要提测的时候，将功能分支合并到CI分支，然后由测试在CI分支上进行测试。

如果你们还没有建CI分支，可以参考`开启功能分支`一节的介绍创建CI分支。

### 将功能分支合并到CI分支提测

功能分支开发完成后，我们需要将其合并到CI分支并提测，整个操作如下：

```
git checkout -b ci origin/ci 或 git checkout ci & git pull origin ci
git merge feature1
git push origin ci
```

1. 建立本地CI分支到远程CI分支的跟踪。如果已经建立，切换到CI分支，执行拉取最新的代码合并到本地
2. 将feature1分支合并到CI分支，合并的过程中可能产生冲突，根据具体情况进行冲突解决
3. 将合并后的CI分支推到远程CI分支并提测

### 如果出现功能放弃，或者延后发布

从MASTER重新建立CI-NEW分支，对每个本冲刺可以发布的功能，在CI-NEW上执行合并操作。将CI-NEW提测，并验证可发布的功能是否有问题。

```
git checkout -b ci-new origin/master
git fetch origin/feature1..n
git merge feature1..n
git push origin ci -f
```

这里，为了保持CI的一致性，用ci-new覆盖ci（加了 -f 参数）。

### 解决上冲刺发布的bug

MASTER分支处于锁定状态，理论上本冲刺迭代期不会对其产生更改，但是不排除有线上紧急bug，需要紧急修复的场景，这种情况下，需要从MASTER分支开BUG分支，解决bug，并合并回MASTER分支。

```
git checkout -b bug-fix origin/master
//fix bug
git push origin bug-fix
```

1. 从master分支建立bug-fix分支
2. 解决bug
3. 将bug-fix分支推送到远程仓库（便于其他人进行代码审核和合并）

然后，由具有master权限的人执行合并回主干的操作:

```
git fetch origin bug-fix
git checkout master
git merge bug-fix
git push origin master
git checkout ci
git merge bug-fix
git push origin ci
```

1. 拉取bug-fix分支到本地
2. 切换到master分支
3. 合并bug-fix分支到master
4. 推送bug-fix分支到远程master分支
5. 切换到ci分支
6. 合并bug-fix分支到ci
7. 推送ci分支到远程ci分支

之后，就可以通知测试更新预发环境进行验证并上生产环境了。

### 冲刺迭代测试需要在CI分支上验证的事项

1. 本冲刺的功能开发
2. 每个功能分支先在功能分支上进行验证，验证没问题后，合并到CI分支上集成验证
3. 上冲刺产生的bug（bug-fix从master分支开，还需要合并到CI分支进行验证）

## 冲刺发布

冲刺发布由具有masters组权限的人操作，主要是实现将CI分支合并到master分支，并解决可能潜在的冲突（比如因为bug分支导致的冲突等）

### 上预发

```
git checkout master
git pull origin master
git merge origin ci
git push origin master
```

1. 切换到master分支
2. 将远程master分支拉取最新的到本地master
3. 将远程ci分支合并到本地master分支
4. 推送本地master分支到远程master分支

之后就可以通知上预发了。


理论上说，预发验证没有问题后，就可以上生产了。

如果预发验证过程中，出现bug，需要持续迭代的，那么，就根据具体的bug出现的原因来决定具体的解决方式。

如果是本冲刺的功能开发产生的bug，那么需要在对应的功能分支上修复对应的bug，然后重新合并到CI分支，进行重新上预发操作。

如果是功能合并后的，有部分数据结构和线上冲突了，那需要根据具体情况决定解决策略。


### 上生产

预发验证通过，即可打标签，上生产

```
git checkout master
git tag release-tag
git push origin release-tag
```

1. 切换到master分支
2. 打发布标签，比如v20151113-release
3. 推送发布标签到远程代码库

之后，就可以通知运维更新生产环境代码了。

### 清理迭代分支

上生产之后，在开始下冲刺的开发和bug修复的时候，我们需要清理一下本次迭代产生的bug分支，feature分支

A. 清理本地分支

```
git checkout master
git branch -a
git branch -d/-D feature1 bug-fix 
```

1. 切换回master分支
2. 查看所有本地分支
3. 删除本地分支

B. 清理远程仓库分支

删除了本地的分支，我们也需要对应的删除本迭代中因为协作需要推送到远程仓库的分支

```
git push origin :feature1
```

1. 相当于将一个空的分支推送到远程，即删除远程分支


至此，我们基于GIT进行代码管理的一次迭代就完成了，下个迭代以此类推。