<chart>
id=128968168951083984
symbol=WIN$D
description=IBOVESPA MINI - Por Liquidez (WINV20) - Ajuste por Diferença
period_type=0
period_size=1
digits=0
tick_size=5.000000
position_time=1597235160
scale_fix=0
scale_fixed_min=100060.000000
scale_fixed_max=101820.000000
scale_fix11=0
scale_bar=0
scale_bar_val=1.000000
scale=32
mode=1
fore=0
grid=0
volume=0
scroll=0
shift=0
shift_size=20.173536
fixed_pos=0.000000
ticker=1
ohlc=0
one_click=0
one_click_btn=1
bidline=1
askline=0
lastline=1
days=0
descriptions=0
tradelines=1
tradehistory=1
window_left=128
window_top=128
window_right=1501
window_bottom=609
window_type=3
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
barup_color=48896
bardown_color=255
bullcandle_color=48896
bearcandle_color=255
chartline_color=48896
volumes_color=48896
grid_color=15920369
bidline_color=48896
askline_color=255
lastline_color=15776412
stops_color=255
windows_total=4

<expert>
name=TesteDC
path=Experts\Curso\TesteDC.ex5
expertmode=5
<inputs>
=
myAberturaHora=9
myAberturaMinuto=30
myFechamentoHora=17
myFechamentoMinuto=30
=
myLote_3=1
myTakeProfit_3=150
myStopLoss_3=50
myTrallingStop_3=50
=
periodo=10
type=0
margins=2
shift=0
</inputs>
</expert>

<window>
height=100.000000
objects=21

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
path=Indicators\Examples/Download/Donchian_Channels.ex5
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
expertmode=4
fixed_height=-1

<graph>
name=Upper Donchian
draw=1
style=0
width=1
arrow=251
color=2330219
</graph>

<graph>
name=Middle Donchian
draw=1
style=0
width=1
arrow=251
color=0
</graph>

<graph>
name=Lower Donchian
draw=1
style=0
width=1
arrow=251
color=9662683
</graph>
<inputs>
DonchianPeriod=10
Extremes=0
Margins=2
Shift=0
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
style=0
width=2
arrow=251
color=65535
</graph>
period=50
method=0
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
style=0
width=2
arrow=251
color=16776960
</graph>
period=21
method=0
</indicator>

<indicator>
name=Custom Indicator
path=Indicators\Examples\ZigzagColor.ex5
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
name=ZigzagColor
draw=15
style=0
width=1
arrow=251
color=16748574,255
</graph>
<inputs>
InpDepth=12
InpDeviation=5
InpBackstep=3
</inputs>
</indicator>

<indicator>
name=Custom Indicator
path=Indicators\Examples/Download/Donchian_Channels.ex5
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
expertmode=536871940
fixed_height=-1

<graph>
name=Upper Donchian
draw=1
style=0
width=1
color=2330219
</graph>

<graph>
name=Middle Donchian
draw=1
style=0
width=1
color=8421504
</graph>

<graph>
name=Lower Donchian
draw=1
style=0
width=1
color=9662683
</graph>
<inputs>
DonchianPeriod=10
Extremes=0
Margins=2
Shift=0
</inputs>
</indicator>
<object>
type=32
name=autotrade #325376136 sell 1 WINQ20 at 103045
hidden=1
color=1918177
selectable=0
date1=1596806180
value1=103045.000000
</object>

<object>
type=31
name=autotrade #325378315 buy 1 WINQ20 at 103035
hidden=1
descr=[tp 103035]
color=11296515
selectable=0
date1=1596806262
value1=103035.000000
</object>

<object>
type=31
name=autotrade #325379352 buy 1 WINQ20 at 102995
hidden=1
color=11296515
selectable=0
date1=1596806286
value1=102995.000000
</object>

<object>
type=32
name=autotrade #325381567 sell 1 WINQ20 at 102915
hidden=1
color=1918177
selectable=0
date1=1596806362
value1=102915.000000
</object>

<object>
type=32
name=autotrade #325413988 sell 1 WINQ20 at 103065
hidden=1
color=1918177
selectable=0
date1=1596807723
value1=103065.000000
</object>

<object>
type=31
name=autotrade #325415852 buy 1 WINQ20 at 103045
hidden=1
descr=[tp 103045]
color=11296515
selectable=0
date1=1596807760
value1=103045.000000
</object>

<object>
type=31
name=autotrade #325416593 buy 1 WINQ20 at 103050
hidden=1
color=11296515
selectable=0
date1=1596807791
value1=103050.000000
</object>

<object>
type=32
name=autotrade #325425129 sell 1 WINQ20 at 102950
hidden=1
color=1918177
selectable=0
date1=1596808092
value1=102950.000000
</object>

