import cx_Oracle
cx_Oracle.init_oracle_client(lib_dir=r"/users/mymacintosh/downloads/instantclient_19_8")
conn=cx_Oracle.connect('SYS','Radeon1457<>','localhost/xe',cx_Oracle.SYSDBA)
cursor=conn.cursor()
data=cursor.execute("""
SELECT RPAD(' ',L*2,' ')||RPAD('*',rn*2-1,'*')||RPAD('*',rn*2-2,'*') X
 FROM (
SELECT LEVEL L,ROW_NUMBER() OVER(ORDER BY null) AS rn 
FROM dual
CONNECT  BY LEVEL<=10
ORDER BY LEVEL DESC )
""")
for columns in data.description:
    print(columns[0],end='')
print()
for r in cursor:
    print(r[0])
for i in range(11,1,-1):
    for space in range(-1,11-i):
        print("  ",end="")
    for j in range(i,2*i-1):
        print("*",end="")
    for j in range(1,i-1):
        print("*",end="**")
    print()
