#printf '\e[31m%s\e[0m' "this is in red"
#printf '\e[32m%s\e[0m' "this is in green "
#printf '\e[33m%s\e[0m' "this is in yellow"

#printf "%-20s\n" "${R[@]}"
#printf "%-20s" "aaa" "bbb" "ccc"  "eee" "fff" "ggg" "hhh"

function dprint() {
        echo
}

function decho() {
        echo
}

revisions="25550 42218 42621 42661"

header="%-20s| %-11s | %-12s | %-12s | %-11s | %-11s | %-11s | %-11s | %-15s | %-13s | %c\n"
#subheader="%-20s| %-3d %-3d %-4d | %-3d %-3d %-4d | %-3d %-3d %-4d | %-3d %-3d %-4d | %-3d %-3d %-4d | %-3d %-3d %-4d |%-3d %-3d %-4d | %-12s | %c\n"
subheader="%-20s| %-2s %-2s %-2s %-2s |  %-2s %-2s %-2s %-2s |  %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %1s %1s %1s %1s %1s %1s %1s %1s | %1s %1s %1s %1s %1s %1s %1s | %c\n"
subrow="%-20s| %-2s %-2s %-2s %-2s |  %-2s %-2s %-2s %-2s |  %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %1s %1s %1s %1s %1s %1s %1s %1s | %1s %1s %1s %1s %1s %1s %1s | %c\n"
#redsubrow='\e[31m%s\e[0m %-20s| %-2s %-2s %-2s %-2s |  %-2s %-2s %-2s %-2s |  %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %-2s %-2s %-2s %-2s | %1s %1s %1s %1s %1s %1s %1s %1s | %1s %1s %1s %1s %1s %1s %1s | %c\n'

rows="%-20s| %-10s | %-10s | %-10s | %-10s | %-10s | %-10s | %-10s |  %-12s |  %c\n"

#clear log file

>$0.log

echo "A: Number of entries in rpext-index.json"
echo "B: Number of recipes for plaform 42218"
echo "C: Number of recipes for plaform 42621"
echo "D: Number of recipes for plaform 42661"
echo "ModArchives: A=All 1=ds3615xs 2=ds3617xs_mods 3=ds918p_mods 3=ds3622xsp_mods 5=dva3221_mods 6=ds920p_mods 7=ds1621p_mods"
echo "Modvalidation: 1=ds3615xs 2=ds3617xs_mods 3=ds918p_mods 3=ds3622xsp_mods 5=dva3221_mods 6=ds920p_mods 7=ds1621p_mods"
echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

#printf "%-20s" "aaa" "bbb" "ccc"  "eee" "fff" "ggg" "hhh"
#printf "| extension | ds3615xs | ds3617xs | ds918p | ds3622xsp | dva3221 | ds920p | ds1621p |\n" 40 40 40 40 40 40 40 40
printf "$header" Extension_Name ds3615xs ds3617xs ds918p ds3622xsp dva3221 ds920p ds1621p modarchive modvalidation
printf "$subheader" Subtests A B C D A B C D A B C D A B C D A B C D A B C D A B C D A 1 2 3 4 5 6 7 1 2 3 4 5 6 7
echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

