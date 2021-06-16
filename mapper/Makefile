WINCUPL=~/dist/WinCupl

all:
	wine $(WINCUPL)/Shared/cupl.exe -bu $(WINCUPL)/Shared/Atmel.dl f1502isptqfp44 mapper.pld && wine $(WINCUPL)/WinCupl/Fitters/fit1502.exe mapper.tt2 -cupl -dev p1502t44

clean:
	rm mapper.pla mapper.tt2 mapper.tt3 mapper.pin mapper.io mapper.fit jtag.log mapper.jed mapper.doc
