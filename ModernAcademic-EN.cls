%% ModernAcademic-EN.cls
%% A modern, professional LaTeX class for academic papers (English version)
%% Designed for pdfLaTeX compilation
%% Author: Claude (Anthropic)
%% Version: 1.0 (2026-01-25)
%% License: MIT

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ModernAcademic-EN}[2026/01/25 v1.0 Modern Academic Paper Class (English)]

%% ============================================================================
%% 1. CLASS OPTIONS
%% ============================================================================

\newif\if@twocol
\@twocolfalse

\DeclareOption{singlecolumn}{\@twocolfalse}
\DeclareOption{twocolumn}{\@twocoltrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ExecuteOptions{singlecolumn}
\ProcessOptions\relax

% Load base class
\if@twocol
  \LoadClass[a4paper,10pt,twocolumn]{article}
\else
  \LoadClass[a4paper,11pt]{article}
\fi

%% ============================================================================
%% 2. REQUIRED PACKAGES
%% ============================================================================

% --- Encoding ---
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

% --- String manipulation (for theme color parsing) ---
\RequirePackage{xstring}

% --- Page Layout ---
\RequirePackage[
  a4paper,
  top=2.5cm,
  bottom=2.5cm,
  left=2.5cm,
  right=2.5cm,
  headheight=14pt,
  headsep=0.5cm,
  footskip=1cm
]{geometry}

% --- Typography ---
\RequirePackage{microtype}
\RequirePackage{setspace}

% --- Mathematics (load before newtxmath to avoid conflicts) ---
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}

% --- Fonts (pdfLaTeX compatible) ---
\RequirePackage{libertinus}        % Libertinus fonts
% --- Fonts (pdfLaTeX compatible) ---
\RequirePackage{libertinus}        % Libertinus fonts (automatically loads unicode-math in Xe/LuaLaTeX)
%\RequirePackage[libertinus,noamssymbols]{newtxmath}  % CONFLICT: Do not load with libertinus-otf
\RequirePackage{inconsolata}       % Monospace font

% --- Colors ---
\RequirePackage[table,xcdraw]{xcolor}

% Default theme colors
\definecolor{academicblue}{HTML}{1a2a6c}
\definecolor{linkblue}{HTML}{1a2a6c}
\definecolor{citegreen}{HTML}{2d5a27}
\definecolor{urlpurple}{HTML}{5c3566}
\definecolor{abstractbg}{HTML}{f8f9fa}
\definecolor{abstractborder}{HTML}{e9ecef}

