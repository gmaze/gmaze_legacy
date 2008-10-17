/*
 This script installs the ASCIIMathML JavaScript
 to be used through "asciimath" plugin in Dokuwiki
  Mohammad Rahmani
  Date: Friday, 25 Jul. 2008  10:14:40
  Rev. 0: Trial
 
    * This plugin uses ASCIIMathML.js version 1.4.8 Aug 30, 2007, (c) Peter Jipsen http://www.chapman.edu/~jipsen
    * Latest version at http://www.chapman.edu/~jipsen/mathml/ASCIIMathML.js
    * For changes see http://www.chapman.edu/~jipsen/mathml/asciimathchanges.txt
    * If you use it on a webpage, please send the URL to jipsen@chapman.edu
    * Note: This plugin ONLY SUPPORTS version 1.4.8 of ASCIIMathML.js 
  
  
*/
// full url to ASCIIMathML installation

var ASCIIMathMLURL = '/lib/plugins/asciimathml/main/ASCIIMathML148.js';

document.write('<script type="text/javascript" src="' + ASCIIMathMLURL + '"></script>');


function installASCIIMathML()
{
    ASCIIMathML.Process(document);
}


addInitEvent(installASCIIMathML);

