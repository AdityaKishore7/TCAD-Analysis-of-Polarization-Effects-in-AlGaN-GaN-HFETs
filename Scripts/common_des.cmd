Electrode {
        { Name="gate"   Voltage= 0 Schottky Workfunction= 4.4 }
        { Name="source" Voltage= 0 EqOhmic }
        { Name="drain"  Voltage= 0 EqOhmic }
}


File {
	Grid= "@tdr@"
	Parameter= "@parameter@"
	
	Current= "@plot@"
	Plot= "@tdrdat@"
	Output= "@log@"

	NewtonPlot= "n@node@_np_%d_%d_des.tdr"	
}

Physics {
	AreaFactor= 1000 					* So that currents are given in A/mm
	Mobility (
		DopingDependence 
		Highfieldsaturation
	)
	EffectiveIntrinsicDensity (Nobandgapnarrowing)
	Fermi
	Recombination(
		SRH
	)
	Piezoelectric_Polarization (strain(GateDependent))
	Aniso(Poisson direction=(0, 0, 1))
	Thermionic

	DefaultParametersFromFile			* Use parameter files within the MaterialDB 
										* directory to determine defaults.
}

# Example of Fermi level pinning surface trap
Physics (MaterialInterface="GaN/Nitride") {
	Traps(
		(Donor Level Conc= 5e13 EnergyMid= 0.4 FromMidBandGap)
	)
}

Physics (MaterialInterface="GaN/Oxide") {
	PiezoElectric_Polarization(activation= 0)
}

Plot {
	Electricfield/Vector
	eCurrent/Vector hCurrent/Vector TotalCurrent/Vector
	
	SRH Avalanche
	eMobility hMobility
	eGradQuasiFermi hGradQuasiFermi
	eEparallel hEparallel
	
	eVelocity hVelocity
	DonorConcentration Acceptorconcentration
	Doping SpaceCharge
	ConductionBand ValenceBand eQuasiFermiEnergy hQuasiFermiEnergy
	BandGap Affinity
	xMoleFraction
	
	PE_Polarization/Vector
	PE_Charge
	ConversePiezoelectricField/Tensor
	
#	eBarrierTunneling
}

Math {
	Extrapolate
	Iterations= 12
	DirectCurrentComputation

	EquilibriumSolution(Iterations= 1000)
	ExtendedPrecision
	Digits= 8
	RHSMin= 1e-8
	
	eDrForceRefDens= 1e8 
	hDrForceRefDens= 1e8
	
	CNormPrint
	NewtonPlot (
	  Error MinError
	  Residual
	)
	
}

