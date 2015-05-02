import sqlite3
import sys, os
import re
import getopt
import xlwt
from xlwt import easyxf 
from collections import defaultdict

ifile = None
ofile = None
tech = defaultdict(list)
sector = set()
scenario = set()
period = []
row = 0
count = 0
sheet = []
book = []
book_no = 0
flag = None
i = 0 # Sheet ID
header = ['Technologies']
tables = {"Output_VFlow_Out" : ["Activity", "vflow_out"], "Output_Capacity" : ["Capacity", "capacity"], "Output_Emissions" : ["Emissions", "emissions"]}


try:
	argv = sys.argv[1:]
	opts, args = getopt.getopt(argv, "hi:o:s:", ["help", "input=", "output=", "scenario="])
except getopt.GetoptError:          
	print "Something's Wrong. Use as :\n	python DB_to_Excel.py -i <input_file> (Optional -o <output_excel_file_name_only>)\n	Use -h for help."                          
	sys.exit(2) 
	
for opt, arg in opts:
	if opt in ("-i", "--input"):
		ifile = arg
	elif opt in ("-o", "--output"):
		ofile = arg
	elif opt in ("-s", "--scenario"):
		scenario.add(arg)
	elif opt in ("-h", "--help") :
		print "Use as :\n	python DB_to_Excel.py -i <input_file> (Optional -o <output_excel_file_name_only>)\n	Use -h for help."                          
		sys.exit()

if ifile is None :
	print "You did not specify the input file, remember to use '-i' option"
	print "Use as :\n	python DB_to_Excel.py -i <input_file> (Optional -o <output_excel_file_name_only>)\n	Use -h for help."                          
	sys.exit(2)
else :
	file_type = re.search(r"(\w+)\.(\w+)\b", ifile) # Extract the input filename and extension
	if not file_type :
		print "The file type %s is not recognized. Use a db file." % ifile
		sys.exit(2)
		
	if ofile is None :
		ofile = file_type.group(1)
		print "Look for output in %s_*.xls" % ofile

con = sqlite3.connect(ifile)
cur = con.cursor()   # a database cursor is a control structure that enables traversal over the records in a database
con.text_factory = str #this ensures data is explored with the correct UTF-8 encoding

for k in tables.keys() :
	if not scenario :
		cur.execute("SELECT DISTINCT scenario FROM "+k)
		for val in cur :
			scenario.add(val[0])
	
	for axy in cur.execute("SELECT count(*) FROM sqlite_master WHERE type='table' AND name='technologies';") :
		if axy[0] :
			fields = [ads[1] for ads in cur.execute('PRAGMA table_info(technologies)')]
			if 'sector' in fields :
				cur.execute("SELECT sector FROM technologies")
				for val in cur :
					sector.add(val[0])
				if not sector :
					sector.add('0')
				else :
					flag = 1
	
	if flag is None :
		cur.execute("SELECT DISTINCT tech FROM "+k)
		for val in cur :
			tech['0'].append(val[0])
	else :
		for x in sector :
			cur.execute("SELECT DISTINCT tech  FROM technologies WHERE sector is '"+x+"'")
			for val in cur :
				if val[0] not in tech[x] :
					tech[x].append(val[0])
	
	cur.execute("SELECT DISTINCT t_periods FROM "+k)
	for val in cur :
		val = str(val[0])
		if val not in period :
			period.append(val)
			header.append(val)
header[1:].sort()
period.sort()

for scene in scenario :	
	book.append(xlwt.Workbook(encoding="utf-8"))
	for z in sector :
		for a in tables.keys() :
			if z is '0' :
				sheet_name = str(tables[a][0])
			else :
				sheet_name = str(tables[a][0])+"_"+str(z)
			sheet.append(book[book_no].add_sheet(sheet_name))
			for col in range(0, len(header)) :
				sheet[i].write(row, col, header[col], easyxf('alignment: vertical centre, horizontal centre, wrap True;'))
				sheet[i].col(col).width_in_pixels = 3300
			row += 1
			for x in tech[z] :
				sheet[i].write(row, 0, x, easyxf('alignment: vertical centre, horizontal centre;'))
				for y in period :
					cur.execute("SELECT sum("+tables[a][1]+") FROM "+a+" WHERE t_periods is '"+y+"' and scenario is '"+scene+"' and tech is '"+x+"'")
					xyz = cur.fetchone()
					if xyz[0] is not None :
						sheet[i].write(row, count+1, float(xyz[0]), easyxf('alignment: vertical centre, horizontal centre;'))
					else :
						sheet[i].write(row, count+1, '-', easyxf('alignment: vertical centre, horizontal centre;'))
					count += 1
				row += 1
				count = 0
			row = 0
			i += 1
	if len(scenario) is 1:
		book[book_no].save(ofile+".xls")
	else :
		book[book_no].save(ofile+"_"+scene+".xls")
	book_no += 1

cur.close()
con.close()