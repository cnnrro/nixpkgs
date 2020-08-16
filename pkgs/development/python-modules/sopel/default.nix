{ stdenv, buildPythonPackage, fetchPypi, isPyPy
, dnspython
, geoip2
, ipython
, praw
, pyenchant
, pygeoip
, pytest
, python
, pytz
, xmltodict
}:

buildPythonPackage rec {
  pname = "sopel";
  version = "7.0.6";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e394d9797e221f90a95e5eb9987e8c1faf4f2488964f521e8ca1628798f0a38";
  };

  propagatedBuildInputs = [
    dnspython
    geoip2
    ipython
    praw
    pyenchant
    pygeoip
    pytz
    xmltodict
  ];

  # remove once https://github.com/sopel-irc/sopel/pull/1653 lands
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "praw<6.0.0" "praw<7.0.0"
  '';

  checkInputs = [ pytest ];

  checkPhase = ''
    HOME=$PWD # otherwise tries to create tmpdirs at root
    pytest .
  '';

  meta = with stdenv.lib; {
    description = "Simple and extensible IRC bot";
    homepage = "http://sopel.chat";
    license = licenses.efl20;
    maintainers = with maintainers; [ mog ];
  };
}
