sublime text

sublime text 3 开始强制收费了 :(	
# AA
## plugins

<M>-<S>-P

### SmartMarkdown for Sublime Text 2 & 3
https://github.com/demon386/SmartMarkdown

Smart Headline folding / unfolding. Right now you can fold / unfold headlines by pressing TAB on it. I assume you use the following formats: # Section; ## Subsection; ### Subsubsection ...
Global Headline Folding / unfolding. Shift+Tab to Fold / Unfold all at any position.
Smart Order / Unordered list. When editing lists, you can just press ENTER and this plugin will automatically continue the list. Once the content of the list becomes empty it will stop.
Move between headlines.
Use Ctrl+c Ctrl+n to move to the next headline (any level); Ctrl+c Ctrl+p to the previous one, for Mac. (**Ctrl+; Ctrl+n** and Ctrl+; Ctrl+p for Windows and Linux)
Use Ctrl+c Ctrl+f to move to the next headline (same level or higher level); Ctrl+c Ctrl+b to the previous one, for Mac. (**Ctrl+; Ctrlf** and Ctrl+; Ctrl+b for Windows and Linux)
Adjust headline level Added by David Smith.
Super+Shift+, for decreasing and Super+Shift+. for increasing headline levels.
Smart table
Currently, the smart table suppose only the Grid table format of Pandoc. Use monospaced fonts, otherwise it would appear bizarre.
The behavior is like the table in Org-mode. If you are unfamiliar with Org-mode, just use | (vertical line) to separate the column (e.g. | header1 | header 2 |), and use the TAB to reformat the table at point. Everything would fall into the place. Add +- and then press TAB for adding separator between rows. Add += and then press TAB for adding separator between header and the table body. Read the Grid tables section of Pandoc Userg's Guide for more information.
Use TAB to move forward a cell in table, Shift+TAB to move backward.
Personally I plan to use grid table as a basis and add command for converting to other table formats if necessary.
Basic Pandoc integration with Pandoc By integrating SublimePandoc. Added by DanielMe.
Note: If you need to generate PDF output, please make sure you have pdflatex available (MacTeX for Mac, or TeX Live for other OS). Please also specify "tex_path" in the package settings (Preference - Package Settings - SmartMarkdown - Settings - User (see Settings - Default as an example.))