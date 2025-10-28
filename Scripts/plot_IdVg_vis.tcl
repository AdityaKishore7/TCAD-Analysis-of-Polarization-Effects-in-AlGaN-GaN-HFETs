#setdep @node|IdVg_1@ @node|IdVg_2@
  
set x @xAlGaN@
set t @tAlGaN@
set colors [list black red blue #00aa00 #555500 #550055 #005555]
set nodes [list @node|IdVg_2@ @node|IdVg_1@]

create_plot -1d -name Plot_IdVg
select_plots Plot_IdVg
set_plot_prop -hide_title -show_legend 

#- Build IdVg and gm curves
set i 0
foreach n $nodes {
	if {[file exists n${n}_des.plt]} {

		load_file n${n}_des.plt -name prj($n)
		set Vd [lindex [get_variable_data "drain OuterVoltage" -dataset prj($n)] end]

		create_curve -name IdVg($n) -dataset prj($n) \
		-axisX "gate OuterVoltage" -axisY "drain TotalCurrent"
	
		set Label "I<suv>d</sub> V<sub>d</sub> = [format %.1f $Vd] V"
		set Color [lindex $colors [expr $i % [llength $colors]]]
		set_curve_prop IdVg($n) -label $Label \
		-color $Color -line_style solid -line_width 3

		
		create_curve -name gm($n) -dataset prj($n) \
		-axisX "gate OuterVoltage" -axisY2 "drain TotalCurrent"

		set Label "g<sub>m</sub> V<sub>d</sub> = [format %.1f $Vd] V"	
		set_curve_prop gm($n) -label $Label \
		-color $Color -line_style dash -line_width 3 -deriv 1 -axis right
		
		incr i

    }
}

set_axis_prop -axis x -title {Gate Voltage [V]} \
	-title_font_family "Arial" -title_font_size 24 -scale_font_size 22 \
	-type linear -range {-4.0 2.2}
#	-manual_spacing -spacing 0.5
set_axis_prop -axis y -title {Drain Current [A/mm]} \
	-title_font_size 24 -scale_font_size 22 
#	-scale_format scientific -scale_precision 0
set_axis_prop -axis y2 -title {g<sub>m</sub> [S/mm]} \
	-title_font_size 24 -scale_font_size 22 
#	-scale_format scientific -scale_precision 0	
	
set_legend_prop -font_size 18 -color_fg white


# windows_style -style max
# set_window_full -on
# set_window_size 750x700


