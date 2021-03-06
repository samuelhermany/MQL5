<chart>
id=130652731570823958
symbol=WINQ20
description=IBOVESPA MINI
period_type=0
period_size=1
digits=0
tick_size=5.000000
position_time=1419861600
scale_fix=0
scale_fixed_min=101840.000000
scale_fixed_max=102660.000000
scale_fix11=0
scale_bar=0
scale_bar_val=1.000000
scale=8
mode=1
fore=0
grid=0
volume=0
scroll=1
shift=0
shift_size=19.682959
fixed_pos=0.000000
ticker=1
ohlc=0
one_click=0
one_click_btn=1
bidline=1
askline=0
lastline=1
days=1
descriptions=0
tradelines=1
tradehistory=1
window_left=0
window_top=0
window_right=793
window_bottom=799
window_type=1
floating=0
floating_left=0
floating_top=0
floating_right=0
floating_bottom=0
floating_type=1
floating_toolbar=1
floating_tbstate=
background_color=0
foreground_color=16777215
barup_color=10135078
bardown_color=5264367
bullcandle_color=10135078
bearcandle_color=5264367
chartline_color=8698454
volumes_color=10135078
grid_color=15920369
bidline_color=10135078
askline_color=5264367
lastline_color=15776412
stops_color=5264367
windows_total=1

<window>
height=100.000000
objects=0

<indicator>
name=Main
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1
</indicator>

<indicator>
name=Custom Indicator
path=Indicators\Examples\Envelopes.ex5
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=4
fixed_height=-1

<graph>
name=Env(5)Upper
draw=1
style=0
width=1
color=255
</graph>

<graph>
name=Env(5)Lower
draw=1
style=0
width=1
color=3329330
</graph>
<inputs>
InpMAPeriod=5
InpMAShift=0
InpMAMethod=0
InpAppliedPrice=1
InpDeviation=0.1
</inputs>
</indicator>

<indicator>
name=Moving Average
path=
apply=1
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=129
style=1
width=1
color=11119017
</graph>
period=5
method=0
</indicator>

<indicator>
name=Custom Indicator
path=Indicators\Examples\Download\HiLo Escadinha.ex5
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=0.000000
scale_fix_max=0
scale_fix_max_val=0.000000
expertmode=4
fixed_height=-1

<graph>
name=UpperPrev;Upper
draw=15
style=0
width=2
shift=-1
color=32768,-1
</graph>

<graph>
name=Lower Prev;Lower
draw=15
style=0
width=2
shift=-1
color=255,-1
</graph>
<inputs>
MAPeriod=5
MAType=2
Shift=-1
</inputs>
</indicator>
</window>
</chart>