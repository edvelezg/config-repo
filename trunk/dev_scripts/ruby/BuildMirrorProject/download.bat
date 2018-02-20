rem git show HEAD:trunk/MyBashProfile/ROFA/.aliases > .aliases

echo adding git to the path
SET PATH="%PATH%;C:\Program Files\Git\bin\"

git show HEAD:trunk/MyBashProfile/ROFA/.aliases        >   .aliases      
git show HEAD:trunk/MyBashProfile/ROFA/.bash_profile   >   .bash_profile 
git show HEAD:trunk/MyBashProfile/ROFA/.functions      >   .functions    






