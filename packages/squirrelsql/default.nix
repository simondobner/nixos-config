{ stdenv, fetchurl, unzip, jre }:

stdenv.mkDerivation rec {
  name = "squirrelsql-3.7.1";

  builder = ./builder.sh;

  src = fetchurl {
    url = https://sourceforge.net/projects/squirrel-sql/files/1-stable/3.7.1-plainzip/squirrelsql-3.7.1-standard.zip/download;
    sha256 = "1v141ply57k5krwbnnmz4mbs9hs8rbys0bkjz69gvxlqjizyiq23";
    name = "squirrelsql-3.7.1-standard.zip";
  };

  buildInputs = [ unzip ];

  inherit jre;

  meta = {
    homepage = http://squirrel-sql.sourceforge.net/;
    description = "Universal SQL Client";
    license = stdenv.lib.licenses.llgpl21;
  };
}
