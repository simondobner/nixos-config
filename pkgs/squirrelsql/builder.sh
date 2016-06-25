source $stdenv/setup

unzip $src

jar=$(ls */*.jar)

mkdir -p $out
mv squirrelsql-3.7.1-standard/* $out
chmod +x $out/*.sh

mkdir -p $out/bin
cat > $out/bin/squirrelsql <<EOF
#! $SHELL -e
$out/squirrel-sql.sh
EOF
chmod +x $out/bin/squirrelsql