<object>
type=32
name=autotrade #325435339 sell 1 WINQ20 at 102810
hidden=1
color=1918177
selectable=0
date1=1596808533
value1=102810.000000
</object>

<object>
type=31
name=autotrade #325436719 buy 1 WINQ20 at 102885
hidden=1
color=11296515
selectable=0
date1=1596808570
value1=102885.000000
</object>

<object>
type=31
name=autotrade #325470720 buy 1 WINQ20 at 102760
hidden=1
color=11296515
selectable=0
date1=1596809741
value1=102760.000000
</object>

<object>
type=32
name=autotrade #325473811 sell 1 WINQ20 at 102625
hidden=1
color=1918177
selectable=0
date1=1596809764
value1=102625.000000
</object>

<object>
type=2
name=autotrade #325376136 -> #325378315 WINQ20
hidden=1
descr=103045 -> 103035
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1596806180
date2=1596806262
value1=103045.000000
value2=103035.000000
</object>

<object>
type=2
name=autotrade #325379352 -> #325381567 WINQ20
hidden=1
descr=102995 -> 102915
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1596806286
date2=1596806362
value1=102995.000000
value2=102915.000000
</object>

<object>
type=2
name=autotrade #325413988 -> #325415852 WINQ20
hidden=1
descr=103065 -> 103045
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1596807723
date2=1596807760
value1=103065.000000
value2=103045.000000
</object>

<object>
type=2
name=autotrade #325416593 -> #325425129 WINQ20
hidden=1
descr=103050 -> 102950
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1596807791
date2=1596808092
value1=103050.000000
value2=102950.000000
</object>

<object>
type=2
name=autotrade #325435339 -> #325436719 WINQ20
hidden=1
descr=102810 -> 102885
color=1918177
style=2
selectable=0
ray1=0
ray2=0
date1=1596808533
date2=1596808570
value1=102810.000000
value2=102885.000000
</object>

<object>
type=2
name=autotrade #325470720 -> #325473811 WINQ20
hidden=1
descr=102760 -> 102625
color=11296515
style=2
selectable=0
ray1=0
ray2=0
date1=1596809741
date2=1596809764
value1=102760.000000
value2=102625.000000
</object>

<object>
type=2
name=M1 Trendline 18503
color=16777215
width=3
ray1=0
ray2=0
date1=1597245540
date2=1597245540
value1=100900.000000
value2=100900.000000
</object>

<object>
type=2
name=M1 Trendline 29789
color=16777215
width=3
ray1=0
ray2=0
date1=1597241160
date2=1597240560
value1=102075.000000
value2=101610.000000
</object>

<object>
type=2
name=M1 Trendline 49251
color=16777215
width=3
ray1=0
ray2=0
date1=1597239180
date2=1597238760
value1=102040.000000
value2=101360.000000
</object>

</window>

<window>
height=50.000000
objects=8

<indicator>
name=Custom Indicator
path=Indicators\Examples\ADX.ex5
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=0
scale_fix_min_val=-0.041550
scale_fix_max=0
scale_fix_max_val=54.376550
expertmode=4
fixed_height=-1

<graph>
name=ADX(14)
draw=1
style=2
width=1
arrow=251
color=16777215
</graph>

<graph>
name=+DI
draw=1
style=0
width=1
arrow=251
color=65280
</graph>

<graph>
name=-DI
draw=1
style=0
width=1
arrow=251
color=255
</graph>
<inputs>
InpPeriodADX=14
</inputs>
</indicator>
<object>
type=1
name=M1 Horizontal Line 18043
color=16777215
width=3
selectable=0
value1=20.000000
</object>

<object>
type=2
name=M1 Trendline 8095
color=16777215
width=3
ray1=0
ray2=0
date1=1597249680
date2=1597249140
value1=56.219692
value2=14.236923
</object>

<object>
type=2
name=M1 Trendline 49901
color=16777215
width=3
ray1=0
ray2=0
date1=1597249680
date2=1597250220
value1=58.843615
value2=27.731385
</object>

<object>
type=2
name=M1 Trendline 27638
color=16777215
width=3
ray1=0
ray2=0
date1=1597246620
date2=1597247160
value1=20.316242
value2=52.868167
</object>

<object>
type=2
name=M1 Trendline 54541
color=16777215
width=3
ray1=0
ray2=0
date1=1597244520
date2=1597245060
value1=23.854495
value2=56.406420
</object>

<object>
type=2
name=M1 Trendline 62436
color=16777215
width=3
ray1=0
ray2=0
date1=1597246380
date2=1597245540
value1=27.038922
value2=49.683740
</object>

<object>
type=2
name=M1 Trendline 60080
color=16777215
width=3
ray1=0
ray2=0
date1=1597240500
date2=1597240500
value1=23.699290
value2=23.699290
</object>

