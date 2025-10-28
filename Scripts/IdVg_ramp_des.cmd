# Load file containing common settings for all DC simulations
#include "common_des.cmd"

# Ramp gate up and down saving files at states used in subsequent simulations
Solve {
	NewCurrentFile="n@node@_p_"

	Coupled (Iterations= 10000 LinesearchDamping= 1e-5) {Poisson}
	Coupled (Iterations= 10000 LinesearchDamping= 1e-5) {Poisson Electron Hole}

	Plot(FilePrefix="n@node@_zero")

	Quasistationary (
		InitialStep= 0.05 Minstep= 1e-4 MaxStep= 0.1
		Goal{Name="gate" Voltage= 2}
	) {
		Coupled {Poisson Electron Hole}
		Plot(FilePrefix="n@node@_1" Time=(1))
	}

	NewCurrentFile="n@node@_n_"
	Load(FilePrefix="n@node@_zero")
	Quasistationary (
		InitialStep= 0.05 Minstep= 1e-4 MaxStep= 0.1
		Goal{Name="gate" Voltage= -4}
	) {
		Coupled {Poisson Electron Hole}
		Plot(FilePrefix="n@node@_2" Time=(@<2.0/4.0>@))
		Plot(FilePrefix="n@node@_3" Time=(1))
	}
}
