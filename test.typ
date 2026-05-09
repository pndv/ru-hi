#let mytable(lbl) = {
  [
    #figure(
      table(columns: 1, [A]),
      caption: [test]
    ) #label(lbl)
  ]
}

#mytable("mylabel")



#let a(content) = $acute[content]$


this is acca[e]nt
this is a new line
