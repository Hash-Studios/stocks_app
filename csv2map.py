import csv

l = []
with open('BSE Codes - BSE_metadata.csv', mode='r') as infile:
    reader = csv.reader(infile)
    with open('BSE Codes - BSE_metadata_new.csv', mode='w') as outfile:
        writer = csv.writer(outfile)
        for rows in reader:
            mydict = {rows[0]:rows[1]}
            l.append(mydict)
print(l)