<object>
type=2
name=M1 Trendline 29506
color=16777215
width=3
ray1=0
ray2=0
date1=1597240440
date2=1597240740
value1=21.198077
value2=38.318912
</object>

</window>

<window>
height=50.000000
objects=7

<indicator>
name=Stochastic Oscillator
path=
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=0.000000
scale_fix_min=1
scale_fix_min_val=0.000000
scale_fix_max=1
scale_fix_max_val=100.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=1
style=0
width=1
arrow=251
color=11186720
</graph>

<graph>
name=
draw=1
style=2
width=1
arrow=251
color=255
</graph>

<level>
level=20.000000
style=2
color=12632256
width=1
descr=
</level>

<level>
level=80.000000
style=2
color=12632256
width=1
descr=
</level>
kperiod=5
dperiod=3
slowing=3
price_apply=0
method=0
</indicator>
<object>
type=2
name=M1 Trendline 62794
color=16777215
width=3
ray1=0
ray2=0
date1=1597319460
date2=1597319760
value1=64.835165
value2=2.747253
</object>

<object>
type=2
name=M1 Trendline 14570
color=16777215
width=3
ray1=0
ray2=0
date1=1597315980
date2=1597316220
value1=84.340659
value2=8.791209
</object>

<object>
type=2
name=M1 Trendline 28553
color=16777215
width=3
ray1=0
ray2=0
date1=1597314240
date2=1597314660
value1=85.164835
value2=10.439560
</object>

<object>
type=2
name=M1 Trendline 40603
color=16777215
width=3
ray1=0
ray2=0
date1=1597314000
date2=1597313700
value1=91.758242
value2=24.725275
</object>

<object>
type=2
name=M1 Trendline 42527
color=16777215
width=3
ray1=0
ray2=0
date1=1597245540
date2=1597245900
value1=28.021978
value2=95.054945
</object>

<object>
type=2
name=M1 Trendline 11745
color=16777215
width=3
ray1=0
ray2=0
date1=1597244820
date2=1597244280
value1=13.736264
value2=78.021978
</object>

<object>
type=2
name=M1 Trendline 25489
color=16777215
width=3
ray1=0
ray2=0
date1=1597240560
date2=1597241160
value1=12.637363
value2=88.461538
</object>

</window>

<window>
height=50.000000
objects=9

<indicator>
name=Accumulation/Distribution
path=
apply=0
show_data=1
scale_inherit=0
scale_line=0
scale_line_percent=50
scale_line_value=-931096.400000
scale_fix_min=0
scale_fix_min_val=-939834.800000
scale_fix_max=0
scale_fix_max_val=-922358.000000
expertmode=0
fixed_height=-1

<graph>
name=
draw=1
style=0
width=1
arrow=251
color=11186720
</graph>
real_volumes=0
</indicator>
<object>
type=2
name=M1 Trendline 10723
color=16777215
width=3
ray1=0
ray2=0
date1=1597315980
date2=1597316160
value1=-1016177.678947
value2=-1049204.426316
</object>

<object>
type=2
name=M1 Trendline 48188
color=16777215
width=3
ray1=0
ray2=0
date1=1597319400
date2=1597319760
value1=-992206.652632
value2=-1036419.878947
</object>

<object>
type=2
name=M1 Trendline 28109
color=16777215
width=3
ray1=0
ray2=0
date1=1597319700
date2=1597320060
value1=-998865.271053
value2=-1043078.497368
</object>

<object>
type=2
name=M1 Trendline 29834
color=16777215
width=3
ray1=0
ray2=0
date1=1597314180
date2=1597313640
value1=-1017171.416632
value2=-1096694.205263
</object>

<object>
type=2
name=M1 Trendline 31075
color=16777215
width=3
ray1=0
ray2=0
date1=1597249140
date2=1597249620
value1=-1089207.042000
value2=-1061176.842000
</object>

<object>
type=2
name=M1 Trendline 18977
color=16777215
width=3
ray1=0
ray2=0
date1=1597246440
date2=1597247100
value1=-1111825.637368
value2=-1089035.319211
</object>

<object>
type=2
name=M1 Trendline 26191
color=16777215
width=3
ray1=0
ray2=0
date1=1597245480
date2=1597245900
value1=-1140410.104211
value2=-1105645.212105
</object>

<object>
type=2
name=M1 Trendline 37903
color=16777215
width=3
ray1=0
ray2=0
date1=1597244220
date2=1597244940
value1=-1106804.041842
value2=-1139251.274474
</object>

<object>
type=2
name=M1 Trendline 19521
color=16777215
width=3
ray1=0
ray2=0
date1=1597240500
date2=1597241160
value1=-1144690.514000
value2=-1111687.821895
</object>

</window>
</chart>