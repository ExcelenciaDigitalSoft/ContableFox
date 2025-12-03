close table all
clear 
c=0
for k =1 to 255
	?Alltr(str(k))+" ---------- "+chr(k)
	c=c+1
	if c=30
		read
		c=0
	endif
endfor