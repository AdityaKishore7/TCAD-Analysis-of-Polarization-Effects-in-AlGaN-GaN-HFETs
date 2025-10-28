#setdep @node|IdVg_ramp@

#include "common_des.cmd"

Solve {
	Load(FilePrefix="n@node|IdVg_ramp@_3")
	Quasistationary (
		InitialStep= 2e-2 Minstep= 1e-5 MaxStep= 0.1
		Goal{Name="drain" Voltage= 50}
	) {
		Coupled {Poisson Electron Hole}
		Plot(FilePrefix="n@node@_Vd28" Time=(0.56))
		Plot(FilePrefix="n@node@_Vd36" Time=(0.72))
		Plot(FilePrefix="n@node@_Vd48" Time=(0.96))
	}
}
