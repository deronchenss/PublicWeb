@echo off
set PATH=%PATH%;C:\Program Files\Git\cmd
echo --Save Local Code Into Stash--
git stash -u
echo --Pull Server Code On Local--
git pull
echo --Get Local Code Back From Stash--
git stash pop
echo --Process Success--