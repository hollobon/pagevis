# pagevis

The pagevis PostgreSQL extension currently contains a single function,
`show_page`, which returns an ASCII-graphical representation of the contents of
a PostgreSQL database page. It uses the pageinspect extension, which must be
installed first. You must be superuser to call `show_page`, as it uses the
pageinspect `get_raw_page` function.

## Output

The results of `show_page` are multiple records with a single text column, for
a total of `block_size` characters (default 8192), one representing each byte
on the page.

The meaning of each character is as shown in this table:

```
| *Character* | *Meaning*                                     |
| P           | page header                                   |
| U           | unused line pointer                           |
| N           | normal line pointer                           |
| R           | redirect line pointer                         |
| D           | dead line pointer                             |
| (space)     | free space (the "hole")                       |
| [n]         | tuple number (overlaid on tuple header)       |
| H           | tuple header                                  |
| #           | tuple data                                    |
| -           | tuple invisible to current transaction (dead) |
| .           | inter-tuple padding                           |
```

## Example

```
> set role postgres;
SET
# create extension pagevis;
CREATE EXTENSION
# create table pvtest (a integer);
CREATE TABLE
# insert into pvtest select generate_series(1, 500);
INSERT 0 500
# select * from pvtest limit 5;
 a
---
 1
 2
 3
 4
 5
(5 rows)

# select ctid, * from pvtest limit 5;
 ctid  | a
-------+---
 (0,1) | 1
 (0,2) | 2
 (0,3) | 3
 (0,4) | 4
 (0,5) | 5
(5 rows)

# select show_page('pvtest', 0, 64);
                             show_page
------------------------------------------------------------------
 PPPPPPPPPPPPPPPPPPPPPPPP001N002N003N004N005N006N007N008N009N010N
 011N012N013N014N015N016N017N018N019N020N021N022N023N024N025N026N
 027N028N029N030N031N032N033N034N035N036N037N038N039N040N041N042N
 043N044N045N046N047N048N049N050N051N052N053N054N055N056N057N058N
 059N060N061N062N063N064N065N066N067N068N069N070N071N072N073N074N
 075N076N077N078N079N080N081N082N083N084N085N086N087N088N089N090N
 091N092N093N094N095N096N097N098N099N100N101N102N103N104N105N106N
 107N108N109N110N111N112N113N114N115N116N117N118N119N120N121N122N
 123N124N125N126N127N128N129N130N131N132N133N134N135N136N137N138N
 139N140N141N142N143N144N145N146N147N148N149N150N151N152N153N154N
 155N156N157N158N159N160N161N162N163N164N165N166N167N168N169N170N
 171N172N173N174N175N176N177N178N179N180N181N182N183N184N185N186N
 187N188N189N190N191N192N193N194N195N196N197N198N199N200N201N202N
 203N204N205N206N207N208N209N210N211N212N213N214N215N216N217N218N
 219N220N221N222N223N224N225N226N
 [226]HHHHHHHHHHHHHHHHHHH####....[225]HHHHHHHHHHHHHHHHHHH####....
 [224]HHHHHHHHHHHHHHHHHHH####....[223]HHHHHHHHHHHHHHHHHHH####....
 [222]HHHHHHHHHHHHHHHHHHH####....[221]HHHHHHHHHHHHHHHHHHH####....
 [220]HHHHHHHHHHHHHHHHHHH####....[219]HHHHHHHHHHHHHHHHHHH####....
 [218]HHHHHHHHHHHHHHHHHHH####....[217]HHHHHHHHHHHHHHHHHHH####....
 [216]HHHHHHHHHHHHHHHHHHH####....[215]HHHHHHHHHHHHHHHHHHH####....
 [214]HHHHHHHHHHHHHHHHHHH####....[213]HHHHHHHHHHHHHHHHHHH####....
 [212]HHHHHHHHHHHHHHHHHHH####....[211]HHHHHHHHHHHHHHHHHHH####....
 [210]HHHHHHHHHHHHHHHHHHH####....[209]HHHHHHHHHHHHHHHHHHH####....
 [208]HHHHHHHHHHHHHHHHHHH####....[207]HHHHHHHHHHHHHHHHHHH####....
 [206]HHHHHHHHHHHHHHHHHHH####....[205]HHHHHHHHHHHHHHHHHHH####....
 [204]HHHHHHHHHHHHHHHHHHH####....[203]HHHHHHHHHHHHHHHHHHH####....
 [202]HHHHHHHHHHHHHHHHHHH####....[201]HHHHHHHHHHHHHHHHHHH####....
 [200]HHHHHHHHHHHHHHHHHHH####....[199]HHHHHHHHHHHHHHHHHHH####....
 [198]HHHHHHHHHHHHHHHHHHH####....[197]HHHHHHHHHHHHHHHHHHH####....
 [196]HHHHHHHHHHHHHHHHHHH####....[195]HHHHHHHHHHHHHHHHHHH####....
 [194]HHHHHHHHHHHHHHHHHHH####....[193]HHHHHHHHHHHHHHHHHHH####....
 [192]HHHHHHHHHHHHHHHHHHH####....[191]HHHHHHHHHHHHHHHHHHH####....
 [190]HHHHHHHHHHHHHHHHHHH####....[189]HHHHHHHHHHHHHHHHHHH####....
 [188]HHHHHHHHHHHHHHHHHHH####....[187]HHHHHHHHHHHHHHHHHHH####....
 [186]HHHHHHHHHHHHHHHHHHH####....[185]HHHHHHHHHHHHHHHHHHH####....
 [184]HHHHHHHHHHHHHHHHHHH####....[183]HHHHHHHHHHHHHHHHHHH####....
 [182]HHHHHHHHHHHHHHHHHHH####....[181]HHHHHHHHHHHHHHHHHHH####....
 [180]HHHHHHHHHHHHHHHHHHH####....[179]HHHHHHHHHHHHHHHHHHH####....
 [178]HHHHHHHHHHHHHHHHHHH####....[177]HHHHHHHHHHHHHHHHHHH####....
 [176]HHHHHHHHHHHHHHHHHHH####....[175]HHHHHHHHHHHHHHHHHHH####....
 [174]HHHHHHHHHHHHHHHHHHH####....[173]HHHHHHHHHHHHHHHHHHH####....
 [172]HHHHHHHHHHHHHHHHHHH####....[171]HHHHHHHHHHHHHHHHHHH####....
 [170]HHHHHHHHHHHHHHHHHHH####....[169]HHHHHHHHHHHHHHHHHHH####....
 [168]HHHHHHHHHHHHHHHHHHH####....[167]HHHHHHHHHHHHHHHHHHH####....
 [166]HHHHHHHHHHHHHHHHHHH####....[165]HHHHHHHHHHHHHHHHHHH####....
 [164]HHHHHHHHHHHHHHHHHHH####....[163]HHHHHHHHHHHHHHHHHHH####....
 [162]HHHHHHHHHHHHHHHHHHH####....[161]HHHHHHHHHHHHHHHHHHH####....
 [160]HHHHHHHHHHHHHHHHHHH####....[159]HHHHHHHHHHHHHHHHHHH####....
 [158]HHHHHHHHHHHHHHHHHHH####....[157]HHHHHHHHHHHHHHHHHHH####....
 [156]HHHHHHHHHHHHHHHHHHH####....[155]HHHHHHHHHHHHHHHHHHH####....
 [154]HHHHHHHHHHHHHHHHHHH####....[153]HHHHHHHHHHHHHHHHHHH####....
 [152]HHHHHHHHHHHHHHHHHHH####....[151]HHHHHHHHHHHHHHHHHHH####....
 [150]HHHHHHHHHHHHHHHHHHH####....[149]HHHHHHHHHHHHHHHHHHH####....
 [148]HHHHHHHHHHHHHHHHHHH####....[147]HHHHHHHHHHHHHHHHHHH####....
 [146]HHHHHHHHHHHHHHHHHHH####....[145]HHHHHHHHHHHHHHHHHHH####....
 [144]HHHHHHHHHHHHHHHHHHH####....[143]HHHHHHHHHHHHHHHHHHH####....
 [142]HHHHHHHHHHHHHHHHHHH####....[141]HHHHHHHHHHHHHHHHHHH####....
 [140]HHHHHHHHHHHHHHHHHHH####....[139]HHHHHHHHHHHHHHHHHHH####....
 [138]HHHHHHHHHHHHHHHHHHH####....[137]HHHHHHHHHHHHHHHHHHH####....
 [136]HHHHHHHHHHHHHHHHHHH####....[135]HHHHHHHHHHHHHHHHHHH####....
 [134]HHHHHHHHHHHHHHHHHHH####....[133]HHHHHHHHHHHHHHHHHHH####....
 [132]HHHHHHHHHHHHHHHHHHH####....[131]HHHHHHHHHHHHHHHHHHH####....
 [130]HHHHHHHHHHHHHHHHHHH####....[129]HHHHHHHHHHHHHHHHHHH####....
 [128]HHHHHHHHHHHHHHHHHHH####....[127]HHHHHHHHHHHHHHHHHHH####....
 [126]HHHHHHHHHHHHHHHHHHH####....[125]HHHHHHHHHHHHHHHHHHH####....
 [124]HHHHHHHHHHHHHHHHHHH####....[123]HHHHHHHHHHHHHHHHHHH####....
 [122]HHHHHHHHHHHHHHHHHHH####....[121]HHHHHHHHHHHHHHHHHHH####....
 [120]HHHHHHHHHHHHHHHHHHH####....[119]HHHHHHHHHHHHHHHHHHH####....
 [118]HHHHHHHHHHHHHHHHHHH####....[117]HHHHHHHHHHHHHHHHHHH####....
 [116]HHHHHHHHHHHHHHHHHHH####....[115]HHHHHHHHHHHHHHHHHHH####....
 [114]HHHHHHHHHHHHHHHHHHH####....[113]HHHHHHHHHHHHHHHHHHH####....
 [112]HHHHHHHHHHHHHHHHHHH####....[111]HHHHHHHHHHHHHHHHHHH####....
 [110]HHHHHHHHHHHHHHHHHHH####....[109]HHHHHHHHHHHHHHHHHHH####....
 [108]HHHHHHHHHHHHHHHHHHH####....[107]HHHHHHHHHHHHHHHHHHH####....
 [106]HHHHHHHHHHHHHHHHHHH####....[105]HHHHHHHHHHHHHHHHHHH####....
 [104]HHHHHHHHHHHHHHHHHHH####....[103]HHHHHHHHHHHHHHHHHHH####....
 [102]HHHHHHHHHHHHHHHHHHH####....[101]HHHHHHHHHHHHHHHHHHH####....
 [100]HHHHHHHHHHHHHHHHHHH####....[99]HHHHHHHHHHHHHHHHHHHH####....
 [98]HHHHHHHHHHHHHHHHHHHH####....[97]HHHHHHHHHHHHHHHHHHHH####....
 [96]HHHHHHHHHHHHHHHHHHHH####....[95]HHHHHHHHHHHHHHHHHHHH####....
 [94]HHHHHHHHHHHHHHHHHHHH####....[93]HHHHHHHHHHHHHHHHHHHH####....
 [92]HHHHHHHHHHHHHHHHHHHH####....[91]HHHHHHHHHHHHHHHHHHHH####....
 [90]HHHHHHHHHHHHHHHHHHHH####....[89]HHHHHHHHHHHHHHHHHHHH####....
 [88]HHHHHHHHHHHHHHHHHHHH####....[87]HHHHHHHHHHHHHHHHHHHH####....
 [86]HHHHHHHHHHHHHHHHHHHH####....[85]HHHHHHHHHHHHHHHHHHHH####....
 [84]HHHHHHHHHHHHHHHHHHHH####....[83]HHHHHHHHHHHHHHHHHHHH####....
 [82]HHHHHHHHHHHHHHHHHHHH####....[81]HHHHHHHHHHHHHHHHHHHH####....
 [80]HHHHHHHHHHHHHHHHHHHH####....[79]HHHHHHHHHHHHHHHHHHHH####....
 [78]HHHHHHHHHHHHHHHHHHHH####....[77]HHHHHHHHHHHHHHHHHHHH####....
 [76]HHHHHHHHHHHHHHHHHHHH####....[75]HHHHHHHHHHHHHHHHHHHH####....
 [74]HHHHHHHHHHHHHHHHHHHH####....[73]HHHHHHHHHHHHHHHHHHHH####....
 [72]HHHHHHHHHHHHHHHHHHHH####....[71]HHHHHHHHHHHHHHHHHHHH####....
 [70]HHHHHHHHHHHHHHHHHHHH####....[69]HHHHHHHHHHHHHHHHHHHH####....
 [68]HHHHHHHHHHHHHHHHHHHH####....[67]HHHHHHHHHHHHHHHHHHHH####....
 [66]HHHHHHHHHHHHHHHHHHHH####....[65]HHHHHHHHHHHHHHHHHHHH####....
 [64]HHHHHHHHHHHHHHHHHHHH####....[63]HHHHHHHHHHHHHHHHHHHH####....
 [62]HHHHHHHHHHHHHHHHHHHH####....[61]HHHHHHHHHHHHHHHHHHHH####....
 [60]HHHHHHHHHHHHHHHHHHHH####....[59]HHHHHHHHHHHHHHHHHHHH####....
 [58]HHHHHHHHHHHHHHHHHHHH####....[57]HHHHHHHHHHHHHHHHHHHH####....
 [56]HHHHHHHHHHHHHHHHHHHH####....[55]HHHHHHHHHHHHHHHHHHHH####....
 [54]HHHHHHHHHHHHHHHHHHHH####....[53]HHHHHHHHHHHHHHHHHHHH####....
 [52]HHHHHHHHHHHHHHHHHHHH####....[51]HHHHHHHHHHHHHHHHHHHH####....
 [50]HHHHHHHHHHHHHHHHHHHH####....[49]HHHHHHHHHHHHHHHHHHHH####....
 [48]HHHHHHHHHHHHHHHHHHHH####....[47]HHHHHHHHHHHHHHHHHHHH####....
 [46]HHHHHHHHHHHHHHHHHHHH####....[45]HHHHHHHHHHHHHHHHHHHH####....
 [44]HHHHHHHHHHHHHHHHHHHH####....[43]HHHHHHHHHHHHHHHHHHHH####....
 [42]HHHHHHHHHHHHHHHHHHHH####....[41]HHHHHHHHHHHHHHHHHHHH####....
 [40]HHHHHHHHHHHHHHHHHHHH####....[39]HHHHHHHHHHHHHHHHHHHH####....
 [38]HHHHHHHHHHHHHHHHHHHH####....[37]HHHHHHHHHHHHHHHHHHHH####....
 [36]HHHHHHHHHHHHHHHHHHHH####....[35]HHHHHHHHHHHHHHHHHHHH####....
 [34]HHHHHHHHHHHHHHHHHHHH####....[33]HHHHHHHHHHHHHHHHHHHH####....
 [32]HHHHHHHHHHHHHHHHHHHH####....[31]HHHHHHHHHHHHHHHHHHHH####....
 [30]HHHHHHHHHHHHHHHHHHHH####....[29]HHHHHHHHHHHHHHHHHHHH####....
 [28]HHHHHHHHHHHHHHHHHHHH####....[27]HHHHHHHHHHHHHHHHHHHH####....
 [26]HHHHHHHHHHHHHHHHHHHH####....[25]HHHHHHHHHHHHHHHHHHHH####....
 [24]HHHHHHHHHHHHHHHHHHHH####....[23]HHHHHHHHHHHHHHHHHHHH####....
 [22]HHHHHHHHHHHHHHHHHHHH####....[21]HHHHHHHHHHHHHHHHHHHH####....
 [20]HHHHHHHHHHHHHHHHHHHH####....[19]HHHHHHHHHHHHHHHHHHHH####....
 [18]HHHHHHHHHHHHHHHHHHHH####....[17]HHHHHHHHHHHHHHHHHHHH####....
 [16]HHHHHHHHHHHHHHHHHHHH####....[15]HHHHHHHHHHHHHHHHHHHH####....
 [14]HHHHHHHHHHHHHHHHHHHH####....[13]HHHHHHHHHHHHHHHHHHHH####....
 [12]HHHHHHHHHHHHHHHHHHHH####....[11]HHHHHHHHHHHHHHHHHHHH####....
 [10]HHHHHHHHHHHHHHHHHHHH####....[9]HHHHHHHHHHHHHHHHHHHHH####....
 [8]HHHHHHHHHHHHHHHHHHHHH####....[7]HHHHHHHHHHHHHHHHHHHHH####....
 [6]HHHHHHHHHHHHHHHHHHHHH####....[5]HHHHHHHHHHHHHHHHHHHHH####....
 [4]HHHHHHHHHHHHHHHHHHHHH####....[3]HHHHHHHHHHHHHHHHHHHHH####....
 [2]HHHHHHHHHHHHHHHHHHHHH####....[1]HHHHHHHHHHHHHHHHHHHHH####....
(128 rows)
```

