ENTRY
  { 
    address
    author
    edition
    pages
    publisher
    series
    title
    url
    year
  }
  {}
  { label }
INTEGERS { output.state before.all mid.sentence after.sentence after.block }
FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}
STRINGS { s t}
FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block = 
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}
FUNCTION {output.nonnull.nostate}
{ 's :=
  output.state after.block =
    { add.period$ write$
      newline$
      "\newblock " write$
    }
    'write$
  if$
  s
}
FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}
FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}
INTEGERS { nameptr namesleft numnames posothers showetal}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}
FUNCTION {bibinfo.check}
{ swap$
  duplicate$ missing$
    {
      pop$ pop$
      ""
    }
    { duplicate$ empty$
        {
           swap$ pop$
        }
        { swap$
          pop$
        }
      if$
    }
  if$
}
FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}
FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}
FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}
FUNCTION {add.blank}
{  " " * before.all 'output.state :=
}
FUNCTION {add.colon}
{ duplicate$ empty$
    'skip$
    { ":" * add.blank }
  if$
}
FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}
FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}
FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}
FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}
FUNCTION {bolden}
{ duplicate$ empty$
    { pop$ "" }
    { "\textbf{" swap$ * "}" * }
  if$
}
FUNCTION {italize}
{ duplicate$ empty$
    { pop$ "" }
    { "\textit{" swap$ * "}" * }
  if$
}
FUNCTION {scaps}
{ duplicate$ empty$
    { pop$ "" }
    { "\textsc{" swap$ * "}" * }
  if$
}
FUNCTION {anglequote}
{ duplicate$ empty$
    { pop$ "" }
    { "<<" swap$ * ">>" * }
  if$
}
FUNCTION {singlequote}
{ duplicate$ empty$
    { pop$ "" }
    { "'{}" swap$ * "'{}" * }
  if$
}
FUNCTION {doublequote}
{ duplicate$ empty$
    { pop$ "" }
    { "``{}" swap$ * "''{}" * }
  if$
}
FUNCTION {format.names.author}
{
  's :=

  #1 'nameptr :=
  s num.names$ 'numnames :=

  numnames 'namesleft :=
  #0 'posothers :=
    { namesleft #0 > }
    { s nameptr "{ll }{ff}" format.name$ 't :=
      t "others" =
         { nameptr 'posothers := }
         'skip$
       if$
       nameptr #1 + 'nameptr :=
       namesleft #1 - 'namesleft :=
    }
  while$

  #0 'showetal :=

  numnames #3 >
    { #2 'numnames :=
      #1 'showetal :=
    }
    { numnames #3 =
        { posothers #0 >
          { #1 'showetal :=
            #2 'numnames :=
          }
          'skip$
         if$
         }
         { posothers #0 >
             { #1 'showetal :=
               #1 'numnames -
             }
             'skip$
           if$
         }
       if$
    }
  if$

  #1 'nameptr :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ll }{ff}" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { showetal #0 >
                { ", " * t * }
                { " and " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$

  showetal #0 >
    { " et~al." * }
    'skip$
  if$
}

FUNCTION {format.names.editor}
{
  's :=

  #1 'nameptr :=
  s num.names$ 'numnames :=

  numnames 'namesleft :=
  #0 'posothers :=
    { namesleft #0 > }
    { s nameptr "" format.name$ 't :=
      t "others" =
         { nameptr 'posothers := }
         'skip$
       if$
       nameptr #1 + 'nameptr :=
       namesleft #1 - 'namesleft :=
    }
  while$

  #0 'showetal :=

  numnames #3 >
    { #2 'numnames :=
      #1 'showetal :=
    }
    { numnames #3 =
        { posothers #0 >
          { #1 'showetal :=
            #2 'numnames :=
          }
          'skip$
         if$
         }
         { posothers #0 >
             { #1 'showetal :=
               #1 'numnames -
             }
             'skip$
           if$
         }
       if$
    }
  if$

  #1 'nameptr :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { showetal #0 >
                { ", " * t * }
                { " and " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$

  showetal #0 >
    { " et~al." * }
    'skip$
  if$
}

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }


FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {format.title.short}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  #1 #3 substring$
}
FUNCTION {format.book.author}
{ author
  duplicate$ empty$ 'skip$
    { format.names.author }
  if$
  "author" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {format.book.title}
{ title
  "title" bibinfo.check
  duplicate$ empty$ 'skip$
   {
     italize
   }
  if$
}
FUNCTION {format.book.edition}
{ edition
  "edition" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {format.book.address}
{ address
  "address" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {format.book.publisher}
{ publisher
  "publisher" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {format.book.year}
{ year
  "year" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {format.book.pages}
{ pages
  "pages" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {format.book.series}
{ series
  "series" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {book}
{ output.bibitem
  author empty$
  'skip$
    {         format.book.author
       output.nonnull.nostate
       ". "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  title empty$
  'skip$
    {         format.book.title
       output.nonnull.nostate
       ". "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  edition empty$
  'skip$
    {         format.book.edition
       output.nonnull.nostate
       ". "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  address empty$
  'skip$
    {         format.book.address
       output.nonnull.nostate
       " : "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  publisher empty$
  'skip$
    {         format.book.publisher
       output.nonnull.nostate
       ", "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  year empty$
  'skip$
    {         format.book.year
       output.nonnull.nostate
       ". "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  pages empty$
  'skip$
    {         format.book.pages
       output.nonnull.nostate
       " pages. "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  series empty$
  'skip$
    {  "("
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate       format.book.series
       output.nonnull.nostate
       ")"
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  fin.entry
}
FUNCTION {format.misc.author}
{ author
  duplicate$ empty$ 'skip$
    { format.names.author }
  if$
  "author" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {format.misc.title}
{ title
  "title" bibinfo.check
  duplicate$ empty$ 'skip$
   {
     italize
   }
  if$
}
FUNCTION {format.misc.url}
{ url
  "url" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {format.misc.year}
{ year
  "year" bibinfo.check
  duplicate$ empty$ 'skip$
   {
   }
  if$
}
FUNCTION {misc}
{ output.bibitem
  author empty$
  'skip$
    {         format.misc.author
       output.nonnull.nostate
       ". "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  title empty$
  'skip$
    {         format.misc.title
       output.nonnull.nostate
       " [en ligne]. "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  url empty$
  'skip$
    {         format.misc.url
       output.nonnull.nostate
       " "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  year empty$
  'skip$
    {  "(consult� le "
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate       format.misc.year
       output.nonnull.nostate
       " )"
  duplicate$ empty$ 'skip$
   {
   }
  if$
output.nonnull.nostate    }
  if$
  new.block
  fin.entry
}
READ
STRINGS { longest.label }

INTEGERS { longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}
EXECUTE {begin.bib}
EXECUTE {init.state.consts}
ITERATE {call.type$}
FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}EXECUTE {end.bib}