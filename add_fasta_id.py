"""Script to add some id information in fasta header. 
Example :
>YP_588478.1 protein YjjZ [Escherichia coli str. K-12 substr. MG1655]
Call : python add_fasta_id.py seq.fasta GCF_000005845.2
Header will become
>GCF_000005845.2|YP_588478.1 protein YjjZ [Escherichia coli str. K-12 substr. MG1655]
"""

import sys
import gzip

if len(sys.argv) != 3:
    print("usage: python add_fasta_id.py <.fasta.gz file> <id to add>")
    exit()

fasta = sys.argv[1]
to_add = sys.argv[2]
f = gzip.open(fasta, "rb")
new_fasta = b''
for l in f:
    if l.startswith(b'>'):
        l_decode = l.decode()
        new_fasta += b">" + bytes(to_add, 'utf-8') + b'|' + bytes(l_decode.lstrip(">"), 'utf-8')
    else:
        new_fasta += l
f.close()
o = gzip.open(fasta, "wb")
o.write(new_fasta)
o.close()