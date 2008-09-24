%% File: thesis.cls
%% To produce a PhD thesis for digital print and online publishing

%% Revisited: Guillaume Maze
%% Feb. 2006
%% Adapted to ``Université Pierre et Marie Curie'' PhD manuscript
%%
%% J'ai fais une page de garde qui prend en option:
%%* l'universite:  \university{}
%%* eventuellement une cotutelle (option cot) puis: \universityb{}
%%* la specialite: \speciality{}
%%* l'auteur, et oui la star qui vient d'ecrire tout ca: \author{}
%%* le titre: \title{}
%%* eventuellement la date de soutenance (option show) puis: \submitteddate{}
%%* puis le jury dans: \jury{}
%%     par exemple on aura:
% \jury{{\large LA STAR      } & {\large Directeur de thèse}   \\
%       {\large LA SOUS-STAR } & {\large Co-directeur de thèse}\\
%       {\large LE TUEUR 1   } & {\large Rapporteur }\\
%       {\large LE TUEUR 2   } & {\large Rapporteur} \\
%       {\large LE TUEUR 3   } & {\large Examinateur }\\
%       {\large LE TUEUR 4   } & {\large Examinateur }\\
%       {\large ET POURQUOI PAS UN PIC ASSIETTE} & {\large Invit\'e } }
%%* et enfin le labo ou tu as passe tant d'heures ces dernieres annees: \labs{}
% Il y a aussi quelques macros racourcis:
% \deriv{}{} pour la derivee partielle d'un truc
% \fig{OPTION}{FICHIER}{CAPTION} pour une figure centree
% \pageblanche pour inserer une page blanche



%%
%% First Author (Mais il ne doit pas en rester grand chose !):
%% Dieter Schmitt
%% Max Planck Institute for Solar System Research
%% Max-Planck-Str. 2
%% D-37191 Katlenburg-Lindau
%% Germany
%% Email: schmitt@linmpi.mpg.de
%%
%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\typeout{^^J Hello, this is my experimental LaTeX package for PhD manuscript in french ... ^^J }
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\def\MyProvidesClass#1 [#2 #3 #4]
  {\ProvidesClass{#1}[#2 #3 #4]%
   \def\clsname{#1}\def\clsdate{#2}\def\clsversion{#3}\def\clsinfo{#4}}
\MyProvidesClass{thesis} [2006/03/10 v1 CoolPhD]
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options:
%%
\newif\if@upmc
\newif\if@sub
\newif\if@cotutelle
\newif\if@hyper
\newif\if@pdf
\DeclareOption{cot}{\@cotutelletrue}
\DeclareOption{upmc}{\@upmctrue}
\DeclareOption{show}{\@subtrue}
\DeclareOption{hyper}{\@hypertrue}
\DeclareOption{pdf}{\@pdftrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions
\LoadClass[12pt]{book}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Page format:
%%
% Format a4 classique quoiqu'il arrive:
\setlength{\paperheight}{29.7cm}
\setlength{\paperwidth}{21.0cm}
% \setlength{\textheight}{23.5cm}
% \setlength{\textwidth}{15.0cm}
% \addtolength{\textwidth}{.5cm}
% \addtolength{\hoffset}{-.25cm}
% \addtolength{\textheight}{1.cm}
% %\addtolength{\voffset}{-.75cm}

\setlength{\textheight}{22.5cm}
\setlength{\textwidth}{15.5cm}
\setlength{\headheight}{2.0cm}
\setlength{\headsep}{0.8cm}
\setlength{\topskip}{12pt}
\setlength{\footskip}{30pt}
\setlength{\oddsidemargin}{0.46cm}
\setlength{\evensidemargin}{0.46cm}
\setlength{\topmargin}{-2.0cm}

\if@pdf
   \setlength{\pdfpageheight}{29.7cm}
   \setlength{\pdfpagewidth}{21.0cm}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Graphic files and packages:
%%
\if@pdf
   \IfFileExists{graphicx.sty}{\RequirePackage[pdftex]{graphicx}% pdfLaTeX
   \DeclareGraphicsExtensions{.pdf,.png,.jpg}}{}
   \IfFileExists{color.sty}{\RequirePackage[pdftex]{color}}{}
   \pdfinfo{/Creator (diss.cls version \clsversion)}
\else%
   \IfFileExists{graphicx.sty}{\RequirePackage[dvips]{graphicx}% LaTeX
   \DeclareGraphicsExtensions{.eps,.ps}}{}
   \IfFileExists{color.sty}{\RequirePackage{color}}{}
\fi
%% Les packages:
\IfFileExists{times.sty}{\RequirePackage{times}}{}
\IfFileExists{natbib.sty}{\RequirePackage{natbib}}{}
\bibpunct{(}{)}{,}{a}{}{,}
\IfFileExists{epsfig.sty}{\RequirePackage{epsfig}}{}
\IfFileExists{fancyhdr.sty}{\RequirePackage{fancyhdr}}{}
\IfFileExists{tocbibind.sty}{\RequirePackage{tocbibind}}{}
\IfFileExists{fontenc.sty}{\RequirePackage[T1]{fontenc}}{}
\IfFileExists{inputenc.sty}{\RequirePackage[latin1]{inputenc}}{}
\IfFileExists{babel.sty}{\RequirePackage[french]{babel}}{}
\IfFileExists{url.sty}{\RequirePackage{url}}{}
\IfFileExists{amssymb.sty}{\RequirePackage{amssymb}}{}
\IfFileExists{amsmath.sty}{\RequirePackage{amsmath}}{}
\IfFileExists{ifthen.sty}{\RequirePackage{ifthen}}{}
\IfFileExists{array.sty}{\RequirePackage{array}}{}
\IfFileExists{multicol.sty}{\RequirePackage{multicol}}{}


%%
      \def\captionsenglish{%
      \def\acknowname{Acknowledgement}%
      \def\refname{References}%
      \def\abstractname{Abstract}%
%     \def\appendixname{Appendix}%
      \def\figurename{Figure}%
      \def\tablename{Table}}
%%
\if@hyper\IfFileExists{hyperref.sty}{\RequirePackage{hyperref}}{}\fi
%%
\DeclareRobustCommand*{\vect}[1]{\ensuremath{%
\mathchoice{\mbox{\boldmath$\displaystyle#1$}}
           {\mbox{\boldmath$\textstyle#1$}}
           {\mbox{\boldmath$\scriptstyle#1$}}
           {\mbox{\boldmath$\scriptscriptstyle#1$}}}}
%%
\DeclareRobustCommand*{\chem}[1]{\ensuremath{\mathrm{#1}}}
\DeclareRobustCommand*{\unit}[1]{\def~{\,}\ensuremath{\mathrm{#1}}}
%%
\setcounter{topnumber}{2}
\def\topfraction{1.}
\setcounter{bottomnumber}{1}
\def\bottomfraction{1.}
\setcounter{totalnumber}{3}
\def\textfraction{0.}
\def\floatpagefraction{.7}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}
%%
%\sloppy\clubpenalty4000\widowpenalty4000
%%
\def\speciality#1{\def\@speciality{#1}}   \def\@speciality{???}
\def\university#1{\def\@university{#1}}   \def\@university{???}
\def\universityb#1{\def\@universityb{#1}} \def\@universityb{???}
\def\labs#1{\def\@labs{#1}}               \def\@labs{???}
\def\jury#1{\def\@jury{#1}}               \def\@jury{???}
\def\submitteddate#1{\def\@subdate{#1}}   \def\@subdate{???}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE DE GARDE et son verso
\def\maketitle{%
\begin{titlepage}
\if@upmc

\begin{center}
\if@cotutelle
      {\Large {\bf  THESE DE DOCTORAT DE L'UNIVERSITE \@university}} \\[2mm]
      en cotutelle avec \\[2mm]
      {\large {\bf l'UNIVERSITE \@universityb}} \\[8mm] 
\else
      {\Large {\bf  THESE DE DOCTORAT DE L'UNIVERSITE \@university}} \\[12mm]
\fi
      {\large Spécialité} \\[2.5mm] 
      {\Large{\bf \@speciality}} \\[8mm]      
      {\large Présentée par}\\[2.5mm]
      {\Large{\bf \@author}}\\[8mm]

%      {\large Pour obtenir le grade de} \\[2.5mm]
%      {\Large DOCTEUR de l'UNIVERSITE PARIS VI}\\[8mm]

      \end{center}

\if@sub
%      \vspace{4mm}
%      Sujet de la thèse:
      \begin{center}
      \begin{tabular}{|p{14cm}|} \hline
       \begin{center}{\Huge{\bf \@title }} \end{center}\\ \hline
      \end{tabular}
      \end{center} 

      \vspace{8mm}
      \begin{center}
        soutenue le \@subdate
      \end{center} 
\else
      \vspace{8mm}
%      Sujet de la thèse:
      \begin{center}
      \begin{tabular}{|p{14cm}|} \hline
       \begin{center}{\Huge{\bf \@title }} \end{center}\\ \hline
      \end{tabular}
      \end{center}
      \vspace{8mm}
\fi

      \vspace{4mm}
      devant le jury composé de:\\
      \begin{center}
      \begin{tabular}{lr}
      \@jury
      \end{tabular}
      \end{center}

      \vspace{9mm}
      Thèse préparée aux:\\%[1.5mm]
      \begin{center}\begin{tabular}{c}
      \@labs
      \end{tabular}\end{center}

\fi
\IfFileExists{firstpage.tex}{\include{firstpage}}
{Please provide file firstpage.tex}\fi
\end{titlepage}
\newpage % second page
\thispagestyle{empty}
      \IfFileExists{secondpage.tex}{\include{secondpage}}
      {Please provide file secondpage.tex}
} % end of maketitle definition

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ET PUIS TOUT LE RESTE NE VRAC:
%%
\newenvironment{cfig}{\begin{figure}[t]\begin{center}}{\end{center}\end{figure}}
%%
\def\chaptername{}
\def\appendixname{}
%%
\pagestyle{fancy}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter\hskip2ex #1}
   {\thechapter\hskip2ex #1}}
\renewcommand{\sectionmark}[1]{\markright{\thesection\hskip2ex #1}}
\fancyhf{}
\fancyhead[LE]{\nouppercase{\leftmark}}
\fancyhead[RO]{\nouppercase{\rightmark}}
\fancyfoot[LE,RO]{\thepage}
\renewcommand{\footrulewidth}{0pt}
\fancypagestyle{plain}{\fancyhf{}\fancyfoot[LE,RO]{\thepage}%
   \renewcommand{\headrulewidth}{0pt}\renewcommand{\footrulewidth}{0pt}}
%%
% avoids headings on otherwise empty pages before a new chapter
\def\cleardoublepage{\clearpage\if@twoside\ifodd\c@page\else
   \hbox{}\thispagestyle{empty}\newpage
   \if@twocolumn\hbox{}\newpage\fi\fi\fi}
%%
%\def\@schapter#1{\addcontentsline{toc}{chapter}{#1} % for toc
%   \@mkboth{#1}{#1}                                 % headings
%   \if@twocolumn\@topnewpage[\@makeschapterhead{#1}]
%   \else\@makeschapterhead{#1}\@afterheading\fi}
%
% problem: adds also toc to toc
%%
\def\@makechapterhead#1{\vspace*{50\p@}{\parindent\z@\raggedright
   \normalfont\interlinepenalty\@M\Huge\bfseries{%
   \@hangfrom{\hskip\z@\relax\thechapter\hskip2ex}#1\@@par}
   \par\nobreak\vskip40\p@}}


% Mathematique:
\def\deriv#1#2{ \frac{\partial {#1} }{ \partial {#2} }}

% Insertion figures:
\def\fig#1#2#3{
\begin{figure*}
  \begin{center}\noindent\includegraphics[{#1}]{{#2}}
    \caption{{#3}}
  \end{center}
\end{figure*}
}
\def\onecol{20pc}
\def\twocol{36pc}
\def\pageblanche{\newpage $ {\rm \; \;} $ \thispagestyle{empty} \newpage}


%%
%% End of file `thesis.cls'.
