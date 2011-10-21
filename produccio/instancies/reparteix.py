origen = open('origen','r')
zeo1 = open('zeo1','w')
zeo2 = open('zeo2','w')
zeo3 = open('zeo3','w')
zeo4 = open('zeo4','w')
zeo5 = open('zeo5','w')
zeo6 = open('zeo6','w')
zeo7 = open('zeo7','w')
zeo8 = open('zeo8','w')
zeo9 = open('zeo9','w')
zeo10 = open('zeo10','w')
zeo11 = open('zeo11','w')
zeo12 = open('zeo12','w')

i=0
instanciesperentorn = 35
# Canvia el numero dels intervals per altres tipus de distribucio
for line in origen.readlines():
   i=i+1
   if i<=instanciesperentorn:
       zeo1.write(line)
   if i>instanciesperentorn and i<=instanciesperentorn*2:
       zeo2.write(line)
   if i>instanciesperentorn*2 and i<=instanciesperentorn*3:
       zeo3.write(line)
   if i>instanciesperentorn*3 and i<=instanciesperentorn*4:
       zeo4.write(line)
   if i>instanciesperentorn*4 and i<=instanciesperentorn*5:
       zeo5.write(line)
   if i>instanciesperentorn*5 and i<=instanciesperentorn*6:
       zeo6.write(line)
   if i>instanciesperentorn*6 and i<=instanciesperentorn*7:
       zeo7.write(line)
   if i>instanciesperentorn*7 and i<=instanciesperentorn*8:
       zeo8.write(line)
   if i>instanciesperentorn*8 and i<=instanciesperentorn*9:
       zeo9.write(line)
   if i>instanciesperentorn*9 and i<=instanciesperentorn*10:
       zeo10.write(line)
   if i>instanciesperentorn*10 and i<=instanciesperentorn*11:
       zeo11.write(line)
   if i>instanciesperentorn*11 and i<=instanciesperentorn*12:
       zeo12.write(line)
zeo1.close()
zeo2.close()
zeo3.close()
zeo4.close()
zeo5.close()
zeo6.close()
zeo7.close()
zeo8.close()
zeo9.close()
zeo10.close()
zeo11.close()
zeo12.close()
origen.close()