% Theme color configuration interface
% Usage: \setthemecolor{b91c1c} (hex) or \setthemecolor{185,28,28} (RGB)
\newcommand{\setthemecolor}[1]{%
  \IfSubStr{#1}{,}{% RGB format: R,G,B
    \definecolor{academicblue}{RGB}{#1}%
    \definecolor{linkblue}{RGB}{#1}%
  }{% Hex format: RRGGBB (without #)
    \definecolor{academicblue}{HTML}{#1}%
    \definecolor{linkblue}{HTML}{#1}%
  }%
}

% Color configuration interfaces for functional colors
% Usage: \setlinkcolor{0000FF}
\newcommand{\setlinkcolor}[1]{\definecolor{linkblue}{HTML}{#1}}
\newcommand{\setcitecolor}[1]{\definecolor{citegreen}{HTML}{#1}}
\newcommand{\seturlcolor}[1]{\definecolor{urlpurple}{HTML}{#1}}

% --- Colored Boxes ---
\RequirePackage[most]{tcolorbox}

% --- Icons for social links ---
\RequirePackage{fontawesome5}

% --- Tables and Figures ---
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{array}
\RequirePackage{multirow}
\RequirePackage{caption}
\RequirePackage{subcaption}

\captionsetup{
  font={small},
  labelfont={bf, color=academicblue},
  labelsep=period,
  skip=8pt,
}

\captionsetup[sub]{
  font={footnotesize},
  labelfont={bf},
}

% --- Hyperlinks and References ---
\RequirePackage[
  colorlinks=true,
  linkcolor=academicblue,
  citecolor=citegreen,
  urlcolor=urlpurple,
  bookmarks=true,
  bookmarksnumbered=true,
  pdfstartview=FitH,
]{hyperref}

\RequirePackage[nameinlink, noabbrev]{cleveref}

% --- Bibliography ---
\RequirePackage[
  backend=biber,
  style=numeric-comp,
  sorting=none,
  maxbibnames=99,
  giveninits=true,
]{biblatex}

% --- Header and Footer ---
\RequirePackage{fancyhdr}

% --- Abstract ---
\RequirePackage{abstract}

% --- Section Titles ---
\RequirePackage{titlesec}

%% ============================================================================
%% 3. PAGE STYLE
%% ============================================================================

\newcommand{\@shorttitle}{}
\newcommand{\@shortauthor}{}

% First page style with optional logo in header
\fancypagestyle{plain}{%
  \fancyhf{}
  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

% First page style with logo in header right
\fancypagestyle{firstpageheaderlogo}{%
  \fancyhf{}
  \fancyhead[R]{\@titlelogo}
  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

\fancypagestyle{mainmatter}{%
  \fancyhf{}
  \fancyhead[L]{\small\itshape\@shorttitle}
  \fancyhead[R]{\small\itshape\@shortauthor}
  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0.4pt}
  \renewcommand{\footrulewidth}{0pt}
}

\pagestyle{mainmatter}

%% ============================================================================
%% 4. TITLE AND AUTHOR COMMANDS
%% ============================================================================

\newcommand{\@affiliation}{\@empty}
\newcommand{\@email}{\@empty}
\newcommand{\@keywords}{\@empty}
\newcommand{\@abstract}{\@empty}
\newcommand{\@titlepreskip}{0pt}
\newcommand{\@titlelogo}{\@empty}
\newcommand{\@titlelogogap}{0.3em}

% Setter for the gap between logo and title
\newcommand{\settitlelogogap}[1]{\renewcommand{\@titlelogogap}{#1}}

% Logo position toggles: three independent switches (all default to false)
% Each position can be enabled independently, and multiple positions can be active simultaneously
\newif\if@logointitle
\newif\if@logoinheader
\newif\if@logoinabstract
\@logointitlefalse
\@logoinheaderfalse
\@logoinabstractfalse

% User commands to enable logo in specific positions
\newcommand{\showlogointitle}{\@logointitletrue}
\newcommand{\hidelogointitle}{\@logointitlefalse}
\newcommand{\showlogoinheader}{\@logoinheadertrue}
\newcommand{\hidelogoinheader}{\@logoinheaderfalse}
\newcommand{\showlogoinabstract}{\@logoinabstracttrue}
\newcommand{\hidelogoinabstract}{\@logoinabstractfalse}

% Social links storage (list of {icon}{text}{url} triplets)
\newcommand{\@sociallinks}{}
% Add a social link: \addsociallink{\faGithub}{GitHub}{https://github.com/user/repo}
\newcommand{\addsociallink}[3]{%
  \g@addto@macro\@sociallinks{\@socialitem{#1}{#2}{#3}}%
}
% Internal: render a single social link item
\newcommand{\@socialitem}[3]{%
  \href{#3}{#1\,#2}\hspace{1em}%
}
% Clear all social links
\newcommand{\clearsociallinks}{\renewcommand{\@sociallinks}{}}

% Visibility toggle for keywords
\newif\ifshowkeywords
% By default do not show Keywords block. When user calls `\keywords{...}`
% the macro below will set the content and enable the keywords display.
\showkeywordsfalse

% Control whether abstract footnotes are enabled (loads footnote package when true)
\newif\ifabstractfootnotes
\abstractfootnotestrue
\newcommand{\disableabstractfootnotes}{\abstractfootnotesfalse}

\newcommand{\shorttitle}[1]{\renewcommand{\@shorttitle}{#1}}
\newcommand{\shortauthor}[1]{\renewcommand{\@shortauthor}{#1}}
\newcommand{\affiliation}[1]{\renewcommand{\@affiliation}{#1}}
\newcommand{\email}[1]{\renewcommand{\@email}{#1}}
\newcommand{\keywords}[1]{\renewcommand{\@keywords}{#1}\showkeywordstrue}
\renewcommand{\abstract}[1]{\renewcommand{\@abstract}{#1}}

% Title preskip configuration (for logo/institution space above title)
% Usage: \settitlepreskip{2cm}
\newcommand{\settitlepreskip}[1]{\renewcommand{\@titlepreskip}{#1}}

% Title logo configuration (institution logo above title)
% Usage: \titlelogo{path/to/logo.png} or \titlelogo[height=1.5cm]{path/to/logo.png}
\newcommand{\titlelogo}[2][height=1.2cm]{\renewcommand{\@titlelogo}{\includegraphics[#1]{#2}}}

% Title logo content (for TikZ or other custom content)
% Usage: \titlelogocontent{\usebox{\mylogo}} or \titlelogocontent{...TikZ code...}
\newcommand{\titlelogocontent}[1]{\renewcommand{\@titlelogo}{#1}}

%% ============================================================================
%% 5. TITLE PAGE DESIGN
%% ============================================================================

% Base abstract box style
\tcbset{
  abstractboxbase/.style={
    enhanced,
    colback=abstractbg,
    colframe=abstractborder,
    boxrule=0.5pt,
    arc=4pt,
    left=12pt,
    right=12pt,
    top=10pt,
    bottom=10pt,
    fontupper=\small,
    before skip=1em,
    after skip=1.5em,
  }
}

% Abstract box without overlay
\newtcolorbox{abstractbox}{abstractboxbase}

% Abstract box with social links only (bottom-left)
\newtcolorbox{abstractboxsocial}{
  abstractboxbase,
  overlay={
    \node[anchor=south west, inner sep=0pt, xshift=12pt, yshift=8pt, font=\footnotesize]
      at (frame.south west) {\@sociallinks};
  }
}

% Abstract box with logo only (bottom-right)
\newtcolorbox{abstractboxlogo}{
  abstractboxbase,
  overlay={
    \node[anchor=south east, inner sep=0pt, xshift=-12pt, yshift=8pt]
      at (frame.south east) {\@titlelogo};
  }
}

% Abstract box with both social links (bottom-left) and logo (bottom-right)
\newtcolorbox{abstractboxboth}{
  abstractboxbase,
  overlay={
    \node[anchor=south west, inner sep=0pt, xshift=12pt, yshift=8pt, font=\footnotesize]
      at (frame.south west) {\@sociallinks};
    \node[anchor=south east, inner sep=0pt, xshift=-12pt, yshift=8pt]
      at (frame.south east) {\@titlelogo};
  }
}

% Optionally allow footnotes inside the abstract box to be typeset as normal page footnotes
% Load the `footnote` package and enable saving only when abstractfootnotes is true
\ifabstractfootnotes
  \RequirePackage{footnote}
  \makesavenoteenv{abstractbox}
  \makesavenoteenv{abstractboxsocial}
  \makesavenoteenv{abstractboxlogo}
  \makesavenoteenv{abstractboxboth}
\fi

% Internal command to render abstract box content
\newcommand{\@abstractboxcontent}{%
  \begin{center}
    {\large\@author}%
    \ifx\@affiliation\@empty\else
      \\[0.4em]
      {\small\itshape\@affiliation}%
    \fi
    \ifx\@email\@empty\else
      \\[0.2em]
      {\small\ttfamily\@email}%
    \fi
  \end{center}

  \ifx\@abstract\@empty\else
    \vspace{0.5em}
    {\centering\textcolor{abstractborder}{\rule{0.3\textwidth}{0.4pt}}\par}
    \vspace{0.5em}

    \noindent\textbf{\sffamily\color{academicblue}Abstract.}\quad
    \@abstract

    \ifshowkeywords
      \ifx\@keywords\@empty\else
        \vspace{0.6em}

        \noindent\textbf{\sffamily\color{academicblue}Keywords:}\quad\@keywords
      \fi
    \fi
  \fi

  % Add vertical space if social links or abstract-logo is present
  \ifx\@sociallinks\@empty\else
    \vspace{1.2em}
  \fi
  \if@logoinabstract
    \ifx\@titlelogo\@empty\else
      \vspace{1.2em}
    \fi
  \fi
}

\newcommand{\@maketitleblock}{%
  % Pre-title space and logo (only if enabled for title position)
  \if@logointitle
    \ifx\@titlelogo\@empty\else
      \vspace*{\@titlepreskip}
      {%
        \centering
        \@titlelogo\par
      }%
      \vspace{\@titlelogogap}
    \fi
  \else
    \ifdim\@titlepreskip>0pt
      \vspace*{\@titlepreskip}
    \fi
  \fi
  \begin{center}
    {\LARGE\bfseries\sffamily\color{academicblue}\@title\par}
    \vspace{1.2em}
  \end{center}

  % Select appropriate abstract box based on configuration
  \if@logoinabstract
    % Logo enabled in abstract box
    \ifx\@titlelogo\@empty
      % No logo defined
      \ifx\@sociallinks\@empty
        \begin{abstractbox}\@abstractboxcontent\end{abstractbox}
      \else
        \begin{abstractboxsocial}\@abstractboxcontent\end{abstractboxsocial}
      \fi
    \else
      % Logo defined
      \ifx\@sociallinks\@empty
        \begin{abstractboxlogo}\@abstractboxcontent\end{abstractboxlogo}
      \else
        \begin{abstractboxboth}\@abstractboxcontent\end{abstractboxboth}
      \fi
    \fi
  \else
    % Logo not in abstract box
    \ifx\@sociallinks\@empty
      \begin{abstractbox}\@abstractboxcontent\end{abstractbox}
    \else
      \begin{abstractboxsocial}\@abstractboxcontent\end{abstractboxsocial}
    \fi
  \fi
}

% Helper to select first page style based on logo position
\newcommand{\@selectfirstpagestyle}{%
  \if@logoinheader
    \ifx\@titlelogo\@empty
      \thispagestyle{plain}%
    \else
      \thispagestyle{firstpageheaderlogo}%
    \fi
  \else
    \thispagestyle{plain}%
  \fi
}

\if@twocol
  \renewcommand{\maketitle}{%
    \twocolumn[%
      \@maketitleblock
    ]%
    \@selectfirstpagestyle
  }
\else
  \renewcommand{\maketitle}{%
    \@maketitleblock
    \@selectfirstpagestyle
  }
\fi

%% ============================================================================
%% 6. SECTION FORMATTING
%% ============================================================================

\titleformat{\section}
{\normalfont\large\bfseries\sffamily\color{academicblue}}
{\thesection}{1em}{}

\titleformat{\subsection}
{\normalfont\normalsize\bfseries\sffamily}
{\thesubsection}{1em}{}

\titleformat{\subsubsection}
{\normalfont\normalsize\itshape}
{\thesubsubsection}{1em}{}

\titlespacing*{\section}{0pt}{2ex plus 1ex minus .2ex}{1ex plus .2ex}
\titlespacing*{\subsection}{0pt}{1.5ex plus 1ex minus .2ex}{0.8ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{1ex plus 0.5ex minus .2ex}{0.5ex plus .2ex}

%% ============================================================================
%% 7. THEOREM ENVIRONMENTS
%% ============================================================================

\theoremstyle{plain}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{proposition}[theorem]{Proposition}

\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{example}[theorem]{Example}

\theoremstyle{remark}
\newtheorem*{remark}{Remark}

%% ============================================================================
%% 8. UTILITY SETTINGS
%% ============================================================================

\setstretch{1.15}
\setlength{\parindent}{1.5em}
\setlength{\parskip}{0.3ex plus 0.1ex minus 0.1ex}

\renewcommand{\topfraction}{0.9}
\renewcommand{\bottomfraction}{0.8}
\renewcommand{\textfraction}{0.1}
\renewcommand{\floatpagefraction}{0.8}

\if@twocol
  \setlength{\columnsep}{1.5em}
\fi

\endinput
