#!/usr/bin/env bash


# get file name
fileName=$1
# read from data file and get length of words
lineNumber=1
while read -r line; do
  words=($line)
  for word in "${words[@]}"; do
    if [ "${lineNumber}" -eq "1" ]; then
      data="${data} \\\textbf{$word} &"
    else
      data="${data} $word &"
    fi
  done
  data=$(echo $data | sed 's|.$||g')
  len=$(echo $line | wc -w)
  lastLine=$(wc -l < $fileName.txt)
  if [ "${lineNumber}" -eq "1" ]; then
    data+="\\\\\ \\hline\n"
  elif [ "${lastLine}" -eq $((lineNumber + 1)) ]; then
    data+="\\\\\ \\hline\n"
  else
    data+="\\\\\ \n"
  fi
  lineNumber=$((lineNumber + 1))
done < $fileName.txt
data=$(echo $data | sed 's|_|\\\_|g')
file=$(echo $fileName | sed 's|_|\ |g')

columns=''
# generate the number of columns
for i in $(seq 1 $len); do
  columns="${columns}|c"
done
columns="${columns}|"


# now generate the table
echo -ne '\\begin{table}[H]
\\centering
\\begin{tabular}{'$columns'}
\\hline\n '$(echo $data)'
\\hline
\\end{tabular}
\\caption{Results of '$file'}
\\label{Results of '$file'}
\\end{table}
' > $fileName.tex
