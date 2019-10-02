import sys 
import pickle

if len(sys.argv) != 3: 
    print("usage : python parse_mmseqs_clusters.py <input cluster results.tsv> <cluster output.tsv>")
    exit()


def parse_clusters(clustering_results):
    print("PARSE CLUSTERS...")
    dic_cluster = {}
    nb_l = 0 
    with open(clustering_results) as f:
        for l in f:
            nb_l += 1
            if nb_l % 1000000 == 0:
                print(nb_l)
            rep = l.split("\t")[0].split(" ")[0].lstrip('"')
            seq = l.split("\t")[1].split(" ")[0].lstrip('"')
            if rep not in dic_cluster:
                dic_cluster[rep]=[]
            dic_cluster[rep].append(seq)
    
    print(len(dic_cluster), "clusters")
    print("RENAME CLUSTERS...")
    dic_cluster_nb = {}
    cluster_nb = 0
    for c in dic_cluster:
        dic_cluster_nb[cluster_nb] = dic_cluster[c]
        cluster_nb += 1 

    return dic_cluster_nb  

def write_parsing(dic_cluster,output):
    o = open(output, "w")
    for c in dic_cluster:
        o.write(str(c) + "\t" + ";".join(dic_cluster[c]) + "\n")
    o.close()    

def __main__():
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    dic_cluster = parse_clusters(input_file)
    print("SERIALIZE...")
    write_parsing(dic_cluster, output_file)

__main__()    