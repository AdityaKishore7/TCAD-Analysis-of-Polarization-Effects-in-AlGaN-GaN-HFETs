#setdep @node|IdVd_1@

#include "common_des.cmd"

Math {	
	BreakCriteria {Current(Contact="drain" Minval= 1e-4)}
}

Solve {
	Load(FilePrefix="n@node|IdVd_1@_Vd36")
	Quasistationary (
		InitialStep= 1e-2 Minstep= 1e-6 MaxStep= 0.1
		Goal{Name="gate" Voltage=-10}
	) {
		Coupled {Poisson Electron Hole}
	}
}
