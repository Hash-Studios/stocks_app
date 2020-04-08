import csv

with open('BSE Codes - BSE_metadata(1).csv', mode='r') as infile:
    reader = csv.reader(infile)
    with open('BSE Codes - BSE_metadata(1)_new.csv', mode='w') as outfile:
        writer = csv.writer(outfile)
        mydict = {rows[0]:rows[1] for rows in reader}
print(mydict)