for ext in $(cat exts); do
        ds3615xs_dir_files=$(grep 3615 $ext/rp* | wc -l)
        ds3617xs_dir_files=$(grep 3617 $ext/rp* | wc -l)
        ds918p_dir_files=$(grep 918 $ext/rp* | wc -l)
        ds3622xsp_dir_files=$(grep 3622 $ext/rp* | wc -l)
        dva3221_dir_files=$(grep 3221 $ext/rp* | wc -l)
        ds920p_dir_files=$(grep 920 $ext/rp* | wc -l)
        ds1621p_dir_files=$(grep 1621 $ext/rp* | wc -l)
        modarchives=$(ls -l $ext/releases/*.tgz | wc -l)

        ds3615xs_tars=$(grep 3615 $ext/rp* | wc -l)
        ds3617xs_tars=$(grep 3617 $ext/rp* | wc -l)
        ds918p_tars=$(grep 918 $ext/rp* | wc -l)
        ds3622xsp_tars=$(grep 3622 $ext/rp* | wc -l)
        dva3221_tars=$(grep 3221 $ext/rp* | wc -l)
        ds920p_tars=$(grep 920 $ext/rp* | wc -l)
        ds1621p_tars=$(grep 1621 $ext/rp* | wc -l)

        ds3615xs_tars=$(grep 3615 $ext/rp* | wc -l)
        ds3617xs_tars=$(grep 3617 $ext/rp* | wc -l)
        ds918p_tars=$(grep 918 $ext/rp* | wc -l)
        ds3622xsp_tars=$(grep 3622 $ext/rp* | wc -l)
        dva3221_tars=$(grep 3221 $ext/rp* | wc -l)
        ds920p_tars=$(grep 920 $ext/rp* | wc -l)
        ds1621p_tars=$(grep 1621 $ext/rp* | wc -l)

        ds3615xs_42218=$(grep 3615 $ext/rp* | grep 42218 | wc -l)
        ds3617xs_42218=$(grep 3617 $ext/rp* | grep 42218 | wc -l)
        ds918p_42218=$(grep 918 $ext/rp* | grep 42218 | wc -l)
        ds3622xsp_42218=$(grep 3622 $ext/rp* | grep 42218 | wc -l)
        dva3221_42218=$(grep 3221 $ext/rp* | grep 42218 | wc -l)
        ds920p_42218=$(grep 920 $ext/rp* | grep 42218 | wc -l)
        ds1621p_42218=$(grep 1621 $ext/rp* | grep 42218 | wc -l)

        ds3615xs_42621=$(grep 3615 $ext/rp* | grep 42621 | wc -l)
        ds3617xs_42621=$(grep 3617 $ext/rp* | grep 42621 | wc -l)
        ds918p_42621=$(grep 918 $ext/rp* | grep 42621 | wc -l)
        ds3622xsp_42621=$(grep 3622 $ext/rp* | grep 42621 | wc -l)
        dva3221_42621=$(grep 3221 $ext/rp* | grep 42621 | wc -l)
        ds920p_42621=$(grep 920 $ext/rp* | grep 42621 | wc -l)
        ds1621p_42621=$(grep 1621 $ext/rp* | grep 42621 | wc -l)

        ds3615xs_42661=$(grep 3615 $ext/rp* | grep -i 42661 | wc -l)
        ds3617xs_42661=$(grep 3617 $ext/rp* | grep -i 42661 | wc -l)
        ds918p_42661=$(grep 918 $ext/rp* | grep -i 42661 | wc -l)
        ds3622xsp_42661=$(grep 3622 $ext/rp* | grep -i 42661 | wc -l)
        dva3221_42661=$(grep 3221 $ext/rp* | grep -i 42661 | wc -l)
        ds920p_42661=$(grep 920 $ext/rp* | grep -i 42661 | wc -l)
        ds1621p_42661=$(grep 1621 $ext/rp* | grep -i 42661 | wc -l)

        ds3615xs_mods=$(find $ext/releases/ -name "*108.tgz" | wc -l)
        ds3617xs_mods=$(find $ext/releases/ -name "*broadwell.tgz" | wc -l)
        ds918p_mods=$(find $ext/releases/ -name "*180plus.tgz" | wc -l)
        ds3622xsp_mods=$(find $ext/releases/ -name "*broadwellnk.tgz" | wc -l)
        dva3221_mods=$(find $ext/releases/ -name "*denverton.tgz" | wc -l)
        ds920p_mods=$(find $ext/releases/ -name "*geminilake.tgz" | wc -l)
        ds1621p_mods=$(find $ext/releases/ -name "*v1000.tgz" | wc -l)

        [ $(grep .ko $ext/releases/ds3615xs_42218.json 2>/dev/null | wc -l) -eq $(tar tvf $ext/releases/$ext-3.10.108.tgz 2>/dev/null | wc -l) ] && ds3615xs_ar="K" || ds3615xs_ar="X"
        [ $(grep .ko $ext/releases/ds3617xs_42218.json 2>/dev/null | wc -l) -eq $(tar tvf $ext/releases/$ext-*broadwell.tgz 2>/dev/null | wc -l) ] && ds3617xs_ar="K" || ds3617xs_ar="X"
        [ $(grep .ko $ext/releases/ds918p_42218.json 2>/dev/null | wc -l) -eq $(tar tvf $ext/releases/$ext-*180plus.tgz 2>/dev/null | wc -l) ] && ds918p_ar="K" || ds918p_ar="X"
        [ $(grep .ko $ext/releases/ds3622xsp_42218.json 2>/dev/null | wc -l) -eq $(tar tvf $ext/releases/$ext-*broadwellnk.tgz 2>/dev/null | wc -l) ] && ds3622xsp_ar="K" || ds3622xsp_ar="X"
        [ $(grep .ko $ext/releases/dva3221_42218.json 2>/dev/null | wc -l) -eq $(tar tvf $ext/releases/$ext-*denverton.tgz 2>/dev/null | wc -l) ] && dva3221_ar="K" || dva3221_ar="X"
        [ $(grep .ko $ext/releases/ds920p_42218.json 2>/dev/null | wc -l) -eq $(tar tvf $ext/releases/$ext-*geminilake.tgz 2>/dev/null | wc -l) ] && ds920p_ar="K" || ds920p_ar="X"
        [ $(grep .ko $ext/releases/ds1621p_42218.json 2>/dev/null | wc -l) -eq $(tar tvf $ext/releases/$ext-*v1000.tgz 2>/dev/null | wc -l) ] && ds1621p_ar="K" || ds1621p_ar="X"

        [ "$ds3615xs_ar" = "X" ] && echo "$ext ds3615xs differs" >>$0.log && grep .ko $ext/releases/ds3615xs_42218.json 2>/dev/null >>$0.log && tar tvf $ext/releases/$ext-3.10.108.tgz 2>/dev/null >>$0.log
        [ "$ds3617xs_ar" = "X" ] && echo "$ext ds3617xs differs" >>$0.log && grep .ko $ext/releases/ds3617xs_42218.json 2>/dev/null >>$0.log && tar tvf $ext/releases/$ext-*broadwell.tgz 2>/dev/null >>$0.log
        [ "$ds918p_ar" = "X" ] && echo "$ext ds918p  differs" >>$0.log && grep .ko $ext/releases/ds918p_42218.json 2>/dev/null >>$0.log && tar tvf $ext/releases/$ext-*180plus.tgz 2>/dev/null >>$0.log
        [ "$ds3622xsp_ar" = "X" ] && echo "$ext ds3622xsp differs" >>$0.log && grep .ko $ext/releases/ds3622xsp_42218.json 2>/dev/null >>$0.log && tar tvf $ext/releases/$ext-*broadwellnk.tgz 2>/dev/null >>$0.log
        [ "$dva3221_ar" = "X" ] && echo "$ext dva3221 differs" >>$0.log && grep .ko $ext/releases/dva3221_42218.json 2>/dev/null >>$0.log && tar tvf $ext/releases/$ext-*denverton.tgz 2>/dev/null >>$0.log
        [ "$ds920p_ar" = "X" ] && echo "$ext ds920p  differs" >>$0.log && grep .ko $ext/releases/ds920p_42218.json 2>/dev/null >>$0.log && tar tvf $ext/releases/$ext-*geminilake.tgz 2>/dev/null >>$0.log
        [ "$ds1621p_ar" = "X" ] && echo "$ext ds1621p differs" >>$0.log && grep .ko $ext/releases/ds1621p_42218.json 2>/dev/null >>$0.log && tar tvf $ext/releases/$ext-*v1000.tgz 2>/dev/null >>$0.log

        [ "$ds3615xs_ar" = "X" ] || [ "$ds3617xs_ar" = "X" ] || [ "$ds918p_ar" = "X" ] || [ "$ds3622xsp_ar" = "X" ] || [ "$dva3221_ar" = "X" ] || [ "$ds920p_ar" = "X" ] || [ "$ds1621p_ar" = "X" ] && checklog="yes"

        printf "$subrow" $ext \
                $ds3615xs_dir_files \
                $ds3615xs_42218 $ds3615xs_42621 $ds3615xs_42661 \
                $ds3617xs_dir_files \
                $ds3617xs_42218 $ds3617xs_42621 $ds3617xs_42661 \
                $ds918p_dir_files \
                $ds918p_42218 $ds918p_42621 $ds918p_42661 \
                $ds3622xsp_dir_files \
                $ds3622xsp_42218 $ds3622xsp_42621 $ds3622xsp_42661 \
                $dva3221_dir_files \
                $dva3221_42218 $dva3221_42621 $dva3221_42661 \
                $ds920p_dir_files \
                $ds920p_42218 $ds920p_42621 $ds920p_42661 \
                $ds1621p_dir_files \
                $ds1621p_42218 $ds1621p_42621 $ds1621p_42661 \
                $modarchives $ds3615xs_mods $ds3617xs_mods $ds918p_mods $ds3622xsp_mods $dva3221_mods $ds920p_mods $ds1621p_mods \
                $ds3615xs_ar $ds3617xs_ar $ds918p_ar $ds3622xsp_ar $dva3221_ar $ds920p_ar $ds1621p_ar

done
echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

[ "$checklog" = "yes" ] && echo "WARNING: Issues found, check log for further info"
