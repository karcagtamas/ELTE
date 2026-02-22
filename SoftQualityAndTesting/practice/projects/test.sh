CURR="$PWD/$1"

echo $CURR

sudo docker run -i -t --rm -u gradle -v "$CURR":"$CURR" -w "$CURR" gradle gradle test
