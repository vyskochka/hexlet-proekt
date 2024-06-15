if test -z $1
then
  echo "$0 : You must set a project name"
  exit 1
else
  if test -d /srv/sites/$1/www/
  then
    if test -d /srv/sites/$1/www/bitrix/modules/main/
    then
      echo 'packing site...'
      /bin/bash /srv/git/bin/bitrix_tar.sh $1
    fi  
    cd /srv/git/
    mkdir $1
    cd $1
    git --bare init
    cp ../def_rep/config ./
    cd /srv/sites/$1/www/
    cp /srv/git/def_rep/gitignore_bitrix ./.gitignore
    git init 
    echo "[remote \"origin\"]" >> .git/config
    echo "    url = ssh://git@localhost/srv/git/$1" >> .git/config
    echo '    fetch = +refs/heads/*:refs/remotes/origin/*' >> .git/config
    echo "[branch \"master\"]" >> .git/config
    echo "    remote = origin" >> .git/config
    echo "    merge = refs/heads/master" >> .git/config
    git add .
    git commit -m 'Init commit'
    git push /srv/git/$1 master:master
    echo 'unpacking site...'
    /bin/bash /srv/git/bin/bitrix_untar.sh $1
  else
    echo "There is no such a project"
    exit 1
  fi  
fi
