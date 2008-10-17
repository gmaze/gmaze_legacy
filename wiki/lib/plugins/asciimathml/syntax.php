<?php
  /**
  /**
    * Plugin AsciiMathML: Use ASCIIMathML for translating ASCII math notation to MathML and graphics.
    *
    * @license    GPL 2 (http://www.gnu.org/licenses/gpl.html)
    * @author     Mohammad Rahmani <m.rahmani@aut.ac.ir>
    *
    * This plugin uses ASCIIMathML.js version 1.4.8 Aug 30, 2007, (c) Peter Jipsen http://www.chapman.edu/~jipsen
    * Latest version at http://www.chapman.edu/~jipsen/mathml/ASCIIMathML.js
    * For changes see http://www.chapman.edu/~jipsen/mathml/asciimathchanges.txt
    * If you use it on a webpage, please send the URL to jipsen@chapman.edu
    * Note: This plugin ONLY SUPPORTS version 1.4.8 of ASCIIMathML.js
   */

if(!defined('DOKU_INC')) define('DOKU_INC',realpath(dirname(__FILE__).'/../../').'/');
if(!defined('DOKU_PLUGIN')) define('DOKU_PLUGIN',DOKU_INC.'lib/plugins/');
require_once(DOKU_PLUGIN.'syntax.php');

/**
 * All DokuWiki plugins to extend the parser/rendering mechanism
 * need to inherit from this class
 */
class syntax_plugin_asciimathml extends DokuWiki_Syntax_Plugin {

    /**
     * Get an associative array with plugin info.
     */
    function getInfo(){
        return array(
            'author' => 'Mohammad Rahmani',
            'email'  => 'm.rahmani@aut.ac.ir',
            'date'   => '2008-08-09',
            'name'   => 'ASCIIMathML Plugin',
            'desc'   => 'Translating ASCII math notation to MathML and graphics',
            'url'    => 'http://wiki.splitbrain.org/plugin:tutorial',
                     );
    }

    function getType(){ return 'formatting'; }
    function getPType(){ return 'normal'; }
    function getSort(){ return 450; }

     /**
     * Connect pattern to lexer
     */
    function connectTo($mode) {
        $this->Lexer->addEntryPattern('<acm>(?=.*?</acm>)',$mode,'plugin_asciimathml');
        $this->Lexer->addEntryPattern('<acmath>(?=.*?</acmath>)',$mode,'plugin_asciimathml');
    }

    function postConnect() {
        $this->Lexer->addExitPattern('</acm>','plugin_asciimathml');
        $this->Lexer->addExitPattern('</acmath>','plugin_asciimathml');
    }

    /**
     * Handler to prepare matched data for the rendering process.
     */
    function handle($match, $state, $pos, &$handler){
        switch ($state) {
        case DOKU_LEXER_ENTER :
            return array($state, preg_match($match, "/^<acm>/"));
            break;
        case DOKU_LEXER_MATCHED :
            break;
        case DOKU_LEXER_UNMATCHED :
            return array($state, $match);
            break;
        case DOKU_LEXER_EXIT :
            return array($state, preg_match($match, "/^<\/acm>/"));
            break;
        case DOKU_LEXER_SPECIAL :
            break;
        }
        return array($state, '');
    }

    /**
     * Handle the actual output creation.
     */
    function render($mode, &$renderer, $data) {
        if($mode == 'xhtml') {
            list($state, $match) = $data;
            switch ($state) {
            case DOKU_LEXER_ENTER :
                if ($match) {
                    $renderer->doc .= '<span class="acmath"> `';
                } else {
                    $renderer->doc .= '<div class="acmath"> `';
                }
                break;
            case DOKU_LEXER_MATCHED :
                break;
            case DOKU_LEXER_UNMATCHED :
                $renderer->doc .= $renderer->_xmlEntities($match);
                break;
            case DOKU_LEXER_EXIT :
                if ($match) {
                    $renderer->doc .= ' `</span>';
                } else {
                    $renderer->doc .= ' `</div>';
                }
                break;
            case DOKU_LEXER_SPECIAL :
                break;
            }
        }
        return false;
    }
}

//Setup VIM: ex: et ts=4 enc=utf-8 :
