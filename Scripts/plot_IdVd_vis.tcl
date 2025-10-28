#setdep @node|IdVd_0@ @node|IdVd_1@ @node|IdVd_2@ @node|IdVd_3@

set x @xAlGaN@
set t @tAlGaN@
set colors [list black red blue #00aa00 #555500 #550055 #005555]
set nodes [list @node|IdVd_3@ @node|IdVd_2@ @node|IdVd_0@ @node|IdVd_1@]

create_plot -1d -name Plot_IdVd
select_plots Plot_IdVd
set_plot_prop -hide_title -show_legend 

#- Build IdVd curves
set i 0
foreach n $nodes {
	if {[file exists n${n}_des.plt]} {
		load_file n${n}_des.plt -name prj($n)
		set Vg [lindex [get_variable_data "gate OuterVoltage" -dataset prj($n)] end]
		create_curve -name IdVd($n) -dataset prj($n) \
		-axisX "drain OuterVoltage" -axisY "drain TotalCurrent"
	
		set Label "V<sub>g</sub> = [format %.1f $Vg] V"
		set Color [lindex $colors [expr $i % [llength $colors]]]
		set_curve_prop IdVd($n) -label $Label \
		-color $Color -line_style solid -line_width 3		
		incr i
    }
}


set_axis_prop -axis x -title {Drain Voltage [V]} \
	-title_font_family "Arial" -title_font_size 24 -scale_font_size 22 \
	-type linear 
#	-manual_spacing -spacing 0.5
set_axis_prop -axis y -title {Drain Current [A/mm]} \
	-title_font_size 24 -scale_font_size 22 
#	-scale_format scientific -scale_precision 0

set_legend_prop -font_size 16 -color_fg white


# windows_style -style max
# set_window_full -on
# set_window_size 750x700