At the start of the page, you can see the page header (`P`s). After that come
line pointers, in increasing order. In this case, they are all normal
(`N`). After some empty space are the tuples. These are in decreasing order, as
they are added from the end of the page. The page is full when there is no more
room for a tuple between the last line pointer and the last tuple.

Each tuple contains a header (the `H`s), and 4 bytes of data for the 32-bit
integer attribute `a`. After that there is 4 bytes of padding (`....`) between
each tuple. This is there because tuple headers must be word-aligned. The tuple
header is 24 bytes here, and there are another 4 bytes for the integer
attribute, giving a total of 28 bytes per tuple. This example was run on a
64-bit machine, so words are 8 bytes. The next multiple of 8 larger than 28 is
32, hence the 4 bytes of padding.

Here's an example with a variable length text column:

```
# create table pvtest3(a text);
CREATE TABLE

# insert into pvtest3 select repeat('X', generate_series(0, 50, 10));
INSERT 0 6

# select * from pvtest3;
                         a
----------------------------------------------------

 XXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(6 rows)

# select show_page('pvtest3', 0, 64);
                             show_page
------------------------------------------------------------------
 PPPPPPPPPPPPPPPPPPPPPPPP001N002N003N004N005N006N
   << Hole - 121 rows skipped >>
                                                         [6]HHHHH
 HHHHHHHHHHHHHHHH################################################
 ###.....[5]HHHHHHHHHHHHHHHHHHHHH################################
 #########.......[4]HHHHHHHHHHHHHHHHHHHHH########################
 #######.[3]HHHHHHHHHHHHHHHHHHHHH#####################...[2]HHHHH
 HHHHHHHHHHHHHHHH###########.....[1]HHHHHHHHHHHHHHHHHHHHH#.......
(8 rows)
```

In this, the first tuple has a single byte of data. This is a 1 byte `varlena`
length word, which will contain a value of zero as the attribute is empty. The
remaining columns are, as you'd expect, length(a) + 1 bytes, as they are all
short enough to be stored inline (not in a TOAST table).
