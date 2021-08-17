#! /bin/sh

imageName=mysql

if pullLatestDocker.sh -i $imageName
then
    # build new container
    echo "building new container"
    createContainer.sh
    purgeOldImages.sh -i $imageName
else
    echo "no image update, so nothing more to do"
    exit 1
fi
